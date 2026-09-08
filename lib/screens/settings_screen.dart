import 'package:flutter/material.dart';

import '../widgets/common_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notifications = true;
  bool queueReminder = true;
  bool sound = true;

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
          'Settings',
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
              const Text(
                'Preferences',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Customize your Virtual Queue experience.',
                style: TextStyle(fontSize: 12, color: greyText),
              ),

              const SizedBox(height: 20),

              AppCard(
                child: Column(
                  children: [
                    _SwitchRow(
                      icon: Icons.notifications_none_rounded,
                      title: 'Notifications',
                      subtitle: 'Receive queue updates',
                      value: notifications,
                      onChanged: (value) {
                        setState(() {
                          notifications = value;
                        });
                      },
                    ),

                    const Divider(height: 24, color: Color(0xFFEDEAF3)),

                    _SwitchRow(
                      icon: Icons.access_time_rounded,
                      title: 'Queue Reminder',
                      subtitle: 'Remind me when my turn is near',
                      value: queueReminder,
                      onChanged: (value) {
                        setState(() {
                          queueReminder = value;
                        });
                      },
                    ),

                    const Divider(height: 24, color: Color(0xFFEDEAF3)),

                    _SwitchRow(
                      icon: Icons.volume_up_outlined,
                      title: 'Sound',
                      subtitle: 'Play sound for important updates',
                      value: sound,
                      onChanged: (value) {
                        setState(() {
                          sound = value;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              const Text(
                'App Settings',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),

              const SizedBox(height: 12),

              AppCard(
                child: Column(
                  children: [
                    _MenuRow(
                      icon: Icons.language_rounded,
                      title: 'Language',
                      subtitle: 'English',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Language selection will be added later.',
                            ),
                          ),
                        );
                      },
                    ),

                    const Divider(height: 24, color: Color(0xFFEDEAF3)),

                    _MenuRow(
                      icon: Icons.lock_outline_rounded,
                      title: 'Privacy',
                      subtitle: 'Manage privacy settings',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Privacy settings will be added later.',
                            ),
                          ),
                        );
                      },
                    ),

                    const Divider(height: 24, color: Color(0xFFEDEAF3)),

                    _MenuRow(
                      icon: Icons.security_outlined,
                      title: 'Security',
                      subtitle: 'Account security',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Security settings will be added later.',
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              const Text(
                'About App',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),

              const SizedBox(height: 12),

              AppCard(
                child: Column(
                  children: [
                    _MenuRow(
                      icon: Icons.info_outline_rounded,
                      title: 'About Virtual Queue',
                      subtitle: 'Version 1.0.0',
                      onTap: () {
                        showAboutDialog(
                          context: context,
                          applicationName: 'Virtual Queue',
                          applicationVersion: '1.0.0',
                          applicationLegalese: 'Smart Queue Management System',
                        );
                      },
                    ),

                    const Divider(height: 24, color: Color(0xFFEDEAF3)),

                    _MenuRow(
                      icon: Icons.help_outline_rounded,
                      title: 'Help & Support',
                      subtitle: 'Get help and support',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Help & Support will be added later.',
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              Center(
                child: Column(
                  children: [
                    const Text(
                      'Virtual Queue',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: primaryPurple,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      'Queue Smarter. Move Faster.',
                      style: TextStyle(fontSize: 10, color: greyText),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      'Version 1.0.0',
                      style: TextStyle(fontSize: 9, color: greyText),
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
// SWITCH ROW
// ============================================================

class _SwitchRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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

        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: primaryPurple,
          activeTrackColor: const Color(0xFFDCD3FA),
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
