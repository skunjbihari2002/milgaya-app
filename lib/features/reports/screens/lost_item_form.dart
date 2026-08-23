import 'package:flutter/material.dart';

class LostItemFormScreen extends StatefulWidget {
  const LostItemFormScreen({super.key});

  @override
  State<LostItemFormScreen> createState() => _LostItemFormScreenState();
}

class _LostItemFormScreenState extends State<LostItemFormScreen> {
  bool _isTransit = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Lost Item'),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'What did you lose?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Category Grid Placeholder
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: [
                _buildCategoryCard(Icons.wallet, 'Wallet'),
                _buildCategoryCard(Icons.phone_android, 'Phone'),
                _buildCategoryCard(Icons.document_scanner, 'Document'),
                _buildCategoryCard(Icons.cases_rounded, 'Bag'),
                _buildCategoryCard(Icons.keys, 'Keys'),
                _buildCategoryCard(Icons.more_horiz, 'Other'),
              ],
            ),
            const SizedBox(height: 24),
            SwitchListTile(
              title: const Text('Lost in Transit?'),
              subtitle: const Text('Train, Bus, Flight, etc.'),
              value: _isTransit,
              onChanged: (val) {
                setState(() {
                  _isTransit = val;
                });
              },
            ),
            if (_isTransit) ...[
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Train PNR or Bus Number',
                  border: OutlineInputBorder(),
                ),
              ),
            ] else ...[
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Location (State -> District -> City)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            const SizedBox(height: 24),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Color / Identification Marks',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Generate Missing Poster & Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(IconData icon, String label) {
    return Card(
      child: InkWell(
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.blueGrey),
            const SizedBox(height: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}
