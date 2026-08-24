import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:milgaya/services/firestore_service.dart';

class HelpTab extends StatefulWidget {
  const HelpTab({super.key});

  @override
  State<HelpTab> createState() => _HelpTabState();
}

class _HelpTabState extends State<HelpTab> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Moving', 'Pet Care', 'Tech Help', 'Errands', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildFilterPills(),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirestoreService().getHelpRequestsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Error loading help requests'));
              }
              
              final allRequests = snapshot.data?.docs ?? [];
              
              // Filter locally for now since we just pull all
              final filteredRequests = allRequests.where((doc) {
                if (_selectedFilter == 'All') return true;
                final data = doc.data() as Map<String, dynamic>;
                final category = data['category']?.toString().toUpperCase() ?? '';
                return category == _selectedFilter.toUpperCase();
              }).toList();
              
              if (filteredRequests.isEmpty) {
                return const Center(child: Text('No help requests found in this category.', style: TextStyle(color: Colors.grey)));
              }
              
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredRequests.length,
                itemBuilder: (context, index) {
                  final req = filteredRequests[index].data() as Map<String, dynamic>;
                  IconData icon = Icons.build;
                  if (req['icon'] == 'pets') icon = Icons.pets;
                  if (req['icon'] == 'computer') icon = Icons.computer;
                  if (req['icon'] == 'eco') icon = Icons.eco;
                  
                  return _buildHelpCard(
                    req['category'] ?? 'OTHER', 
                    req['title'] ?? 'No Title', 
                    req['desc'] ?? '', 
                    req['user'] ?? 'Unknown', 
                    req['time'] ?? 'Just now', 
                    req['price'] ?? 'Negotiable', 
                    icon
                  );
                },
              );
            }
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
        children: _filters.map((filter) => _buildPill(filter, _selectedFilter == filter)).toList(),
      ),
    );
  }

  Widget _buildPill(String text, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = text),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1976D2) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFF1976D2) : Colors.grey.shade300),
        ),
        child: Text(text, style: TextStyle(color: isSelected ? Colors.white : Colors.grey.shade700, fontWeight: FontWeight.bold)),
      ),
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
                CircleAvatar(radius: 12, backgroundColor: Colors.blue.shade100, child: Text(user.isNotEmpty ? user[0] : 'U', style: const TextStyle(fontSize: 12, color: Color(0xFF1976D2)))),
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
