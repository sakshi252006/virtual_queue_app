import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';

class ReportsAnalyticsScreen extends StatelessWidget {
  const ReportsAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reports & Analytics',
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
              'Today\'s Overview',
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
                  child: _statCard(
                    '58',
                    'Total Tokens',
                    Icons.confirmation_number_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statCard(
                    '34',
                    'Completed',
                    Icons.check_circle_outline,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _statCard('18 min', 'Avg. Wait', Icons.access_time),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statCard('24', 'Waiting', Icons.people_outline),
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              'Queue Performance',
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
                    'Today\'s Queue Activity',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: darkText,
                    ),
                  ),

                  const SizedBox(height: 20),

                  _progressRow('Completed', 34, 58),

                  const SizedBox(height: 16),

                  _progressRow('Waiting', 24, 58),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Peak Hours',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: darkText,
              ),
            ),

            const SizedBox(height: 12),

            AppCard(
              child: Column(
                children: [
                  _hourRow('10 AM - 11 AM', '18 people'),
                  _hourRow('11 AM - 12 PM', '25 people'),
                  _hourRow('12 PM - 1 PM', '31 people'),
                  _hourRow('2 PM - 3 PM', '22 people'),
                  _hourRow('3 PM - 4 PM', '27 people'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Service-wise Statistics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: darkText,
              ),
            ),

            const SizedBox(height: 12),

            _serviceCard(
              'Doctor Consultation',
              'City Care Hospital',
              '34 tokens',
            ),

            _serviceCard('Lab Test', 'City Care Hospital', '12 tokens'),

            _serviceCard('Account Services', 'ABC Bank', '8 tokens'),

            _serviceCard('Bill Payment', 'ABC Bank', '5 tokens'),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Report export will be available later'),
                    ),
                  );
                },
                icon: const Icon(Icons.download_outlined),
                label: const Text(
                  'Export Report',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryPurple,
                  side: const BorderSide(color: primaryPurple),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String value, String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: primaryPurple, size: 27),

          const SizedBox(height: 12),

          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
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

  Widget _progressRow(String title, int value, int total) {
    double progress = value / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: darkText,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '$value',
              style: const TextStyle(
                color: primaryPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: lightPurple,
            valueColor: const AlwaysStoppedAnimation(primaryPurple),
          ),
        ),
      ],
    );
  }

  Widget _hourRow(String time, String people) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          const Icon(Icons.access_time, size: 20, color: primaryPurple),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              time,
              style: const TextStyle(
                color: darkText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Text(people, style: const TextStyle(color: greyText, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _serviceCard(String service, String location, String tokens) {
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
              color: lightMint,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.miscellaneous_services_outlined,
              color: mintGreen,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: darkText,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  location,
                  style: const TextStyle(fontSize: 12, color: greyText),
                ),
              ],
            ),
          ),

          Text(
            tokens,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryPurple,
            ),
          ),
        ],
      ),
    );
  }
}
