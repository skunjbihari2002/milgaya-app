import 'package:flutter/material.dart';

class SafeHubMapScreen extends StatelessWidget {
  const SafeHubMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verified Safe Hubs')),
      body: Stack(
        children: [
          // Simulated Map Background
          Container(
            color: Colors.blueGrey.shade100,
            child: const Center(
              child: Text(
                'Google Map View\n(API integration pending)',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
            ),
          ),
          // Mock Safe Hub Marker
          Positioned(
            top: 200,
            left: 150,
            child: Column(
              children: [
                const Icon(Icons.security, color: Colors.green, size: 40),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)
                    ],
                  ),
                  child: const Column(
                    children: [
                      Text('Ravi Provision Shop', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Verified by Admin', style: TextStyle(fontSize: 12, color: Colors.green)),
                      SizedBox(height: 4),
                      Text('Tap to select as Drop point', style: TextStyle(fontSize: 10)),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
