import 'package:flutter/material.dart';
import 'package:milgaya/services/mock_database.dart';

class LostFoundTab extends StatefulWidget {
  const LostFoundTab({super.key});

  @override
  State<LostFoundTab> createState() => _LostFoundTabState();
}

class _LostFoundTabState extends State<LostFoundTab> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final items = MockDatabase().lostFoundItems.where((item) {
      if (_selectedFilter == 'All') return true;
      return item['type'] == _selectedFilter;
    }).toList();

    return Column(
      children: [
        _buildHeader(),
        _buildFilterPills(),
        Expanded(
          child: items.isEmpty
            ? const Center(child: Text('No items found.', style: TextStyle(color: Colors.grey)))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _buildItemCard(
                    item['type'], 
                    item['title'], 
                    item['desc'], 
                    item['user'], 
                    item['time'], 
                    item['tagColor'] == 'red' ? Colors.red : Colors.green
                  );
                },
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
          const Text('Lost & Found', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildPill('All'),
          _buildPill('Lost'),
          _buildPill('Found'),
          const Spacer(),
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
    );
  }

  Widget _buildPill(String text) {
    bool isSelected = _selectedFilter == text;
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

  Widget _buildItemCard(String type, String title, String desc, String user, String time, Color tagColor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: const BorderRadius.vertical(top: Radius.circular(16))),
            child: const Center(child: Icon(Icons.image, size: 40, color: Colors.grey)),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: tagColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                      child: Text(type.toUpperCase(), style: TextStyle(color: tagColor, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 12),
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(color: Colors.grey), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 16),
                Row(
                  children: [
                    CircleAvatar(radius: 14, backgroundColor: Colors.blue.shade50, child: Text(user.isNotEmpty ? user[0] : 'U', style: const TextStyle(fontSize: 12, color: Color(0xFF1976D2), fontWeight: FontWeight.bold))),
                    const SizedBox(width: 8),
                    Text(user, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.orange.shade200)),
                      child: const Row(
                        children: [
                          Icon(Icons.security, size: 12, color: Colors.orange),
                          SizedBox(width: 4),
                          Text('Safe Hub Match', style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
