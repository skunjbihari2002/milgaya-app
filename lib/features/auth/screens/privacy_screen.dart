import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Privacy Policy', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Last Updated: August 2026', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            const Text('1. Information Collection', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('We collect information you provide directly to us when you create an account, such as your name, phone number, and location data to help match lost and found items in your vicinity.'),
            const SizedBox(height: 16),
            const Text('2. How We Use Your Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('We use the information we collect to provide, maintain, and improve our services, as well as to communicate with you about matches for your lost or found items.'),
            const SizedBox(height: 16),
            const Text('3. Information Sharing', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('We may share your contact information with other users ONLY when a match is confirmed between a lost and found item, to facilitate the return of the item.'),
            const SizedBox(height: 16),
            const Text('4. Data Security', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('We take reasonable measures to help protect information about you from loss, theft, misuse and unauthorized access, disclosure, alteration and destruction. Your data is securely stored in Firebase.'),
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
