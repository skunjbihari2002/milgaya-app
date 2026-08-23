import 'package:flutter/material.dart';

class LostScreen extends StatefulWidget {
  const LostScreen({super.key});

  @override
  State<LostScreen> createState() => _LostScreenState();
}

class _LostScreenState extends State<LostScreen> {
  bool isTransit = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report Lost Item')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('What did you lose?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'Wallet', child: Text('Wallet / Purse')),
                DropdownMenuItem(value: 'Bag', child: Text('Bag / Backpack')),
                DropdownMenuItem(value: 'Electronics', child: Text('Phone / Laptop')),
                DropdownMenuItem(value: 'Documents', child: Text('ID / Documents')),
              ],
              onChanged: (val) {},
              hint: const Text('Select Category'),
            ),
            const SizedBox(height: 20),
            const Text('Item Description & Color', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'e.g., Black leather wallet with 2 cards...',
              ),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('Lost in Transit? (Train/Bus)'),
              value: isTransit,
              onChanged: (val) => setState(() => isTransit = val),
            ),
            if (isTransit) ...[
              const SizedBox(height: 10),
              const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'PNR / Bus Number',
                  prefixIcon: Icon(Icons.directions_transit),
                ),
              ),
            ],
            const SizedBox(height: 20),
            const Text('Last Known Location', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Search State, District, City...',
                prefixIcon: Icon(Icons.location_city),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: () {
                  // TODO: Submit and generate poster
                },
                child: const Text('Submit & Generate Poster', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
