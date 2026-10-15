import 'package:flutter/material.dart';
import 'connection_test_screen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'widgets/common_widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const VirtualQueueApp());
}

class VirtualQueueApp extends StatelessWidget {
  const VirtualQueueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Virtual Queue',

      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: lightPurple,
        colorScheme: ColorScheme.fromSeed(seedColor: primaryPurple),
        useMaterial3: true,
      ),

      home: const SplashScreen(),
    );
  }
}
