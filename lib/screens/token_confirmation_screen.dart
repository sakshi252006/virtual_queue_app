import 'package:flutter/material.dart';

import '../widgets/common_widgets.dart';
import 'queue_status_screen.dart';

class TokenConfirmationScreen extends StatelessWidget {
  final String queueType;
  final String serviceName;
  final String tokenNumber;
  final String queueEntryId;

  const TokenConfirmationScreen({
    super.key,
    required this.queueType,
    required this.serviceName,
    required this.tokenNumber,
    required this.queueEntryId,
  });

  // Open Queue Status with the current queue entry ID.
  void openQueueStatus(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QueueStatusScreen(queueEntryId: queueEntryId),
      ),
    );
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
          'Token Confirmation',
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
            children: [
              // SUCCESS ICON
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: lightMint,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: mintGreen,
                  size: 40,
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                'You are in the Queue!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Your digital token has been generated successfully.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: greyText),
              ),

              const SizedBox(height: 25),

              // TOKEN CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
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
                    const Text(
                      'YOUR TOKEN',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        color: greyText,
                      ),
                    ),

                    const SizedBox(height: 7),

                    // Dynamic token number
                    Text(
                      tokenNumber,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: primaryPurple,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Container(
                      width: 55,
                      height: 4,
                      decoration: BoxDecoration(
                        color: mintGreen,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // SELECTED SERVICE
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: lightPurple,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 43,
                            height: 43,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: Icon(
                              getServiceIcon(),
                              color: primaryPurple,
                              size: 23,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  queueType,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: greyText,
                                  ),
                                ),

                                const SizedBox(height: 3),

                                Text(
                                  serviceName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: darkText,
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

              const SizedBox(height: 18),

              // QUEUE INFORMATION
              Row(
                children: [
                  Expanded(
                    child: InfoCard(
                      icon: Icons.people_alt_outlined,
                      title: 'Calculating...',
                      subtitle: 'People Ahead',
                      iconColor: primaryPurple,
                      backgroundColor: lightPurple,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: InfoCard(
                      icon: Icons.access_time_rounded,
                      title: 'Calculating...',
                      subtitle: 'Estimated Wait',
                      iconColor: mintGreen,
                      backgroundColor: lightMint,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // NOTIFICATION INFORMATION
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
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_none_rounded,
                        color: mintGreen,
                        size: 21,
                      ),
                    ),

                    const SizedBox(width: 11),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'We will notify you',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: darkText,
                            ),
                          ),

                          SizedBox(height: 4),

                          Text(
                            'You will receive a notification when '
                            'your turn is getting closer.',
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

              const SizedBox(height: 25),

              // VIEW QUEUE STATUS
              AppButton(
                text: 'View Queue Status',
                onPressed: () {
                  openQueueStatus(context);
                },
              ),

              const SizedBox(height: 10),

              // BACK TO HOME
              TextButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text(
                  'Back to Home',
                  style: TextStyle(
                    color: greyText,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData getServiceIcon() {
    if (queueType == 'Hospital') {
      return Icons.local_hospital_outlined;
    }

    if (queueType == 'Bank') {
      return Icons.account_balance_outlined;
    }

    return Icons.miscellaneous_services_outlined;
  }
}

// ============================================================
// INFO CARD
// ============================================================

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final Color backgroundColor;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),

          const SizedBox(height: 9),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: darkText,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: greyText),
          ),
        ],
      ),
    );
  }
}
