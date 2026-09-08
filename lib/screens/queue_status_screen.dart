import 'package:flutter/material.dart';

import '../widgets/common_widgets.dart';

class QueueStatusScreen extends StatelessWidget {
  const QueueStatusScreen({super.key});

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ------------------------------------------------
              // CURRENT STATUS
              // ------------------------------------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),

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
                    // Status
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 7,
                      ),

                      decoration: BoxDecoration(
                        color: lightMint,
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, size: 8, color: mintGreen),

                          SizedBox(width: 6),

                          Text(
                            'LIVE QUEUE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: mintGreen,
                              letterSpacing: 0.7,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      'Your Token',
                      style: TextStyle(fontSize: 12, color: greyText),
                    ),

                    const SizedBox(height: 3),

                    const Text(
                      'A-24',
                      style: TextStyle(
                        fontSize: 46,
                        fontWeight: FontWeight.bold,
                        color: primaryPurple,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      'Doctor Consultation',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: darkText,
                      ),
                    ),

                    const SizedBox(height: 3),

                    const Text(
                      'City Care Hospital',
                      style: TextStyle(fontSize: 11, color: greyText),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ------------------------------------------------
              // QUEUE POSITION
              // ------------------------------------------------
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
                      value: '24',
                      label: 'Your Token',
                      color: primaryPurple,
                      background: lightPurple,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _StatusCard(
                      icon: Icons.people_alt_outlined,
                      value: '12',
                      label: 'People Ahead',
                      color: mintGreen,
                      background: lightMint,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _StatusCard(
                      icon: Icons.access_time_rounded,
                      value: '25m',
                      label: 'Est. Wait',
                      color: primaryPurple,
                      background: lightPurple,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ------------------------------------------------
              // PROGRESS
              // ------------------------------------------------
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

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),

                          decoration: BoxDecoration(
                            color: lightPurple,
                            borderRadius: BorderRadius.circular(10),
                          ),

                          child: const Text(
                            '12 ahead',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: primaryPurple,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),

                      child: const LinearProgressIndicator(
                        value: 0.65,
                        minHeight: 9,
                        backgroundColor: Color(0xFFE8E3F4),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          primaryPurple,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Queue started',
                          style: TextStyle(fontSize: 10, color: greyText),
                        ),

                        Text(
                          'Your turn getting closer',
                          style: TextStyle(
                            fontSize: 10,
                            color: mintGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ------------------------------------------------
              // TURN INFORMATION
              // ------------------------------------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(17),

                decoration: BoxDecoration(
                  color: lightMint,
                  borderRadius: BorderRadius.circular(18),

                  border: Border.all(color: mintGreen.withValues(alpha: 0.15)),
                ),

                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,

                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.notifications_active_outlined,
                        color: mintGreen,
                        size: 24,
                      ),
                    ),

                    const SizedBox(width: 12),

                    const Expanded(
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
                            'You will get a notification when your turn is near.',
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

              // ------------------------------------------------
              // QUEUE DETAILS
              // ------------------------------------------------
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
                      icon: Icons.local_hospital_outlined,
                      title: 'Service',
                      value: 'Doctor Consultation',
                    ),

                    const Divider(height: 24, color: Color(0xFFEDEAF3)),

                    _DetailRow(
                      icon: Icons.access_time_rounded,
                      title: 'Joined At',
                      value: '10:30 AM',
                    ),

                    const Divider(height: 24, color: Color(0xFFEDEAF3)),

                    _DetailRow(
                      icon: Icons.people_alt_outlined,
                      title: 'Total in Queue',
                      value: '36',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ------------------------------------------------
              // LEAVE QUEUE
              // ------------------------------------------------
              SizedBox(
                width: double.infinity,
                height: 46,

                child: OutlinedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Leave Queue?'),

                          content: const Text(
                            'Are you sure you want to leave this queue?',
                          ),

                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },

                              child: const Text('Cancel'),
                            ),

                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('You have left the queue.'),
                                  ),
                                );
                              },

                              child: const Text('Leave Queue'),
                            ),
                          ],
                        );
                      },
                    );
                  },

                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,

                    side: const BorderSide(color: Color(0xFFE3B9B9)),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),

                  child: const Text(
                    'Leave Queue',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// STATUS CARD
// ============================================================

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
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 5),

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

// ============================================================
// DETAIL ROW
// ============================================================

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

        Text(
          value,
          textAlign: TextAlign.right,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: darkText,
          ),
        ),
      ],
    );
  }
}
