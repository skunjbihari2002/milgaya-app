import 'package:flutter/material.dart';

class HelpTab extends StatelessWidget {
  const HelpTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildFilterPills(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildHelpCard('PET CARE', 'Dog walking needed this weekend', 'Need someone to walk my 2-year-old Labrador, Max, 45 minutes each morning this weekend. Very...', 'Sarah Johnson', '5h', '\$25', Icons.pets),
              _buildHelpCard('TECH HELP', 'Laptop tech support needed', 'My MacBook is running slow and needs a tune-up. Looking for someone experienced to clean it up, re...', 'John Smith', '1d', '\$40', Icons.computer),
              _buildHelpCard('YARD WORK', 'Garden cleanup and lawn mowing', 'Backyard needs serious cleanup - overgrown weeds, grass mowing, and light tidying. All tools pr...', 'Mike Davis', '2d', '\$60', Icons.eco),
              _buildHelpCard('OTHER', 'I want a person that help us to write a notes.', 'Hdhskks', 'Unknown', '3d', '\$1', Icons.build),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Help Requests', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(20)),
            child: const Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Color(0xFF1976D2)),
                SizedBox(width: 4),
                Text('Sidhi, MP', style: TextStyle(color: Color(0xFF1976D2), fontWeight: FontWeight.bold)),
                Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFF1976D2)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFilterPills() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildPill('All', true),
          _buildPill('Moving', false),
          _buildPill('Pet Care', false),
          _buildPill('Tech Help', false),
          _buildPill('Errands', false),
        ],
      ),
    );
  }

  Widget _buildPill(String text, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF1976D2) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? const Color(0xFF1976D2) : Colors.grey.shade300),
      ),
      child: Text(text, style: TextStyle(color: isSelected ? Colors.white : Colors.grey.shade700, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildHelpCard(String category, String title, String desc, String user, String time, String price, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                  child: Icon(icon, color: const Color(0xFF1976D2)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(category, style: const TextStyle(color: Color(0xFF1976D2), fontSize: 12, fontWeight: FontWeight.bold)),
                      Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(16)),
                  child: Text(price, style: const TextStyle(color: Color(0xFF1976D2), fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(desc, style: const TextStyle(color: Colors.grey), maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(radius: 12, backgroundColor: Colors.blue.shade100, child: Text(user[0], style: const TextStyle(fontSize: 12, color: Color(0xFF1976D2)))),
                const SizedBox(width: 8),
                Text(user, style: const TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(4)),
                  child: const Text('open', style: TextStyle(color: Colors.green, fontSize: 12)),
                ),
                const SizedBox(width: 8),
                Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
