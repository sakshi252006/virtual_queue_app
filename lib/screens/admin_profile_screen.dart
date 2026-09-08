import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

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
          'Admin Profile',
          style: TextStyle(color: darkText, fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            AppCard(
              child: Column(
                children: [
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      color: primaryPurple,
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: const Icon(
                      Icons.admin_panel_settings_outlined,
                      color: Colors.white,
                      size: 44,
                    ),
                  ),

                  const SizedBox(height: 14),

                  const Text(
                    'Admin',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: darkText,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    'admin@virtualqueue.com',
                    style: TextStyle(fontSize: 13, color: greyText),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: lightMint,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Administrator',
                      style: TextStyle(
                        color: mintGreen,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            _sectionTitle('Account'),

            _menuCard(
              icon: Icons.person_outline,
              title: 'Personal Information',
              subtitle: 'Manage admin details',
              onTap: () {},
            ),

            _menuCard(
              icon: Icons.lock_outline,
              title: 'Change Password',
              subtitle: 'Update your password',
              onTap: () {},
            ),

            const SizedBox(height: 18),

            _sectionTitle('App Settings'),

            _menuCard(
              icon: Icons.notifications_none,
              title: 'Notifications',
              subtitle: 'Manage admin notifications',
              onTap: () {},
            ),

            _menuCard(
              icon: Icons.settings_outlined,
              title: 'Settings',
              subtitle: 'Manage app preferences',
              onTap: () {},
            ),

            _menuCard(
              icon: Icons.help_outline,
              title: 'Help & Support',
              subtitle: 'Get help with Virtual Queue',
              onTap: () {},
            ),

            const SizedBox(height: 18),

            _sectionTitle('About'),

            _menuCard(
              icon: Icons.info_outline,
              title: 'About Virtual Queue',
              subtitle: 'Version 1.0.0',
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Virtual Queue',
                  applicationVersion: '1.0.0',
                  applicationLegalese: 'Virtual Queue Management System',
                );
              },
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout?'),
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
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryPurple,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Logout'),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
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

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: darkText,
          ),
        ),
      ),
    );
  }

  Widget _menuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        leading: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: lightPurple,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: primaryPurple),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, color: darkText),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: greyText),
        ),
        trailing: const Icon(Icons.chevron_right, color: greyText),
      ),
    );
  }
}
