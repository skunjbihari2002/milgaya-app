import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Terms of Service', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Last Updated: August 2026', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            const Text('1. Acceptance of Terms', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('By accessing and using the Milgaya app, you accept and agree to be bound by the terms and provision of this agreement.'),
            const SizedBox(height: 16),
            const Text('2. Use of Service', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Milgaya provides a platform to connect people who have lost items with those who have found them. You agree to use this service in good faith and not for any illegal or unauthorized purpose.'),
            const SizedBox(height: 16),
            const Text('3. User Accounts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('You are responsible for safeguarding the password that you use to access the service and for any activities or actions under your password. You must provide accurate information when creating your account.'),
            const SizedBox(height: 16),
            const Text('4. Lost and Found Items', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('We do not guarantee the recovery of any lost item. The app acts merely as a facilitator. Users must exercise caution when meeting others to exchange items.'),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12)
                ),
                child: const Text('I Understand'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
