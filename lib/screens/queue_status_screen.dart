import 'dart:async';

import 'package:flutter/material.dart';

import '../api_service.dart';
import '../widgets/common_widgets.dart';

class QueueStatusScreen extends StatefulWidget {
  final String? queueEntryId;

  const QueueStatusScreen({super.key, this.queueEntryId});

  @override
  State<QueueStatusScreen> createState() => _QueueStatusScreenState();
}

class _QueueStatusScreenState extends State<QueueStatusScreen> {
  late Future<Map<String, dynamic>> _dataFuture;
  Timer? _refreshTimer;
  int? _tokenNumber;
  bool _leavingQueue = false;

  @override
  void initState() {
    super.initState();

    // Accepts tokens such as T108-sakshi.
    final match = RegExp(r'T?(\d+)').firstMatch(widget.queueEntryId ?? '');

    if (match != null) {
      _tokenNumber = int.tryParse(match.group(1)!);
    }

    _dataFuture = _loadData();

    // Refresh queue information every 5 seconds.
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted && !_leavingQueue) {
        setState(() {
          _dataFuture = _loadData();
        });
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<Map<String, dynamic>> _loadData() async {
    final token = _tokenNumber;

    if (token == null) {
      throw Exception('Token number is missing. Please join the queue again.');
    }

    final results = await Future.wait([
      ApiService.getTokenStatus(token),
      ApiService.getQueue(),
    ]);

    final statusData = results[0] as Map<String, dynamic>;
    final queue = results[1] as List<String>;

    if (statusData['found'] != true) {
      throw Exception('Token not found. Please join the queue again.');
    }

    final activeTokens = <int>[];

    for (final item in queue) {
      final match = RegExp(r'T?(\d+)').firstMatch(item);
      if (match != null) {
        final number = int.tryParse(match.group(1)!);
        if (number != null) activeTokens.add(number);
      }
    }

    final rawStatus = (statusData['status'] ?? 'WAITING')
        .toString()
        .toUpperCase();

    final isWaiting = rawStatus == 'WAITING';
    final isServing =
        rawStatus == 'CALLED' ||
        rawStatus == 'SERVING' ||
        rawStatus == 'IN_PROGRESS';
    final isCompleted = rawStatus == 'SERVED' || rawStatus == 'COMPLETED';
    final isSkipped = rawStatus == 'SKIPPED';

    final peopleAhead = isWaiting
        ? activeTokens.where((number) => number < token).length
        : 0;

    return {
      'tokenNumber': token,
      'userName': statusData['userName']?.toString() ?? '',
      'status': isWaiting
          ? 'waiting'
          : isServing
          ? 'serving'
          : isCompleted
          ? 'completed'
          : isSkipped
          ? 'skipped'
          : rawStatus.toLowerCase(),
      'peopleAhead': peopleAhead,
      'totalActive': activeTokens.length,
    };
  }

  String _formatStatus(String status) {
    switch (status) {
      case 'waiting':
        return 'WAITING';
      case 'serving':
        return 'YOUR TURN';
      case 'completed':
        return 'COMPLETED';
      case 'skipped':
        return 'SKIPPED';
      default:
        return status.toUpperCase();
    }
  }

  Future<void> _confirmLeaveQueue(int tokenNumber) async {
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Leave Queue?'),
        content: const Text('Are you sure you want to leave this queue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Leave Queue'),
          ),
        ],
      ),
    );

    if (shouldLeave != true || !mounted) return;

    setState(() => _leavingQueue = true);

    try {
      final message = await ApiService.leaveQueue(tokenNumber);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));

      setState(() {
        _dataFuture = _loadData();
        _leavingQueue = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => _leavingQueue = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not leave queue: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightPurple,
      appBar: AppBar(
        backgroundColor: lightPurple,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: darkText,
            size: 20,
          ),
        ),
        title: const Text(
          'Queue Status',
          style: TextStyle(
            color: darkText,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _dataFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 44,
                        color: Colors.redAccent,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        snapshot.error.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: darkText),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _dataFuture = _loadData();
                          });
                        },
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final data = snapshot.data!;
            final tokenNumber = data['tokenNumber'] as int;
            final status = data['status'] as String;
            final peopleAhead = data['peopleAhead'] as int;
            final totalActive = data['totalActive'] as int;

            final estimatedMinutes = status == 'serving' ? 0 : peopleAhead * 5;

            final progress = totalActive == 0
                ? 0.0
                : (1 - peopleAhead / totalActive).clamp(0.0, 1.0).toDouble();

            const serviceName = 'General Service';
            const queueType = 'General Queue';

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 18,
                          offset: const Offset(0, 7),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: status == 'serving'
                                ? lightMint
                                : const Color(0xFFFFF2D9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _formatStatus(status),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: status == 'serving'
                                  ? mintGreen
                                  : const Color(0xFF986900),
                              letterSpacing: 0.7,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Your Token',
                          style: TextStyle(fontSize: 12, color: greyText),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'T$tokenNumber',
                          style: const TextStyle(
                            fontSize: 46,
                            fontWeight: FontWeight.bold,
                            color: primaryPurple,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          serviceName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: darkText,
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          queueType,
                          style: TextStyle(fontSize: 11, color: greyText),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Your Queue Position',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: darkText,
                    ),
                  ),
                  const SizedBox(height: 13),
                  Row(
                    children: [
                      Expanded(
                        child: _StatusCard(
                          icon: Icons.confirmation_num_outlined,
                          value: tokenNumber.toString(),
                          label: 'Your Token',
                          color: primaryPurple,
                          background: lightPurple,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _StatusCard(
                          icon: Icons.people_alt_outlined,
                          value: peopleAhead.toString(),
                          label: 'People Ahead',
                          color: mintGreen,
                          background: lightMint,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _StatusCard(
                          icon: Icons.access_time_rounded,
                          value: '${estimatedMinutes}m',
                          label: 'Est. Wait',
                          color: primaryPurple,
                          background: lightPurple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Queue Progress',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: darkText,
                              ),
                            ),
                            Text(
                              '$peopleAhead ahead',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: primaryPurple,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 9,
                            backgroundColor: const Color(0xFFE8E3F4),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              primaryPurple,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          status == 'serving'
                              ? 'It is your turn!'
                              : status == 'completed'
                              ? 'Service completed'
                              : status == 'skipped'
                              ? 'This token was skipped'
                              : 'Your position refreshes every 5 seconds',
                          style: const TextStyle(
                            fontSize: 11,
                            color: mintGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(17),
                    decoration: BoxDecoration(
                      color: lightMint,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: mintGreen.withValues(alpha: 0.15),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.notifications_active_outlined,
                          color: mintGreen,
                          size: 28,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'We will remind you',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: darkText,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Queue notification support will be connected separately.',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: greyText,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Queue Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: darkText,
                    ),
                  ),
                  const SizedBox(height: 13),
                  AppCard(
                    child: Column(
                      children: [
                        _DetailRow(
                          icon: Icons.miscellaneous_services_outlined,
                          title: 'Service',
                          value: serviceName,
                        ),
                        const Divider(height: 24, color: Color(0xFFEDEAF3)),
                        _DetailRow(
                          icon: Icons.access_time_rounded,
                          title: 'Joined At',
                          value: 'Not available',
                        ),
                        const Divider(height: 24, color: Color(0xFFEDEAF3)),
                        _DetailRow(
                          icon: Icons.people_alt_outlined,
                          title: 'Active in Queue',
                          value: totalActive.toString(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: OutlinedButton(
                      onPressed: status == 'waiting' && !_leavingQueue
                          ? () => _confirmLeaveQueue(tokenNumber)
                          : null,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                        side: const BorderSide(color: Color(0xFFE3B9B9)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      child: Text(
                        _leavingQueue ? 'Leaving...' : 'Leave Queue',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final Color background;

  const _StatusCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 7),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: darkText,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 9, color: greyText),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: lightPurple,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: primaryPurple, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 12, color: greyText),
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: darkText,
            ),
          ),
        ),
      ],
    );
  }
}
