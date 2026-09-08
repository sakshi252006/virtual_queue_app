import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'widgets/common_widgets.dart';

void main() {
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
