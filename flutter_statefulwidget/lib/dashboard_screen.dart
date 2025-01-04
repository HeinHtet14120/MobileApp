import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final String userEmail;

  const DashboardScreen({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        automaticallyImplyLeading: false, // Removes back button
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome $userEmail!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate back to login screen
                Navigator.of(context).pop();
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
