import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  bool isJoiningQueue = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get _category {
    if (widget.queueType == 'Hospital') return 'Hospital';
    if (widget.queueType == 'Bank') return 'Bank';
    return 'General';
  }

  IconData _serviceIcon(String name) {
    final value = name.toLowerCase();

    if (value.contains('doctor') || value.contains('medical')) {
      return Icons.medical_services_outlined;
    }
    if (value.contains('registration') || value.contains('document')) {
      return Icons.receipt_long_outlined;
    }
    if (value.contains('lab') || value.contains('report')) {
      return Icons.science_outlined;
    }
    if (value.contains('pharmacy') || value.contains('medicine')) {
      return Icons.local_pharmacy_outlined;
    }
    if (value.contains('cash') || value.contains('payment')) {
      return Icons.payments_outlined;
    }
    if (value.contains('account')) {
      return Icons.account_balance_wallet_outlined;
    }
    if (value.contains('card')) {
      return Icons.credit_card_outlined;
    }
    if (value.contains('help') || value.contains('support')) {
      return Icons.support_agent_outlined;
    }

    return Icons.miscellaneous_services_outlined;
  }

  Future<void> continueToToken(Map<String, dynamic> service) async {
    if (isJoiningQueue) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in before joining a queue.')),
      );
      return;
    }

    setState(() => isJoiningQueue = true);

    try {
      final serviceName = service['name'].toString().trim();

      // Token generation and Firestore writes happen securely on the server.
      final callable = FirebaseFunctions.instance.httpsCallable('joinQueue');

      final response = await callable.call(<String, dynamic>{
        'queueType': widget.queueType,
        'serviceName': serviceName,
      });

      final result = Map<String, dynamic>.from(response.data as Map);
      final tokenNumber = result['tokenNumber'] as String;
      final queueEntryId = result['queueEntryId'] as String;

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TokenConfirmationScreen(
            queueType: widget.queueType,
            serviceName: serviceName,
            tokenNumber: tokenNumber,
            queueEntryId: queueEntryId,
          ),
        ),
      );
    } on FirebaseFunctionsException catch (e) {
      if (!mounted) return;

      String message = 'Could not join the queue. Please try again.';

      if (e.code == 'unauthenticated') {
        message = 'Please log in before joining a queue.';
      } else if (e.code == 'failed-precondition') {
        message = 'This service is unavailable. Please select another.';
      } else if (e.code == 'unavailable') {
        message = 'Network unavailable. Please try again.';
      } else if (e.code == 'permission-denied') {
        message = 'You do not have permission to join this queue.';
      } else if (e.code == 'not-found') {
        message = 'Queue service is not deployed yet. Please try later.';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } on FirebaseException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Firebase error: ${e.message ?? e.code}')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something went wrong: $e')));
    } finally {
      if (mounted) {
        setState(() => isJoiningQueue = false);
      }
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
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _firestore
                    .collection('services')
                    .where('active', isEqualTo: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'Could not load services. Please check your '
                          'internet connection and Firestore rules.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: greyText),
                        ),
                      ),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: primaryPurple),
                    );
                  }

                  final services = (snapshot.data?.docs ?? []).where((doc) {
                    final data = doc.data();
                    return data['category'] == _category &&
                        data['active'] == true &&
                        (data['name']?.toString().trim().isNotEmpty ?? false);
                  }).toList();

                  if (services.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.miscellaneous_services_outlined,
                              size: 52,
                              color: greyText,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'No active services available.',
                              style: TextStyle(
                                color: darkText,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'The admin needs to add an active '
                              '$_category service first.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: greyText,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final safeIndex = selectedService < services.length
                      ? selectedService
                      : 0;

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      final data = services[index].data();
                      final name = data['name'].toString();
                      final description = data['description']?.toString() ?? '';

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _ServiceOption(
                          icon: _serviceIcon(name),
                          title: name,
                          subtitle: description,
                          selected: safeIndex == index,
                          onTap: () {
                            if (isJoiningQueue) return;
                            setState(() => selectedService = index);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
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
                  const Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: mintGreen,
                        size: 28,
                      ),
                      SizedBox(width: 11),
                      Expanded(
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
                  SizedBox(
                    width: double.infinity,
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: _firestore
                          .collection('services')
                          .where('active', isEqualTo: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        final services = (snapshot.data?.docs ?? []).where((
                          doc,
                        ) {
                          final data = doc.data();
                          return data['category'] == _category &&
                              data['active'] == true &&
                              (data['name']?.toString().trim().isNotEmpty ??
                                  false);
                        }).toList();

                        final hasServices = services.isNotEmpty;
                        final safeIndex = selectedService < services.length
                            ? selectedService
                            : 0;

                        return AppButton(
                          text: isJoiningQueue
                              ? 'Joining Queue...'
                              : 'Continue',
                          onPressed: () {
                            if (isJoiningQueue ||
                                snapshot.connectionState ==
                                    ConnectionState.waiting ||
                                !hasServices) {
                              return;
                            }

                            continueToToken(services[safeIndex].data());
                          },
                        );
                      },
                    ),
                  ),
                  if (isJoiningQueue) ...[
                    const SizedBox(height: 10),
                    const LinearProgressIndicator(color: primaryPurple),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
