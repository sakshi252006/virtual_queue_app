import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';
import '../widgets/common_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController pageController = PageController();

  int currentPage = 0;

  final List<Map<String, dynamic>> pages = [
    {
      'title': 'One App. Every Queue.',
      'subtitle': 'Manage your waiting time smarter with Virtual Queue.',
      'icon': Icons.people_alt_outlined,
    },
    {
      'title': 'Join Queue Digitally',
      'subtitle':
          'Scan a QR code and join the queue without standing in a physical line.',
      'icon': Icons.qr_code_scanner,
    },
    {
      'title': 'Know Your Turn',
      'subtitle':
          'Track your live position and get notified when your turn is near.',
      'icon': Icons.notifications_none_rounded,
    },
  ];

  Future<void> finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('onboardingDone', true);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void nextPage() {
    if (currentPage == pages.length - 1) {
      finishOnboarding();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightPurple,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: finishOnboarding,
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: greyText,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildPage(
                    title: pages[index]['title'],
                    subtitle: pages[index]['subtitle'],
                    icon: pages[index]['icon'],
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(25, 10, 25, 25),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(pages.length, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 7,
                        width: currentPage == index ? 24 : 7,
                        decoration: BoxDecoration(
                          color: currentPage == index
                              ? primaryPurple
                              : const Color(0xFFD8D2EA),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 25),

                  AppButton(
                    text: currentPage == pages.length - 1
                        ? 'Get Started'
                        : 'Next',
                    onPressed: nextPage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          const SizedBox(height: 10),

          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 35,
                    left: 30,
                    child: _circle(18, const Color(0xFFE8F8F4)),
                  ),

                  Positioned(
                    bottom: 45,
                    right: 28,
                    child: _circle(25, const Color(0xFFF0ECFF)),
                  ),

                  Container(
                    width: 145,
                    height: 145,
                    decoration: BoxDecoration(
                      color: lightPurple,
                      borderRadius: BorderRadius.circular(38),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 82,
                          height: 82,
                          decoration: const BoxDecoration(
                            color: primaryPurple,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(icon, color: Colors.white, size: 42),
                        ),

                        Positioned(
                          top: 20,
                          right: 18,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: mintGreen,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 19,
                            ),
                          ),
                        ),

                        Positioned(
                          bottom: 18,
                          left: 18,
                          child: Container(
                            width: 38,
                            height: 10,
                            decoration: BoxDecoration(
                              color: mintGreen,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 28),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: darkText,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, height: 1.5, color: greyText),
          ),

          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _circle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
