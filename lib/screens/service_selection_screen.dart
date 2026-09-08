import 'package:flutter/material.dart';

import '../widgets/common_widgets.dart';
import 'token_confirmation_screen.dart';

class ServiceSelectionScreen extends StatefulWidget {
  final String queueType;

  const ServiceSelectionScreen({super.key, required this.queueType});

  @override
  State<ServiceSelectionScreen> createState() => _ServiceSelectionScreenState();
}

class _ServiceSelectionScreenState extends State<ServiceSelectionScreen> {
  int selectedService = 0;

  List<Map<String, dynamic>> get services {
    if (widget.queueType == 'Hospital') {
      return [
        {
          'icon': Icons.medical_services_outlined,
          'title': 'Doctor Consultation',
          'subtitle': 'Consult with a doctor',
        },
        {
          'icon': Icons.receipt_long_outlined,
          'title': 'Registration',
          'subtitle': 'New patient registration',
        },
        {
          'icon': Icons.science_outlined,
          'title': 'Lab / Reports',
          'subtitle': 'Tests and reports',
        },
        {
          'icon': Icons.local_pharmacy_outlined,
          'title': 'Pharmacy',
          'subtitle': 'Medicine counter',
        },
      ];
    }

    if (widget.queueType == 'Bank') {
      return [
        {
          'icon': Icons.payments_outlined,
          'title': 'Cash Counter',
          'subtitle': 'Deposit or withdraw cash',
        },
        {
          'icon': Icons.account_balance_wallet_outlined,
          'title': 'Account Services',
          'subtitle': 'Account related services',
        },
        {
          'icon': Icons.credit_card_outlined,
          'title': 'Card Services',
          'subtitle': 'Debit / credit card services',
        },
        {
          'icon': Icons.description_outlined,
          'title': 'Other Services',
          'subtitle': 'Other banking requirements',
        },
      ];
    }

    return [
      {
        'icon': Icons.build_outlined,
        'title': 'Customer Service',
        'subtitle': 'General customer support',
      },
      {
        'icon': Icons.receipt_long_outlined,
        'title': 'Document Service',
        'subtitle': 'Submit or collect documents',
      },
      {
        'icon': Icons.support_agent_outlined,
        'title': 'Help Desk',
        'subtitle': 'Get assistance',
      },
      {
        'icon': Icons.miscellaneous_services_outlined,
        'title': 'Other Service',
        'subtitle': 'Other available services',
      },
    ];
  }

  void continueToToken() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TokenConfirmationScreen(
          queueType: widget.queueType,
          serviceName: services[selectedService]['title'],
        ),
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

        title: Text(
          widget.queueType,
          style: const TextStyle(
            color: darkText,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,
      ),

      body: SafeArea(
        child: Column(
          children: [
            // ------------------------------------------------
            // HEADER
            // ------------------------------------------------
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select a Service',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: darkText,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Choose the service you need at ${widget.queueType}.',
                    style: const TextStyle(fontSize: 12, color: greyText),
                  ),
                ],
              ),
            ),

            // ------------------------------------------------
            // SERVICE LIST
            // ------------------------------------------------
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                itemCount: services.length,

                itemBuilder: (context, index) {
                  final service = services[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),

                    child: _ServiceOption(
                      icon: service['icon'],
                      title: service['title'],
                      subtitle: service['subtitle'],
                      selected: selectedService == index,

                      onTap: () {
                        setState(() {
                          selectedService = index;
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            // ------------------------------------------------
            // BOTTOM ACTION
            // ------------------------------------------------
            Container(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),

              decoration: BoxDecoration(
                color: Colors.white,

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 15,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),

              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,

                        decoration: BoxDecoration(
                          color: lightMint,
                          borderRadius: BorderRadius.circular(12),
                        ),

                        child: const Icon(
                          Icons.info_outline_rounded,
                          color: mintGreen,
                          size: 21,
                        ),
                      ),

                      const SizedBox(width: 11),

                      const Expanded(
                        child: Text(
                          'You will receive a digital token after joining.',
                          style: TextStyle(
                            fontSize: 11,
                            color: greyText,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  AppButton(text: 'Continue', onPressed: continueToToken),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// SERVICE OPTION
// ============================================================

class _ServiceOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _ServiceOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(19),

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),

        padding: const EdgeInsets.all(15),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(19),

          border: Border.all(
            color: selected ? primaryPurple : Colors.transparent,
            width: selected ? 1.5 : 0,
          ),

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
              width: 54,
              height: 54,

              decoration: BoxDecoration(
                color: selected ? lightPurple : const Color(0xFFF7F6FA),
                borderRadius: BorderRadius.circular(16),
              ),

              child: Icon(
                icon,
                size: 27,
                color: selected ? primaryPurple : greyText,
              ),
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

                  const SizedBox(height: 5),

                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: greyText),
                  ),
                ],
              ),
            ),

            // Selection
            Container(
              width: 23,
              height: 23,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                border: Border.all(
                  color: selected ? primaryPurple : const Color(0xFFD3D0DA),
                  width: 1.5,
                ),

                color: selected ? primaryPurple : Colors.white,
              ),

              child: selected
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 15,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
