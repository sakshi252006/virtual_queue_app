import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/common_widgets.dart';
import 'admin_dashboard_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool hidePassword = true;
  bool isLoading = false;

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Please enter email and password.');
      return;
    }

    if (isLoading) return;

    setState(() => isLoading = true);

    try {
      // Step 1: Firebase Authentication
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        throw Exception('Firebase did not return a user.');
      }

      // Step 2: Read the user's Firestore role
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!mounted) return;

      if (!userDoc.exists) {
        await FirebaseAuth.instance.signOut();

        if (!mounted) return;

        _showMessage(
          'User profile not found in Firestore. Check the users document.',
        );
        return;
      }

      final role = userDoc.data()?['role']?.toString().toLowerCase();

      if (role != 'admin') {
        await FirebaseAuth.instance.signOut();

        if (!mounted) return;

        _showMessage(
          'Access denied. This account does not have the admin role.',
        );
        return;
      }

      // Step 3: Admin login successful
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
      );
    } on FirebaseAuthException catch (e, stackTrace) {
      debugPrint('ADMIN AUTH ERROR CODE: ${e.code}');
      debugPrint('ADMIN AUTH ERROR MESSAGE: ${e.message}');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      String message;

      switch (e.code) {
        case 'invalid-credential':
        case 'wrong-password':
        case 'user-not-found':
          message = 'Invalid email or password.';
          break;
        case 'invalid-email':
          message = 'Please enter a valid email address.';
          break;
        case 'user-disabled':
          message = 'This account has been disabled.';
          break;
        case 'too-many-requests':
          message = 'Too many attempts. Please try again later.';
          break;
        case 'network-request-failed':
          message = 'Network error. Check your internet connection.';
          break;
        default:
          message =
              'Authentication error (${e.code}): '
              '${e.message ?? 'Please try again.'}';
      }

      _showMessage(message);
    } on FirebaseException catch (e, stackTrace) {
      debugPrint('ADMIN FIRESTORE ERROR CODE: ${e.code}');
      debugPrint('ADMIN FIRESTORE ERROR MESSAGE: ${e.message}');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      _showMessage(
        'Firestore error (${e.code}): '
        '${e.message ?? 'Could not read admin profile.'}',
      );
    } catch (e, stackTrace) {
      debugPrint('ADMIN LOGIN ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      _showMessage('Admin login error: $e');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 5)),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightPurple,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: darkText,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: primaryPurple,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.admin_panel_settings_outlined,
                  color: Colors.white,
                  size: 42,
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Admin Login',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Manage queues and services',
                style: TextStyle(fontSize: 14, color: greyText),
              ),
              const SizedBox(height: 35),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Email Address',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: darkText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Enter admin email',
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: primaryPurple,
                        ),
                        filled: true,
                        fillColor: lightPurple,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: darkText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: passwordController,
                      obscureText: hidePassword,
                      onSubmitted: (_) => login(),
                      decoration: InputDecoration(
                        hintText: 'Enter password',
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: primaryPurple,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                          icon: Icon(
                            hidePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                        filled: true,
                        fillColor: lightPurple,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    AppButton(
                      text: isLoading ? 'Logging in...' : 'Login as Admin',
                      onPressed: isLoading ? () {} : login,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.security_outlined, size: 17, color: mintGreen),
                  SizedBox(width: 6),
                  Text(
                    'Secure Admin Access',
                    style: TextStyle(fontSize: 13, color: greyText),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
