import 'package:flutter/material.dart';

class ScanHistoryScreen extends StatelessWidget {
  const ScanHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan History'),
        backgroundColor: const Color(0xFFcdff7a),
        foregroundColor: Colors.black,
      ),
      body: const Center(
        child: Text(
          'No scan history yet.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
