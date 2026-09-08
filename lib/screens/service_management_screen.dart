import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';

class ServiceManagementScreen extends StatelessWidget {
  const ServiceManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightPurple,

      appBar: AppBar(
        backgroundColor: lightPurple,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: darkText),
        ),
        title: const Text(
          'Service Management',
          style: TextStyle(color: darkText, fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Manage Services',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: darkText,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Add, edit or manage services available in your queues.',
              style: TextStyle(fontSize: 13, color: greyText),
            ),

            const SizedBox(height: 22),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showAddServiceDialog(context);
                },
                icon: const Icon(Icons.add),
                label: const Text('Add New Service'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPurple,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Available Services',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: darkText,
              ),
            ),

            const SizedBox(height: 14),

            _serviceCard(
              context,
              icon: Icons.medical_services_outlined,
              title: 'Doctor Consultation',
              subtitle: 'City Care Hospital',
              people: '12 people waiting',
            ),

            _serviceCard(
              context,
              icon: Icons.science_outlined,
              title: 'Lab Test',
              subtitle: 'City Care Hospital',
              people: '6 people waiting',
            ),

            _serviceCard(
              context,
              icon: Icons.account_balance_outlined,
              title: 'Account Services',
              subtitle: 'ABC Bank',
              people: '8 people waiting',
            ),

            _serviceCard(
              context,
              icon: Icons.receipt_long_outlined,
              title: 'Bill Payment',
              subtitle: 'ABC Bank',
              people: '5 people waiting',
            ),

            _serviceCard(
              context,
              icon: Icons.build_outlined,
              title: 'General Service',
              subtitle: 'Service Centre',
              people: '4 people waiting',
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _serviceCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String people,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: lightPurple,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: primaryPurple, size: 27),
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

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: greyText),
                ),

                const SizedBox(height: 5),

                Text(
                  people,
                  style: const TextStyle(
                    fontSize: 12,
                    color: mintGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: greyText),
            onSelected: (value) {
              if (value == 'edit') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edit Service selected')),
                );
              }

              if (value == 'delete') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Delete Service selected')),
                );
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit Service')),
              PopupMenuItem(value: 'delete', child: Text('Delete Service')),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddServiceDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Service'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter service name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Service added successfully')),
                );
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
