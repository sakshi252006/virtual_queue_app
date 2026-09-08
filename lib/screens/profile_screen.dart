import 'package:flutter/material.dart';

import '../widgets/common_widgets.dart';
import 'settings_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
          'Profile',
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
              // PROFILE HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(23),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    Container(
                      width: 78,
                      height: 78,

                      decoration: const BoxDecoration(
                        color: lightPurple,
                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.person_outline_rounded,
                        color: primaryPurple,
                        size: 42,
                      ),
                    ),

                    const SizedBox(height: 13),

                    const Text(
                      'Sakshi Pawar',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: darkText,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      'sakshi@example.com',
                      style: TextStyle(fontSize: 11, color: greyText),
                    ),

                    const SizedBox(height: 15),

                    SizedBox(
                      height: 40,

                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Edit Profile feature will be added later.',
                              ),
                            ),
                          );
                        },

                        icon: const Icon(Icons.edit_outlined, size: 17),

                        label: const Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        style: OutlinedButton.styleFrom(
                          foregroundColor: primaryPurple,

                          side: const BorderSide(color: primaryPurple),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // PERSONAL INFORMATION
              const Align(
                alignment: Alignment.centerLeft,

                child: Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: darkText,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              AppCard(
                child: Column(
                  children: [
                    _InfoRow(
                      icon: Icons.person_outline_rounded,
                      title: 'Full Name',
                      value: 'Sakshi Pawar',
                    ),

                    const Divider(height: 24, color: Color(0xFFEDEAF3)),

                    _InfoRow(
                      icon: Icons.email_outlined,
                      title: 'Email',
                      value: 'sakshi@example.com',
                    ),

                    const Divider(height: 24, color: Color(0xFFEDEAF3)),

                    _InfoRow(
                      icon: Icons.phone_outlined,
                      title: 'Mobile',
                      value: '+91 98765 43210',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ACCOUNT
              const Align(
                alignment: Alignment.centerLeft,

                child: Text(
                  'Account',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: darkText,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              AppCard(
                child: Column(
                  children: [
                    _MenuRow(
                      icon: Icons.settings_outlined,
                      title: 'Settings',
                      subtitle: 'Manage app preferences',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                    ),

                    const Divider(height: 24, color: Color(0xFFEDEAF3)),

                    _MenuRow(
                      icon: Icons.help_outline_rounded,
                      title: 'Help & Support',
                      subtitle: 'Get help with Virtual Queue',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Help & Support will be available later.',
                            ),
                          ),
                        );
                      },
                    ),

                    const Divider(height: 24, color: Color(0xFFEDEAF3)),

                    _MenuRow(
                      icon: Icons.info_outline_rounded,
                      title: 'About',
                      subtitle: 'About Virtual Queue',
                      onTap: () {
                        showAboutDialog(
                          context: context,
                          applicationName: 'Virtual Queue',
                          applicationVersion: '1.0.0',
                          applicationLegalese: 'Smart Queue Management System',
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // LOGOUT
              SizedBox(
                width: double.infinity,
                height: 48,

                child: OutlinedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text(
                            'Logout?',
                            style: TextStyle(
                              color: darkText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          content: const Text(
                            'Are you sure you want to logout?',
                            style: TextStyle(color: greyText),
                          ),

                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },

                              child: const Text('Cancel'),
                            ),

                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                  (route) => false,
                                );
                              },

                              child: const Text(
                                'Logout',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },

                  icon: const Icon(
                    Icons.logout_rounded,
                    size: 19,
                    color: Colors.redAccent,
                  ),

                  label: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE3B9B9)),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                'Virtual Queue • Version 1.0.0',
                style: TextStyle(fontSize: 9, color: greyText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// INFO ROW
// ============================================================

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,

          decoration: BoxDecoration(
            color: lightPurple,
            borderRadius: BorderRadius.circular(12),
          ),

          child: Icon(icon, color: primaryPurple, size: 20),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 10, color: greyText),
              ),

              const SizedBox(height: 3),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: darkText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================
// MENU ROW
// ============================================================

class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),

      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,

            decoration: BoxDecoration(
              color: lightPurple,
              borderRadius: BorderRadius.circular(13),
            ),

            child: Icon(icon, color: primaryPurple, size: 21),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: darkText,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 10, color: greyText),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: greyText,
          ),
        ],
      ),
    );
  }
}
