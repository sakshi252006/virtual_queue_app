import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';

class QueueTokenControlScreen extends StatefulWidget {
  const QueueTokenControlScreen({super.key});

  @override
  State<QueueTokenControlScreen> createState() =>
      _QueueTokenControlScreenState();
}

class _QueueTokenControlScreenState extends State<QueueTokenControlScreen> {
  bool queuePaused = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Queue & Token Control',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: lightPurple,
        foregroundColor: darkText,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Queue',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: darkText,
              ),
            ),
            const SizedBox(height: 12),

            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'City Care Hospital',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: darkText,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Doctor Consultation',
                    style: TextStyle(color: greyText),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _infoItem('Current', 'A-23'),
                      _infoItem('Waiting', '12'),
                      _infoItem('Completed', '34'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Current Token',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: darkText,
              ),
            ),
            const SizedBox(height: 12),

            AppCard(
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: lightPurple,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text(
                        'A-23',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryPurple,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Patient 23',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: darkText,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Doctor Consultation',
                          style: TextStyle(color: greyText),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Token Controls',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: darkText,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _controlButton(
                    icon: Icons.play_arrow,
                    title: 'Call Next',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Next token called')),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _controlButton(
                    icon: Icons.skip_next,
                    title: 'Skip',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Token skipped')),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _controlButton(
                    icon: queuePaused ? Icons.play_circle : Icons.pause_circle,
                    title: queuePaused ? 'Resume' : 'Pause',
                    onTap: () {
                      setState(() {
                        queuePaused = !queuePaused;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _controlButton(
                    icon: Icons.refresh,
                    title: 'Refresh',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Queue refreshed')),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              'Upcoming Tokens',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: darkText,
              ),
            ),
            const SizedBox(height: 12),

            _tokenCard('A-24', 'Patient 24'),
            _tokenCard('A-25', 'Patient 25'),
            _tokenCard('A-26', 'Patient 26'),
            _tokenCard('A-27', 'Patient 27'),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _infoItem(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryPurple,
          ),
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 12, color: greyText)),
      ],
    );
  }

  Widget _controlButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: primaryPurple, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: darkText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tokenCard(String token, String patient) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
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
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: lightMint,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              token,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: mintGreen,
              ),
            ),
          ),

          const SizedBox(width: 14),

          Text(
            patient,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: darkText,
            ),
          ),

          const Spacer(),

          const Icon(Icons.arrow_forward_ios, size: 16, color: greyText),
        ],
      ),
    );
  }
}
