import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';

class QueueManagementScreen extends StatefulWidget {
  const QueueManagementScreen({super.key});

  @override
  State<QueueManagementScreen> createState() => _QueueManagementScreenState();
}

class _QueueManagementScreenState extends State<QueueManagementScreen> {
  final CollectionReference<Map<String, dynamic>> _entries = FirebaseFirestore
      .instance
      .collection('queue_entries');

  final CollectionReference<Map<String, dynamic>> _counters = FirebaseFirestore
      .instance
      .collection('queue_counters');

  String? _selectedQueueKey;
  int _refreshKey = 0;
  bool _processing = false;

  String _keyFor(String type, String service) => '$type|||$service';

  List<String> _splitKey(String key) {
    final parts = key.split('|||');
    return [parts[0], parts.length > 1 ? parts[1] : ''];
  }

  void _message(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<QuerySnapshot<Map<String, dynamic>>> _getQueueEntries(
    String type,
    String service,
  ) {
    return _entries
        .where('queueType', isEqualTo: type)
        .where('serviceName', isEqualTo: service)
        .get();
  }

  Future<bool> _isQueuePaused(String type, String service) async {
    final snapshot = await _counters
        .where('queueType', isEqualTo: type)
        .where('serviceName', isEqualTo: service)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return false;

    return snapshot.docs.first.data()['paused'] == true;
  }

  Future<void> _callNext(String type, String service) async {
    if (_processing) return;

    setState(() => _processing = true);

    try {
      if (await _isQueuePaused(type, service)) {
        _message('Queue is paused. Resume it before calling the next token.');
        return;
      }

      final snapshot = await _getQueueEntries(type, service);
      final docs = snapshot.docs.toList()
        ..sort((a, b) {
          final aValue = (a.data()['tokenValue'] as num?)?.toInt() ?? 0;
          final bValue = (b.data()['tokenValue'] as num?)?.toInt() ?? 0;
          return aValue.compareTo(bValue);
        });

      final waiting = docs
          .where((doc) => doc.data()['status'] == 'waiting')
          .toList();

      final serving = docs
          .where((doc) => doc.data()['status'] == 'serving')
          .toList();

      if (waiting.isEmpty) {
        _message('No waiting tokens in this queue.');
        return;
      }

      final batch = FirebaseFirestore.instance.batch();
      final now = FieldValue.serverTimestamp();

      // Mark the previous serving token as completed.
      for (final doc in serving) {
        batch.update(doc.reference, {
          'status': 'completed',
          'completedAt': now,
        });
      }

      // Call the next token.
      batch.update(waiting.first.reference, {
        'status': 'serving',
        'calledAt': now,
      });

      await batch.commit();

      _message('Called token ${waiting.first.data()['tokenNumber']}.');
    } catch (e) {
      _message('Could not call next token. Please try again.');
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  Future<void> _skipCurrent(String type, String service) async {
    if (_processing) return;

    setState(() => _processing = true);

    try {
      final snapshot = await _getQueueEntries(type, service);

      final serving = snapshot.docs
          .where((doc) => doc.data()['status'] == 'serving')
          .toList();

      if (serving.isEmpty) {
        _message('There is no currently serving token to skip.');
        return;
      }

      serving.sort((a, b) {
        final aValue = (a.data()['tokenValue'] as num?)?.toInt() ?? 0;
        final bValue = (b.data()['tokenValue'] as num?)?.toInt() ?? 0;
        return aValue.compareTo(bValue);
      });

      final current = serving.first;
      await current.reference.update({
        'status': 'skipped',
        'skippedAt': FieldValue.serverTimestamp(),
      });

      _message('Token ${current.data()['tokenNumber']} skipped.');
    } catch (e) {
      _message('Could not skip the token. Please try again.');
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  Future<void> _togglePause(
    String type,
    String service,
    bool currentlyPaused,
  ) async {
    if (_processing) return;

    setState(() => _processing = true);

    try {
      final snapshot = await _counters
          .where('queueType', isEqualTo: type)
          .where('serviceName', isEqualTo: service)
          .limit(1)
          .get();

      final data = {
        'queueType': type,
        'serviceName': service,
        'paused': !currentlyPaused,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (snapshot.docs.isEmpty) {
        await _counters.add({
          ...data,
          'lastToken': 0,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        await snapshot.docs.first.reference.update(data);
      }

      _message(currentlyPaused ? 'Queue resumed.' : 'Queue paused.');
    } catch (e) {
      _message('Could not update queue status. Please try again.');
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightPurple,
      appBar: AppBar(
        backgroundColor: lightPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: darkText),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Queue Management',
          style: TextStyle(color: darkText, fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        key: ValueKey(_refreshKey),
        stream: _entries.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Unable to load queue data.'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final allDocs = snapshot.data!.docs;

          // Build the list of queues from existing queue entries.
          final queueNames = <String, List<String>>{};

          for (final doc in allDocs) {
            final data = doc.data();
            final type = data['queueType'] as String? ?? '';
            final service = data['serviceName'] as String? ?? '';

            if (type.isEmpty || service.isEmpty) continue;

            final key = _keyFor(type, service);
            queueNames.putIfAbsent(key, () => [type, service]);
          }

          if (queueNames.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.people_outline, size: 56, color: primaryPurple),
                    SizedBox(height: 12),
                    Text(
                      'No queue entries yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: darkText,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Queues will appear here after a user joins a service.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: greyText),
                    ),
                  ],
                ),
              ),
            );
          }

          final keys = queueNames.keys.toList()..sort();
          final selectedKey =
              _selectedQueueKey != null &&
                  queueNames.containsKey(_selectedQueueKey)
              ? _selectedQueueKey!
              : keys.first;

          final selected = queueNames[selectedKey]!;
          final queueType = selected[0];
          final serviceName = selected[1];

          final queueDocs =
              allDocs.where((doc) {
                final data = doc.data();
                return data['queueType'] == queueType &&
                    data['serviceName'] == serviceName;
              }).toList()..sort((a, b) {
                final aValue = (a.data()['tokenValue'] as num?)?.toInt() ?? 0;
                final bValue = (b.data()['tokenValue'] as num?)?.toInt() ?? 0;
                return aValue.compareTo(bValue);
              });

          final waiting = queueDocs
              .where((doc) => doc.data()['status'] == 'waiting')
              .toList();

          final serving = queueDocs
              .where((doc) => doc.data()['status'] == 'serving')
              .toList();

          final completed = queueDocs
              .where((doc) => doc.data()['status'] == 'completed')
              .length;

          final currentToken = serving.isEmpty
              ? '—'
              : serving.first.data()['tokenNumber']?.toString() ?? '—';

          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _counters
                .where('queueType', isEqualTo: queueType)
                .where('serviceName', isEqualTo: serviceName)
                .limit(1)
                .snapshots(),
            builder: (context, counterSnapshot) {
              final paused =
                  counterSnapshot.hasData &&
                  counterSnapshot.data!.docs.isNotEmpty &&
                  counterSnapshot.data!.docs.first.data()['paused'] == true;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Select Queue',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: darkText,
                            ),
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: selectedKey,
                            isExpanded: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: lightPurple,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            items: keys.map((key) {
                              final details = queueNames[key]!;
                              return DropdownMenuItem<String>(
                                value: key,
                                child: Text(
                                  '${details[0]} — ${details[1]}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _selectedQueueKey = value);
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: lightPurple,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.groups_outlined,
                                  color: primaryPurple,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      serviceName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: darkText,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      queueType,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: greyText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: paused
                                      ? Colors.orange.shade100
                                      : lightMint,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  paused ? 'Paused' : 'Active',
                                  style: TextStyle(
                                    color: paused
                                        ? Colors.deepOrange
                                        : mintGreen,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Divider(),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _QueueInfo(title: 'Current', value: currentToken),
                              _QueueInfo(
                                title: 'Waiting',
                                value: '${waiting.length}',
                              ),
                              _QueueInfo(
                                title: 'Completed',
                                value: '$completed',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      'Queue Controls',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: darkText,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _controlButton(
                            icon: Icons.play_arrow,
                            title: 'Call Next',
                            filled: true,
                            onPressed: _processing
                                ? null
                                : () => _callNext(queueType, serviceName),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _controlButton(
                            icon: Icons.skip_next,
                            title: 'Skip',
                            filled: false,
                            onPressed: _processing
                                ? null
                                : () => _skipCurrent(queueType, serviceName),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _controlButton(
                            icon: paused ? Icons.play_arrow : Icons.pause,
                            title: paused ? 'Resume Queue' : 'Pause Queue',
                            filled: false,
                            onPressed: _processing
                                ? null
                                : () => _togglePause(
                                    queueType,
                                    serviceName,
                                    paused,
                                  ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _controlButton(
                            icon: Icons.refresh,
                            title: 'Refresh',
                            filled: false,
                            onPressed: () {
                              setState(() => _refreshKey++);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'People in Queue',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: darkText,
                      ),
                    ),
                    const SizedBox(height: 14),
                    if (queueDocs.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'No tokens in this queue.',
                          style: TextStyle(color: greyText),
                        ),
                      )
                    else
                      ...queueDocs.map((doc) {
                        final data = doc.data();
                        final token =
                            data['tokenNumber']?.toString() ?? 'Unknown';
                        final status = data['status']?.toString() ?? 'unknown';

                        if (status == 'left') {
                          return const SizedBox.shrink();
                        }

                        return _personCard(
                          token: token,
                          name: 'Customer $token',
                          status: status,
                        );
                      }),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _controlButton({
    required IconData icon,
    required String title,
    required bool filled,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      height: 50,
      child: filled
          ? ElevatedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon),
              label: Text(title),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryPurple,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            )
          : OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon),
              label: Text(title),
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryPurple,
                side: const BorderSide(color: primaryPurple),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
    );
  }

  Widget _personCard({
    required String token,
    required String name,
    required String status,
  }) {
    final isServing = status == 'serving';
    final isCompleted = status == 'completed';
    final isSkipped = status == 'skipped';

    final statusColor = isServing
        ? primaryPurple
        : isCompleted
        ? mintGreen
        : isSkipped
        ? Colors.orange
        : greyText;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: lightPurple,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(Icons.person_outline, color: primaryPurple),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: darkText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Token $token',
                  style: const TextStyle(fontSize: 12, color: greyText),
                ),
              ],
            ),
          ),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              color: statusColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _QueueInfo extends StatelessWidget {
  final String title;
  final String value;

  const _QueueInfo({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primaryPurple,
          ),
        ),
        const SizedBox(height: 5),
        Text(title, style: const TextStyle(fontSize: 12, color: greyText)),
      ],
    );
  }
}
