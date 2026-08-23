import 'package:flutter/material.dart';

class PostTab extends StatelessWidget {
  const PostTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Create a Post', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('What would you like to share with your community?', style: TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 32),
          
          _buildPostOption(
            context,
            'Help Request',
            'Ask the community for help with a task. Secure your payment in escrow.',
            Icons.security,
            const Color(0xFF1976D2),
          ),
          _buildPostOption(
            context,
            'Lost Item (Voice AI)',
            'Report something you\'ve lost quickly using Voice. Offer a Tip Jar reward to help locate it.',
            Icons.mic,
            Colors.orange.shade700,
          ),
          _buildPostOption(
            context,
            'Found Item (Auto-Tag)',
            'Post a found item. AI will scan your photo. Choose to meet or drop at a verified Safe Hub.',
            Icons.camera_alt,
            Colors.green.shade600,
          ),
          
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.security, color: Colors.deepPurple),
                SizedBox(width: 12),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: 'Escrow Protection: ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                        TextSpan(text: 'All help request payments are held securely by Milgaya and only released when you confirm the task is completed.', style: TextStyle(color: Colors.grey)),
                      ]
                    )
                  )
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPostOption(BuildContext context, String title, String desc, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        // Navigation logic for creation forms
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))),
                const Icon(Icons.arrow_forward, color: Colors.white),
              ],
            ),
            const SizedBox(height: 16),
            Text(desc, style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
