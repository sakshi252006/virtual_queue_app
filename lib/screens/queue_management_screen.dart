import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';

class QueueManagementScreen extends StatelessWidget {
  const QueueManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightPurple,

      appBar: AppBar(
        backgroundColor: lightPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: darkText),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Queue Management',
          style: TextStyle(color: darkText, fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Queue summary
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
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.local_hospital_outlined,
                          color: primaryPurple,
                          size: 28,
                        ),
                      ),

                      const SizedBox(width: 14),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'City Care Hospital',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: darkText,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Doctor Consultation',
                              style: TextStyle(fontSize: 13, color: greyText),
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
                          color: lightMint,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Active',
                          style: TextStyle(
                            color: mintGreen,
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
                    children: const [
                      _QueueInfo(title: 'Current', value: 'A-23'),
                      _QueueInfo(title: 'Waiting', value: '12'),
                      _QueueInfo(title: 'Completed', value: '34'),
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
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _controlButton(
                    icon: Icons.skip_next,
                    title: 'Skip',
                    filled: false,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _controlButton(
                    icon: Icons.pause,
                    title: 'Pause Queue',
                    filled: false,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _controlButton(
                    icon: Icons.refresh,
                    title: 'Refresh',
                    filled: false,
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

            _personCard(token: 'A-24', name: 'Patient 1', status: 'Waiting'),

            _personCard(token: 'A-25', name: 'Patient 2', status: 'Waiting'),

            _personCard(token: 'A-26', name: 'Patient 3', status: 'Waiting'),

            _personCard(token: 'A-27', name: 'Patient 4', status: 'Waiting'),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _controlButton({
    required IconData icon,
    required String title,
    required bool filled,
  }) {
    return SizedBox(
      height: 50,
      child: filled
          ? ElevatedButton.icon(
              onPressed: () {},
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
              onPressed: () {},
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
            status,
            style: const TextStyle(
              color: mintGreen,
              fontSize: 12,
              fontWeight: FontWeight.w600,
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
