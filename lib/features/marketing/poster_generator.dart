import 'package:flutter/material.dart';

class PosterGenerator extends StatelessWidget {
  final String type; // 'LOST' or 'FOUND'
  final String itemName;
  final String description;
  final String location;
  
  const PosterGenerator({
    super.key,
    required this.type,
    required this.itemName,
    required this.description,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: type == 'LOST' ? Colors.red : Colors.green,
          width: 8,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            type == 'LOST' ? 'MISSING' : 'FOUND',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: type == 'LOST' ? Colors.red : Colors.green,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.grey.shade300,
            child: const Icon(Icons.image, size: 60, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Text(itemName, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text('Location: $location', style: const TextStyle(fontSize: 18, color: Colors.black54)),
          const SizedBox(height: 10),
          Text(description, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 30),
          const Divider(),
          const SizedBox(height: 10),
          const Text(
            'Help a fellow citizen! Please contact via App.',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search, color: Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              const Text(
                'Download MilGaya App',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          )
        ],
      ),
    );
  }
}
