import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Milgaya Control Center (Admin)'),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            extended: true,
            labelType: NavigationRailLabelType.none,
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.dashboard), label: Text('Dashboard')),
              NavigationRailDestination(icon: Icon(Icons.people), label: Text('User Management')),
              NavigationRailDestination(icon: Icon(Icons.search), label: Text('Lost/Found Items')),
              NavigationRailDestination(icon: Icon(Icons.security), label: Text('Safe Hubs')),
              NavigationRailDestination(icon: Icon(Icons.gavel), label: Text('Disputes & Frauds')),
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
      case 4: return const Center(child: Text('Active Disputes & Frauds (0 Pending)', style: TextStyle(fontSize: 24)));
      default: return const Center(child: Text('Overview'));
    }
  }

  Widget _buildOverview() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('System Progress & Stats', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildStatCard('Total Users', '12,450', Colors.blue),
              const SizedBox(width: 16),
              _buildStatCard('Active Sessions', '342', Colors.green),
              const SizedBox(width: 16),
              _buildStatCard('Lost Items', '8,024', Colors.red),
              const SizedBox(width: 16),
              _buildStatCard('Recovered Items', '6,110', Colors.orange),
            ],
          ),
          const SizedBox(height: 32),
          const Text('Recent Activity', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const ListTile(leading: Icon(Icons.person_add), title: Text('New user registered via OTP (ID: USR-982)'), subtitle: Text('2 mins ago')),
          const ListTile(leading: Icon(Icons.check_circle, color: Colors.green), title: Text('Match found for Black Wallet in Bhopal'), subtitle: Text('15 mins ago')),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 16, color: Colors.grey.shade700)),
              const SizedBox(height: 8),
              Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserManagement() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text('User Database', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        DataTable(
          columns: const [
            DataColumn(label: Text('User ID')),
            DataColumn(label: Text('Name / Phone')),
            DataColumn(label: Text('Login Method')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Actions')),
          ],
          rows: [
            _buildUserRow('USR-001', 'Rahul Sharma', 'Password', 'Active'),
            _buildUserRow('USR-002', '+91 9876543210', 'OTP Verification', 'Active'),
            _buildUserRow('USR-003', 'Priya Singh', 'Google Sign-In', 'Active'),
            _buildUserRow('USR-004', 'Suspicious User', 'OTP Verification', 'Banned'),
          ],
        )
      ],
    );
  }

  DataRow _buildUserRow(String id, String name, String method, String status) {
    return DataRow(cells: [
      DataCell(Text(id, style: const TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text(name)),
      DataCell(Chip(label: Text(method, style: const TextStyle(fontSize: 12)))),
      DataCell(Text(status, style: TextStyle(color: status == 'Active' ? Colors.green : Colors.red, fontWeight: FontWeight.bold))),
      DataCell(TextButton(onPressed: (){}, child: const Text('View Profile'))),
    ]);
  }

  Widget _buildItemsManagement() {
    return const Center(child: Text('Live tracking of all Lost & Found items across India', style: TextStyle(fontSize: 20)));
  }

  Widget _buildSafeHubsApproval() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text('Pending Safe Hub Approvals', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ListTile(
          tileColor: Colors.grey.shade100,
          title: const Text('Sharma Electronics (Bhopal)'),
          subtitle: const Text('Owner ID: USR-001 | Verification Docs: Uploaded'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(icon: const Icon(Icons.check), label: const Text('Approve'), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white), onPressed: () {}),
              const SizedBox(width: 8),
              ElevatedButton.icon(icon: const Icon(Icons.close), label: const Text('Reject'), style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white), onPressed: () {}),
            ],
          ),
        )
      ],
    );
  }
}
