import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  // Mock Data States for Interactive Feel
  List<Map<String, dynamic>> _users = [
    {'id': 'USR-001', 'name': 'Rahul Sharma', 'method': 'Password', 'status': 'Active'},
    {'id': 'USR-002', 'name': '+91 9876543210', 'method': 'OTP Verification', 'status': 'Active'},
    {'id': 'USR-003', 'name': 'Priya Singh', 'method': 'Google', 'status': 'Active'},
    {'id': 'USR-004', 'name': 'Suspicious User', 'method': 'OTP', 'status': 'Banned'},
  ];

  List<Map<String, dynamic>> _lostFoundItems = [
    {'id': 'ITEM-991', 'type': 'Lost', 'title': 'Black Leather Wallet', 'location': 'Bhopal DB Mall', 'status': 'Pending'},
    {'id': 'ITEM-992', 'type': 'Found', 'title': 'iPhone 13 Pro', 'location': 'Indore Airport', 'status': 'Matched'},
    {'id': 'ITEM-993', 'type': 'Lost', 'title': 'College ID Card', 'location': 'Jabalpur Station', 'status': 'Resolved'},
  ];

  List<Map<String, dynamic>> _safeHubs = [
    {'id': 'HUB-101', 'name': 'Sharma Electronics', 'location': 'Bhopal', 'status': 'Pending'},
    {'id': 'HUB-102', 'name': 'City Cafe', 'location': 'Indore', 'status': 'Active'},
  ];

  List<Map<String, dynamic>> _disputes = [
    {'id': 'DSP-501', 'reporter': 'USR-001', 'accused': 'USR-004', 'reason': 'Asked for money before returning item', 'status': 'Open'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Milgaya Control Center (Admin)'),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) => setState(() => _selectedIndex = index),
            extended: MediaQuery.of(context).size.width > 800,
            backgroundColor: Colors.grey.shade50,
            selectedIconTheme: const IconThemeData(color: Color(0xFF1976D2)),
            selectedLabelTextStyle: const TextStyle(color: Color(0xFF1976D2), fontWeight: FontWeight.bold),
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: Text('Dashboard')),
              NavigationRailDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: Text('Users')),
              NavigationRailDestination(icon: Icon(Icons.search_outlined), selectedIcon: Icon(Icons.search), label: Text('Lost & Found')),
              NavigationRailDestination(icon: Icon(Icons.security_outlined), selectedIcon: Icon(Icons.security), label: Text('Safe Hubs')),
              NavigationRailDestination(icon: Icon(Icons.gavel_outlined), selectedIcon: Icon(Icons.gavel), label: Text('Disputes')),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: _buildContent())
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0: return _buildOverview();
      case 1: return _buildUserManagement();
      case 2: return _buildItemsManagement();
      case 3: return _buildSafeHubsApproval();
      case 4: return _buildDisputes();
      default: return const Center(child: Text('Overview'));
    }
  }

  // --- 1. OVERVIEW ---
  Widget _buildOverview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('System Progress & Stats', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16, runSpacing: 16,
            children: [
              _buildStatCard('Total Users', '${_users.length}k', Colors.blue, Icons.people),
              _buildStatCard('Active Sessions', '342', Colors.green, Icons.phone_android),
              _buildStatCard('Items Tracked', '${_lostFoundItems.length}k', Colors.orange, Icons.search),
              _buildStatCard('Pending Disputes', '${_disputes.length}', Colors.red, Icons.warning),
            ],
          ),
          const SizedBox(height: 32),
          const Text('Recent System Activity', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Card(
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                ListTile(leading: Icon(Icons.person_add, color: Colors.blue), title: Text('New user registered via OTP (ID: USR-982)'), subtitle: Text('2 mins ago')),
                Divider(height: 1),
                ListTile(leading: Icon(Icons.check_circle, color: Colors.green), title: Text('Match found for iPhone 13 in Indore'), subtitle: Text('15 mins ago')),
                Divider(height: 1),
                ListTile(leading: Icon(Icons.security, color: Colors.purple), title: Text('New Safe Hub application submitted'), subtitle: Text('1 hour ago')),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10, spreadRadius: 2)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
              Icon(icon, color: color.withOpacity(0.7)),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  // --- 2. USER MANAGEMENT ---
  Widget _buildUserManagement() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('User Database', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(decoration: InputDecoration(hintText: 'Search by User ID, Name, or Phone...', prefixIcon: const Icon(Icons.search), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)))),
          const SizedBox(height: 16),
          Expanded(
            child: Card(
              child: ListView(
                children: [
                  DataTable(
                    columns: const [
                      DataColumn(label: Text('User ID')),
                      DataColumn(label: Text('Name / Phone')),
                      DataColumn(label: Text('Login Method')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: _users.map((user) => DataRow(cells: [
                      DataCell(Text(user['id'], style: const TextStyle(fontWeight: FontWeight.bold))),
                      DataCell(Text(user['name'])),
                      DataCell(Chip(label: Text(user['method'], style: const TextStyle(fontSize: 12)))),
                      DataCell(Text(user['status'], style: TextStyle(color: user['status'] == 'Active' ? Colors.green : Colors.red, fontWeight: FontWeight.bold))),
                      DataCell(
                        TextButton(
                          onPressed: () {
                            setState(() {
                              user['status'] = user['status'] == 'Active' ? 'Banned' : 'Active';
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User ${user['id']} status updated to ${user['status']}')));
                          },
                          child: Text(user['status'] == 'Active' ? 'Ban User' : 'Unban', style: TextStyle(color: user['status'] == 'Active' ? Colors.red : Colors.green)),
                        )
                      ),
                    ])).toList(),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // --- 3. LOST & FOUND ITEMS ---
  Widget _buildItemsManagement() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Lost & Found Items', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(
            child: Card(
              child: ListView.separated(
                itemCount: _lostFoundItems.length,
                separatorBuilder: (ctx, i) => const Divider(height: 1),
                itemBuilder: (ctx, i) {
                  final item = _lostFoundItems[i];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: item['type'] == 'Lost' ? Colors.red.shade100 : Colors.green.shade100,
                      child: Icon(item['type'] == 'Lost' ? Icons.search : Icons.check, color: item['type'] == 'Lost' ? Colors.red : Colors.green),
                    ),
                    title: Text('${item['title']} (${item['id']})'),
                    subtitle: Text('Location: ${item['location']} | Status: ${item['status']}'),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'resolve', child: Text('Mark as Resolved')),
                        const PopupMenuItem(value: 'delete', child: Text('Delete Post', style: TextStyle(color: Colors.red))),
                      ],
                      onSelected: (val) {
                        setState(() {
                          if (val == 'resolve') item['status'] = 'Resolved';
                          if (val == 'delete') _lostFoundItems.removeAt(i);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item updated successfully')));
                      },
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  // --- 4. SAFE HUBS ---
  Widget _buildSafeHubsApproval() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Safe Hubs Network', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(
            child: Card(
              child: ListView.separated(
                itemCount: _safeHubs.length,
                separatorBuilder: (ctx, i) => const Divider(height: 1),
                itemBuilder: (ctx, i) {
                  final hub = _safeHubs[i];
                  return ListTile(
                    title: Text('${hub['name']} (${hub['id']})'),
                    subtitle: Text('Location: ${hub['location']} | Status: ${hub['status']}'),
                    trailing: hub['status'] == 'Pending' 
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                              onPressed: () => setState(() => hub['status'] = 'Active'),
                              child: const Text('Approve'),
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () => setState(() => _safeHubs.removeAt(i)),
                              child: const Text('Reject', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        )
                      : Chip(label: Text(hub['status']), backgroundColor: Colors.green.shade100),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  // --- 5. DISPUTES & FRAUDS ---
  Widget _buildDisputes() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Disputes & Frauds', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(
            child: Card(
              child: _disputes.isEmpty 
                ? const Center(child: Text('No active disputes. Everything is peaceful.', style: TextStyle(color: Colors.grey, fontSize: 16)))
                : ListView.separated(
                itemCount: _disputes.length,
                separatorBuilder: (ctx, i) => const Divider(height: 1),
                itemBuilder: (ctx, i) {
                  final disp = _disputes[i];
                  return ListTile(
                    leading: const Icon(Icons.warning, color: Colors.red, size: 40),
                    title: Text('Report against ${disp['accused']} by ${disp['reporter']}'),
                    subtitle: Text('Reason: ${disp['reason']}'),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                      onPressed: () {
                        setState(() => _disputes.removeAt(i));
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dispute resolved. User banned.')));
                      },
                      child: const Text('Ban Accused & Close'),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
