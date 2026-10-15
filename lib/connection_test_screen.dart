import 'package:flutter/material.dart';
import 'api_service.dart';

class ConnectionTestScreen extends StatefulWidget {
  const ConnectionTestScreen({super.key});

  @override
  State<ConnectionTestScreen> createState() => _ConnectionTestScreenState();
}

class _ConnectionTestScreenState extends State<ConnectionTestScreen> {
  String message = 'Tap the button to test the connection.';
  bool loading = false;

  Future<void> checkConnection() async {
    setState(() {
      loading = true;
      message = 'Connecting to backend...';
    });

    final result = await ApiService.testConnection();

    if (!mounted) return;

    setState(() {
      message = result;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Backend Connection Test')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: loading ? null : checkConnection,
                child: Text(loading ? 'Connecting...' : 'Test Connection'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
