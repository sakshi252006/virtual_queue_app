import 'package:flutter/material.dart';

import '../widgets/common_widgets.dart';
import 'service_selection_screen.dart';

class JoinQueueScreen extends StatelessWidget {
  const JoinQueueScreen({super.key});

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
          'Join Queue',
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
              // QR SCAN CARD
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
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    // QR icon
                    Container(
                      width: 82,
                      height: 82,

                      decoration: BoxDecoration(
                        color: lightPurple,
                        borderRadius: BorderRadius.circular(24),
                      ),

                      child: const Icon(
                        Icons.qr_code_scanner_rounded,
                        size: 46,
                        color: primaryPurple,
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Scan Queue QR',
                      textAlign: TextAlign.center,

                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: darkText,
                      ),
                    ),

                    const SizedBox(height: 7),

                    const Text(
                      'Scan the QR code displayed at the location\nto join the queue instantly.',
                      textAlign: TextAlign.center,

                      style: TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: greyText,
                      ),
                    ),

                    const SizedBox(height: 18),

                    SizedBox(
                      width: double.infinity,
                      height: 46,

                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'QR Scanner will be connected later.',
                              ),
                            ),
                          );
                        },

                        icon: const Icon(
                          Icons.qr_code_scanner_rounded,
                          size: 20,
                        ),

                        label: const Text(
                          'Scan QR Code',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryPurple,
                          foregroundColor: Colors.white,
                          elevation: 0,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ------------------------------------------------
              // OR DIVIDER
              // ------------------------------------------------
              Row(
                children: [
                  Expanded(
                    child: Container(height: 1, color: const Color(0xFFE1DDED)),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14),

                    child: Text(
                      'OR',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: greyText,
                      ),
                    ),
                  ),

                  Expanded(
                    child: Container(height: 1, color: const Color(0xFFE1DDED)),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // ------------------------------------------------
              // SERVICE TITLE
              // ------------------------------------------------
              const Text(
                'Choose a Service',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Select where you want to join a queue.',
                style: TextStyle(fontSize: 12, color: greyText),
              ),

              const SizedBox(height: 15),

              // ------------------------------------------------
              // HOSPITAL
              // ------------------------------------------------
              _ServiceCard(
                icon: Icons.local_hospital_outlined,
                title: 'Hospital',
                subtitle: 'Doctor consultation & appointments',
                iconColor: primaryPurple,
                iconBackground: lightPurple,

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ServiceSelectionScreen(queueType: 'Hospital'),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              // ------------------------------------------------
              // BANK
              // ------------------------------------------------
              _ServiceCard(
                icon: Icons.account_balance_outlined,
                title: 'Bank',
                subtitle: 'Cash counter & banking services',
                iconColor: mintGreen,
                iconBackground: lightMint,

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ServiceSelectionScreen(queueType: 'Bank'),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              // ------------------------------------------------
              // SERVICE CENTRE
              // ------------------------------------------------
              _ServiceCard(
                icon: Icons.miscellaneous_services_outlined,
                title: 'Service Centre',
                subtitle: 'Customer & support services',
                iconColor: primaryPurple,
                iconBackground: lightPurple,

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ServiceSelectionScreen(
                        queueType: 'Service Centre',
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              // ------------------------------------------------
              // OTHER
              // ------------------------------------------------
              _ServiceCard(
                icon: Icons.apps_rounded,
                title: 'Other Services',
                subtitle: 'More queue-based services',
                iconColor: mintGreen,
                iconBackground: lightMint,

                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('More services will be added soon.'),
                    ),
                  );
                },
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
                        Icons.info_outline_rounded,
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
                            'How it works',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: darkText,
                            ),
                          ),

                          SizedBox(height: 5),

                          Text(
                            'Choose a service, select the queue and get your digital token without standing in line.',
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
// SERVICE CARD
// ============================================================

class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final Color iconBackground;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.iconBackground,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(18),

      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),

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

        child: Row(
          children: [
            // Icon
            Container(
              width: 52,
              height: 52,

              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(16),
              ),

              child: Icon(icon, color: iconColor, size: 27),
            ),

            const SizedBox(width: 14),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: darkText,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: greyText),
                  ),
                ],
              ),
            ),

            // Arrow
            Container(
              width: 32,
              height: 32,

              decoration: BoxDecoration(
                color: const Color(0xFFF7F5FC),
                borderRadius: BorderRadius.circular(10),
              ),

              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: greyText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
