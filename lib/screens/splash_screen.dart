import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startApp();
  }

  Future<void> startApp() async {
    final prefs = await SharedPreferences.getInstance();

    final bool onboardingDone = prefs.getBool('onboardingDone') ?? false;

    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;

      if (onboardingDone) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ------------------------------------------------
                // VQ LOGO
                // ------------------------------------------------
                Container(
                  width: 135,
                  height: 135,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Text(
                        'VQ',
                        style: TextStyle(
                          fontSize: 58,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7654D6),
                          letterSpacing: -5,
                        ),
                      ),

                      // Small queue icon
                      Positioned(
                        right: 24,
                        top: 29,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Color(0xFF4CC9B0),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.people_alt_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),

                      // Green underline
                      Positioned(
                        bottom: 22,
                        child: Container(
                          width: 48,
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CC9B0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ------------------------------------------------
                // APP NAME
                // ------------------------------------------------
                const Text(
                  'VIRTUAL QUEUE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.4,
                    color: Color(0xFF28324A),
                  ),
                ),

                const SizedBox(height: 5),

                // ------------------------------------------------
                // TAGLINE
                // ------------------------------------------------
                const Text(
                  'Queue Smarter. Move Faster.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Color(0xFF858A9A)),
                ),

                const SizedBox(height: 42),

                // ------------------------------------------------
                // LOADING LINE
                // ------------------------------------------------
                SizedBox(
                  width: 145,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: const LinearProgressIndicator(
                      minHeight: 4,
                      backgroundColor: Color(0xFFE8E3F5),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF7654D6),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Smart Queue Management',
                  style: TextStyle(fontSize: 10, color: Color(0xFF858A9A)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
