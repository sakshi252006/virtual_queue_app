import 'package:flutter/material.dart';

import '../widgets/common_widgets.dart';
import 'queue_status_screen.dart';

class MyQueueScreen extends StatelessWidget {
  const MyQueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightPurple,

      appBar: AppBar(
        backgroundColor: lightPurple,
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: darkText,
            size: 20,
          ),
        ),

        title: const Text(
          'My Queue',
          style: TextStyle(
            color: darkText,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ------------------------------------------------
              // PAGE TITLE
              // ------------------------------------------------
              const Text(
                'Your Active Queue',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Track your current queue in real time.',
                style: TextStyle(fontSize: 12, color: greyText),
              ),

              const SizedBox(height: 18),

              // ------------------------------------------------
              // ACTIVE QUEUE CARD
              // ------------------------------------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(19),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(23),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status row
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,

                          decoration: BoxDecoration(
                            color: lightPurple,
                            borderRadius: BorderRadius.circular(14),
                          ),

                          child: const Icon(
                            Icons.local_hospital_outlined,
                            color: primaryPurple,
                            size: 26,
                          ),
                        ),

                        const SizedBox(width: 12),

                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'City Care Hospital',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: darkText,
                                ),
                              ),

                              SizedBox(height: 4),

                              Text(
                                'Doctor Consultation',
                                style: TextStyle(fontSize: 11, color: greyText),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 6,
                          ),

                          decoration: BoxDecoration(
                            color: lightMint,
                            borderRadius: BorderRadius.circular(20),
                          ),

                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.circle, size: 7, color: mintGreen),

                              SizedBox(width: 5),

                              Text(
                                'Active',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: mintGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Token
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15),

                      decoration: BoxDecoration(
                        color: lightPurple,
                        borderRadius: BorderRadius.circular(17),
                      ),

                      child: Column(
                        children: [
                          const Text(
                            'YOUR TOKEN',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: greyText,
                              letterSpacing: 1,
                            ),
                          ),

                          const SizedBox(height: 3),

                          const Text(
                            'A-24',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: primaryPurple,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Queue stats
                    Row(
                      children: [
                        Expanded(
                          child: _QueueInfo(
                            icon: Icons.people_alt_outlined,
                            value: '12',
                            label: 'People Ahead',
                            color: primaryPurple,
                            background: lightPurple,
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: _QueueInfo(
                            icon: Icons.access_time_rounded,
                            value: '25 min',
                            label: 'Estimated Wait',
                            color: mintGreen,
                            background: lightMint,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Progress
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Queue Progress',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: darkText,
                          ),
                        ),

                        Text(
                          '65%',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: primaryPurple,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),

                      child: const LinearProgressIndicator(
                        value: 0.65,
                        minHeight: 8,
                        backgroundColor: Color(0xFFE8E3F4),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          primaryPurple,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // View status button
                    SizedBox(
                      width: double.infinity,
                      height: 45,

                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const QueueStatusScreen(),
                            ),
                          );
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryPurple,
                          foregroundColor: Colors.white,
                          elevation: 0,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),

                        child: const Text(
                          'View Live Status',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // ------------------------------------------------
              // NOTIFICATION CARD
              // ------------------------------------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: lightMint,
                  borderRadius: BorderRadius.circular(18),

                  border: Border.all(color: mintGreen.withValues(alpha: 0.15)),
                ),

                child: Row(
                  children: [
                    Container(
                      width: 43,
                      height: 43,

                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.notifications_active_outlined,
                        color: mintGreen,
                        size: 22,
                      ),
                    ),

                    const SizedBox(width: 12),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notifications are ON',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: darkText,
                            ),
                          ),

                          SizedBox(height: 4),

                          Text(
                            'We will remind you when your turn is near.',
                            style: TextStyle(
                              fontSize: 10,
                              color: greyText,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ------------------------------------------------
              // QUEUE HISTORY
              // ------------------------------------------------
              const Text(
                'Recent Queues',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),

              const SizedBox(height: 13),

              _HistoryCard(
                icon: Icons.account_balance_outlined,
                title: 'ABC Bank',
                subtitle: 'Cash Counter',
                date: 'Yesterday',
                status: 'Completed',
                iconColor: mintGreen,
                iconBackground: lightMint,
              ),

              const SizedBox(height: 11),

              _HistoryCard(
                icon: Icons.local_hospital_outlined,
                title: 'City Care Hospital',
                subtitle: 'Registration',
                date: '02 Sep 2026',
                status: 'Completed',
                iconColor: primaryPurple,
                iconBackground: lightPurple,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// QUEUE INFO
// ============================================================

class _QueueInfo extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final Color background;

  const _QueueInfo({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 7),

      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(15),
      ),

      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,

            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),

            child: Icon(icon, color: color, size: 18),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: darkText,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  label,
                  style: const TextStyle(fontSize: 8, color: greyText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// HISTORY CARD
// ============================================================

class _HistoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String date;
  final String status;
  final Color iconColor;
  final Color iconBackground;

  const _HistoryCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.status,
    required this.iconColor,
    required this.iconBackground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),

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

      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,

            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(13),
            ),

            child: Icon(icon, color: iconColor, size: 23),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: darkText,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 10, color: greyText),
                ),

                const SizedBox(height: 3),

                Text(
                  date,
                  style: const TextStyle(fontSize: 9, color: greyText),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),

            decoration: BoxDecoration(
              color: lightMint,
              borderRadius: BorderRadius.circular(10),
            ),

            child: Text(
              status,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: mintGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
