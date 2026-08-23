import 'package:flutter/material.dart';

class LostFoundTab extends StatelessWidget {
  const LostFoundTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildTopFilter(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildItemCard('FOUND', 'Wallet/Purse', 'Found: Brown leather wallet', 'Found a brown leather wallet near South Congress Ave. Contains several cards — withholding full deta...', 'Sidhi Bus Stand', 'Mike Davis', '4h', null, Icons.account_balance_wallet, Colors.green),
              _buildItemCard('LOST', 'Pet', 'Golden Retriever puppy — Max', 'Lost my 8-month-old Golden Retriever puppy Max near Zilker Park. He has a blue collar with a he...', 'Zilker Park area', 'John Smith', '6h', '\$100', Icons.pets, Colors.orange),
              _buildItemCard('FOUND', 'Keys', 'Found: Honda car keys', 'Found a set of Honda car keys with a red rubber keychain near The Domain parking area. Has about...', 'The Domain parking area', 'Sarah Johnson', '8h', null, Icons.key, Colors.green),
              _buildItemCard('LOST', 'Electronics', 'Deep Purple iPhone 14 Pro Max', 'Lost my deep purple iPhone 14 Pro Max at Rainey Street area. Has a clear case with a few stickers. I...', 'Rainey Street area', 'Unknown', '12h', '\$50', Icons.phone_iphone, Colors.orange),
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
          const Text('Lost & Found', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.security, color: Colors.green),
                tooltip: 'Verified Safe Hubs',
                onPressed: () {},
              ),
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
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTopFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(24)),
        child: Row(
          children: [
            Expanded(child: _buildFilterTab('All Posts', true)),
            Expanded(child: _buildFilterTab('Lost Items', false)),
            Expanded(child: _buildFilterTab('Found Items', false)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTab(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF1976D2) : Colors.transparent,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(text, textAlign: TextAlign.center, style: TextStyle(color: isSelected ? Colors.white : Colors.grey.shade600, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildItemCard(String type, String category, String title, String desc, String location, String user, String time, String? reward, IconData icon, Color color) {
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
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: Icon(icon, color: color, size: 30),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(type == 'LOST' ? Icons.search : Icons.star, size: 14, color: color),
                          const SizedBox(width: 4),
                          Text(type, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          Text(category, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                if (reward != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: Colors.yellow.shade100, borderRadius: BorderRadius.circular(16)),
                    child: Text(reward, style: TextStyle(color: Colors.orange.shade800, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(desc, style: const TextStyle(color: Colors.grey), maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(child: Text(location, style: const TextStyle(color: Colors.grey, fontSize: 12), overflow: TextOverflow.ellipsis)),
                CircleAvatar(radius: 12, backgroundColor: Colors.blue.shade100, child: Text(user[0], style: const TextStyle(fontSize: 12, color: Color(0xFF1976D2)))),
                const SizedBox(width: 4),
                Text(user, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
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
