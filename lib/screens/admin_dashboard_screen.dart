import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/common_widgets.dart';
import 'queue_management_screen.dart';
import 'service_management_screen.dart';
import 'admin_profile_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final CollectionReference<Map<String, dynamic>> _entries = FirebaseFirestore
      .instance
      .collection('queue_entries');

  int _refreshKey = 0;

  void _openQueues() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QueueManagementScreen()),
    );
  }

  void _openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AdminProfileScreen()),
    );
  }

  void _openServices() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ServiceManagementScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightPurple,
      appBar: AppBar(
        backgroundColor: lightPurple,
        elevation: 0,
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            color: darkText,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => setState(() => _refreshKey++),
            tooltip: 'Refresh dashboard',
            icon: const Icon(Icons.refresh, color: darkText),
          ),
          IconButton(
            onPressed: _openProfile,
            tooltip: 'Admin Profile',
            icon: const Icon(Icons.person_outline, color: darkText),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        key: ValueKey(_refreshKey),
        stream: _entries.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Unable to load dashboard data.'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          final dataList = docs.map((doc) => doc.data()).toList();

          final waiting = dataList
              .where((data) => data['status'] == 'waiting')
              .length;

          final completed = dataList
              .where((data) => data['status'] == 'completed')
              .length;

          final queueGroups = <String, List<Map<String, dynamic>>>{};

          for (final data in dataList) {
            final type = data['queueType'] as String? ?? '';
            final service = data['serviceName'] as String? ?? '';

            if (type.isEmpty || service.isEmpty) continue;

            final key = '$type|||$service';
            queueGroups.putIfAbsent(key, () => []);
            queueGroups[key]!.add(data);
          }

          final queueKeys = queueGroups.keys.toList()..sort();
          final activeKey = queueKeys.isEmpty ? null : queueKeys.first;

          final activeQueue = activeKey == null
              ? <Map<String, dynamic>>[]
              : List<Map<String, dynamic>>.from(queueGroups[activeKey]!);

          activeQueue.sort((a, b) {
            final aValue = (a['tokenValue'] as num?)?.toInt() ?? 0;
            final bValue = (b['tokenValue'] as num?)?.toInt() ?? 0;
            return aValue.compareTo(bValue);
          });

          final currentForQueue = activeQueue.where(
            (data) => data['status'] == 'serving',
          );

          final currentToken = currentForQueue.isEmpty
              ? '—'
              : currentForQueue.first['tokenNumber']?.toString() ?? '—';

          final queueWaiting = activeQueue
              .where((data) => data['status'] == 'waiting')
              .length;

          final queueParts = activeKey?.split('|||') ?? [];
          final activeType = queueParts.isNotEmpty ? queueParts[0] : '';
          final activeService = queueParts.length > 1 ? queueParts[1] : '';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome, Admin 👋',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: darkText,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Manage your queues from one place',
                  style: TextStyle(fontSize: 14, color: greyText),
                ),
                const SizedBox(height: 25),

                const Text(
                  "Today's Overview",
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
                      child: _statCard(
                        icon: Icons.people_outline,
                        title: 'Waiting',
                        value: '$waiting',
                        color: primaryPurple,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _statCard(
                        icon: Icons.confirmation_number_outlined,
                        title: 'Tokens',
                        value: '${docs.length}',
                        color: mintGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        icon: Icons.access_time,
                        title: 'Avg. Wait',
                        value: '${waiting * 5} min',
                        color: primaryPurple,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _statCard(
                        icon: Icons.check_circle_outline,
                        title: 'Completed',
                        value: '$completed',
                        color: mintGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                const Text(
                  'Active Queue',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: darkText,
                  ),
                ),
                const SizedBox(height: 14),

                AppCard(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: lightPurple,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Icon(
                              Icons.groups_outlined,
                              color: primaryPurple,
                              size: 27,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  activeService.isEmpty
                                      ? 'No Active Queue'
                                      : activeService,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: darkText,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  activeType.isEmpty
                                      ? 'Queue details appear here'
                                      : activeType,
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
                              color: activeQueue.isEmpty
                                  ? Colors.grey.shade200
                                  : lightMint,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              activeQueue.isEmpty ? 'No Queue' : 'Live',
                              style: TextStyle(
                                color: activeQueue.isEmpty
                                    ? greyText
                                    : mintGreen,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const Divider(),
                      const SizedBox(height: 14),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Current Token',
                            style: TextStyle(color: greyText),
                          ),
                          Text(
                            currentToken,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: primaryPurple,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'People Waiting',
                            style: TextStyle(color: greyText),
                          ),
                          Text(
                            '$queueWaiting people',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: darkText,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _openQueues,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryPurple,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Manage Queue'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryPurple,
        unselectedItemColor: greyText,
        backgroundColor: Colors.white,
        onTap: (index) {
          if (index == 1) _openQueues();
          if (index == 2) _openServices();
          if (index == 3) _openProfile();
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.queue_outlined),
            label: 'Queues',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.miscellaneous_services_outlined),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 27),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: darkText,
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 12, color: greyText)),
        ],
      ),
    );
  }
}
