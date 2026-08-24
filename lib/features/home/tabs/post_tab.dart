import 'package:flutter/material.dart';
import 'package:milgaya/services/mock_database.dart';

class PostTab extends StatefulWidget {
  final Function(int) onNavigateToTab;
  const PostTab({super.key, required this.onNavigateToTab});

  @override
  State<PostTab> createState() => _PostTabState();
}

class _PostTabState extends State<PostTab> {
  String _postType = 'Lost Item'; // 'Lost Item', 'Found Item', 'Help Request'
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController(); // For help request
  bool _isSubmitting = false;

  void _submitPost() async {
    if (_titleController.text.isEmpty || _descController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all required fields.')));
      return;
    }

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 1)); // Simulate network

    if (_postType == 'Help Request') {
      MockDatabase().addHelpRequest({
        'category': 'OTHER',
        'title': _titleController.text,
        'desc': _descController.text,
        'user': 'Me',
        'time': 'Just now',
        'price': _priceController.text.isNotEmpty ? '\$${_priceController.text}' : 'Negotiable',
        'icon': 'build'
      });
      widget.onNavigateToTab(0); // Go to Help tab
    } else {
      MockDatabase().addLostFoundItem({
        'type': _postType == 'Lost Item' ? 'Lost' : 'Found',
        'title': _titleController.text,
        'desc': _descController.text,
        'user': 'Me',
        'time': 'Just now',
        'tagColor': _postType == 'Lost Item' ? 'red' : 'green',
        'image': null
      });
      widget.onNavigateToTab(1); // Go to Lost & Found tab
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Posted successfully!'), backgroundColor: Colors.green));
      // Clear form
      setState(() {
        _isSubmitting = false;
        _titleController.clear();
        _descController.clear();
        _priceController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Create Post', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
          const SizedBox(height: 8),
          const Text('What would you like to post?', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          
          Row(
            children: [
              _buildTypeCard('Lost Item', Icons.search, Colors.red),
              const SizedBox(width: 12),
              _buildTypeCard('Found Item', Icons.check_circle, Colors.green),
            ],
          ),
          const SizedBox(height: 12),
          _buildTypeCard('Help Request', Icons.handshake, const Color(0xFF1976D2), fullWidth: true),
          
          const SizedBox(height: 32),
          const Text('Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: _postType == 'Help Request' ? 'E.g., Need a plumber' : 'Title (e.g., Black Wallet)',
              filled: true, fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Provide more details...',
              filled: true, fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          
          if (_postType == 'Help Request') ...[
            const SizedBox(height: 16),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Offer Amount (\$) (Optional)',
                filled: true, fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ],
          
          if (_postType != 'Help Request') ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade100, style: BorderStyle.solid),
              ),
              child: Column(
                children: [
                  Icon(Icons.add_a_photo, size: 40, color: Colors.blue.shade300),
                  const SizedBox(height: 8),
                  Text('Add Photo', style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.mic),
                    label: const Text('Voice AI (Describe it)'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF1976D2)),
                  )
                ],
              ),
            ),
          ],
          
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitPost,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1976D2), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: _isSubmitting 
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white))
                : const Text('POST NOW', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildTypeCard(String title, IconData icon, Color color, {bool fullWidth = false}) {
    bool isSelected = _postType == title;
    Widget card = GestureDetector(
      onTap: () => setState(() => _postType = title),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? color : Colors.grey.shade300, width: isSelected ? 2 : 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? color : Colors.grey, size: 32),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? color : Colors.grey.shade700)),
          ],
        ),
      ),
    );
    
    if (fullWidth) return SizedBox(width: double.infinity, child: card);
    return Expanded(child: card);
  }
}
