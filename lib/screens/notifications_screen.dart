import 'package:flutter/material.dart';

import '../widgets/common_widgets.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

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
          'Notifications',
          style: TextStyle(
            color: darkText,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,

        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All notifications marked as read.'),
                ),
              );
            },
            icon: const Icon(
              Icons.done_all_rounded,
              color: primaryPurple,
              size: 22,
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ------------------------------------------------
              // HEADER
              // ------------------------------------------------
              const Text(
                'Stay Updated',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Important updates about your queues.',
                style: TextStyle(fontSize: 12, color: greyText),
              ),

              const SizedBox(height: 20),

              // ------------------------------------------------
              // TODAY
              // ------------------------------------------------
              const Text(
                'Today',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),

              const SizedBox(height: 12),

              // Turn Near
              _NotificationCard(
                icon: Icons.notifications_active_outlined,
                title: 'Your turn is getting closer!',
                message: 'You have 3 people ahead of you in the queue.',
                time: '10 min ago',
                iconColor: mintGreen,
                iconBackground: lightMint,
                unread: true,
              ),

              const SizedBox(height: 11),

              // Queue update
              _NotificationCard(
                icon: Icons.update_rounded,
                title: 'Queue updated',
                message: 'Your current position is now 12.',
                time: '25 min ago',
                iconColor: primaryPurple,
                iconBackground: lightPurple,
                unread: true,
              ),

              const SizedBox(height: 11),

              // Joined
              _NotificationCard(
                icon: Icons.confirmation_num_outlined,
                title: 'Queue joined successfully',
                message: 'Your token A-24 has been generated.',
                time: '10:30 AM',
                iconColor: primaryPurple,
                iconBackground: lightPurple,
                unread: false,
              ),

              const SizedBox(height: 25),

              // ------------------------------------------------
              // EARLIER
              // ------------------------------------------------
              const Text(
                'Earlier',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),

              const SizedBox(height: 12),

              _NotificationCard(
                icon: Icons.check_circle_outline_rounded,
                title: 'Queue completed',
                message: 'Your visit at ABC Bank was completed successfully.',
                time: 'Yesterday',
                iconColor: mintGreen,
                iconBackground: lightMint,
                unread: false,
              ),

              const SizedBox(height: 11),

              _NotificationCard(
                icon: Icons.access_time_rounded,
                title: 'Queue reminder',
                message: 'Your estimated waiting time was 20 minutes.',
                time: '02 Sep',
                iconColor: primaryPurple,
                iconBackground: lightPurple,
                unread: false,
              ),

              const SizedBox(height: 25),

              // ------------------------------------------------
              // INFO CARD
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
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Container(
                      width: 42,
                      height: 42,

                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.notifications_none_rounded,
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
                            'Never miss your turn',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: darkText,
                            ),
                          ),

                          SizedBox(height: 4),

                          Text(
                            'Keep notifications enabled to receive live queue updates.',
                            style: TextStyle(
                              fontSize: 11,
                              height: 1.4,
                              color: greyText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
// NOTIFICATION CARD
// ============================================================

class _NotificationCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String time;
  final Color iconColor;
  final Color iconBackground;
  final bool unread;

  const _NotificationCard({
    required this.icon,
    required this.title,
    required this.message,
    required this.time,
    required this.iconColor,
    required this.iconBackground,
    required this.unread,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),

        border: unread
            ? Border.all(color: primaryPurple.withValues(alpha: 0.12))
            : null,

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 11,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 47,
            height: 47,

            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(14),
            ),

            child: Icon(icon, color: iconColor, size: 24),
          ),

          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: darkText,
                        ),
                      ),
                    ),

                    if (unread)
                      Container(
                        width: 7,
                        height: 7,

                        margin: const EdgeInsets.only(top: 4, left: 6),

                        decoration: const BoxDecoration(
                          color: primaryPurple,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 5),

                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 10,
                    height: 1.4,
                    color: greyText,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  time,
                  style: const TextStyle(fontSize: 9, color: greyText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
