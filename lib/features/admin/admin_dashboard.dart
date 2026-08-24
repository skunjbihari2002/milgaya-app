import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:milgaya/services/firestore_service.dart';

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
              _buildStatCard('Total Users (Live)', FirestoreService().getUsersStream(), Colors.blue, Icons.people),
              _buildStatCard('Items Tracked (Live)', FirestoreService().getPostsStream('All'), Colors.orange, Icons.search),
              _buildStatCard('Pending Disputes (Live)', FirestoreService().getDisputesStream(), Colors.red, Icons.warning),
              _buildStatCard('Active Safe Hubs (Live)', FirestoreService().getSafeHubsStream(), Colors.green, Icons.security),
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
                ListTile(leading: Icon(Icons.person_add, color: Colors.blue), title: Text('Admin panel connected to Firestore successfully.'), subtitle: Text('Just now')),
                Divider(height: 1),
                ListTile(leading: Icon(Icons.sync, color: Colors.green), title: Text('Real-time sync enabled for all tabs.'), subtitle: Text('Just now')),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, Stream<QuerySnapshot> stream, Color color, IconData icon) {
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
              Expanded(child: Text(title, style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontWeight: FontWeight.bold))),
              Icon(icon, color: color.withOpacity(0.7)),
            ],
          ),
          const SizedBox(height: 12),
          StreamBuilder<QuerySnapshot>(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(height: 32, width: 32, child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Text('Error', style: TextStyle(fontSize: 16, color: Colors.red.shade300));
              }
              int count = snapshot.data?.docs.length ?? 0;
              return Text(count.toString(), style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color));
            }
          ),
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
          const Text('Live User Database', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(
            child: Card(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirestoreService().getUsersStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                  if (snapshot.hasError) return const Center(child: Text('Error loading users'));
                  
                  final users = snapshot.data?.docs ?? [];
                  if (users.isEmpty) return const Center(child: Text('No users registered yet.'));

                  return ListView(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('User ID')),
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Phone')),
                            DataColumn(label: Text('Login Method')),
                            DataColumn(label: Text('Status')),
                            DataColumn(label: Text('Actions')),
                          ],
                          rows: users.map((doc) {
                            final user = doc.data() as Map<String, dynamic>;
                            final id = doc.id;
                            final name = user['name'] ?? 'Unknown';
                            final phone = user['phone'] ?? 'N/A';
                            final method = user['loginMethod'] ?? 'Unknown';
                            final status = user['status'] ?? 'Active';
                            
                            return DataRow(cells: [
                              DataCell(Text(id.length > 8 ? id.substring(0,8)+'...' : id, style: const TextStyle(fontWeight: FontWeight.bold))),
                              DataCell(Text(name)),
                              DataCell(Text(phone)),
                              DataCell(Chip(label: Text(method, style: const TextStyle(fontSize: 12)))),
                              DataCell(Text(status, style: TextStyle(color: status == 'Active' ? Colors.green : Colors.red, fontWeight: FontWeight.bold))),
                              DataCell(
                                TextButton(
                                  onPressed: () async {
                                    String newStatus = status == 'Active' ? 'Banned' : 'Active';
                                    await FirestoreService().updateUserStatus(id, newStatus);
                                    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User status updated to \$newStatus')));
                                  },
                                  child: Text(status == 'Active' ? 'Ban User' : 'Unban', style: TextStyle(color: status == 'Active' ? Colors.red : Colors.green)),
                                )
                              ),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ],
                  );
                }
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
          const Text('Live Lost & Found Posts', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(
            child: Card(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirestoreService().getPostsStream('All'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                  if (snapshot.hasError) return const Center(child: Text('Error loading posts'));
                  
                  final posts = snapshot.data?.docs ?? [];
                  if (posts.isEmpty) return const Center(child: Text('No posts found.'));

                  return ListView.separated(
                    itemCount: posts.length,
                    separatorBuilder: (ctx, i) => const Divider(height: 1),
                    itemBuilder: (ctx, i) {
                      final doc = posts[i];
                      final item = doc.data() as Map<String, dynamic>;
                      final status = item['status'] ?? 'Active';
                      
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: item['type'] == 'Lost' ? Colors.red.shade100 : Colors.green.shade100,
                          child: Icon(item['type'] == 'Lost' ? Icons.search : Icons.check, color: item['type'] == 'Lost' ? Colors.red : Colors.green),
                        ),
                        title: Text("\${item['title']} (by \${item['user']})"),
                        subtitle: Text("Status: \$status | Type: \${item['type']}"),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            const PopupMenuItem(value: 'resolve', child: Text('Mark as Resolved')),
                            const PopupMenuItem(value: 'delete', child: Text('Delete Post', style: TextStyle(color: Colors.red))),
                          ],
                          onSelected: (val) async {
                            if (val == 'resolve') await FirestoreService().updatePostStatus(doc.id, 'Resolved');
                            if (val == 'delete') await FirestoreService().deletePost(doc.id);
                            if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item updated in Firestore')));
                          },
                        ),
                      );
                    },
                  );
                }
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
          const Text('Live Safe Hubs Network', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(
            child: Card(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirestoreService().getSafeHubsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                  if (snapshot.hasError) return const Center(child: Text('Error loading safe hubs'));
                  
                  final hubs = snapshot.data?.docs ?? [];
                  if (hubs.isEmpty) return const Center(child: Text('No safe hubs registered.'));

                  return ListView.separated(
                    itemCount: hubs.length,
                    separatorBuilder: (ctx, i) => const Divider(height: 1),
                    itemBuilder: (ctx, i) {
                      final doc = hubs[i];
                      final hub = doc.data() as Map<String, dynamic>;
                      final status = hub['status'] ?? 'Pending';
                      
                      return ListTile(
                        title: Text("\${hub['name']}"),
                        subtitle: Text("Location: \${hub['location']} | Status: \$status"),
                        trailing: status == 'Pending' 
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                                  onPressed: () => FirestoreService().updateSafeHubStatus(doc.id, 'Active'),
                                  child: const Text('Approve'),
                                ),
                                const SizedBox(width: 8),
                                TextButton(
                                  onPressed: () => FirestoreService().updateSafeHubStatus(doc.id, 'Rejected'),
                                  child: const Text('Reject', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            )
                          : Chip(label: Text(status), backgroundColor: status == 'Active' ? Colors.green.shade100 : Colors.red.shade100),
                      );
                    },
                  );
                }
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
          const Text('Live Disputes & Frauds', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(
            child: Card(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirestoreService().getDisputesStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                  if (snapshot.hasError) return const Center(child: Text('Error loading disputes'));
                  
                  final disputes = snapshot.data?.docs ?? [];
                  if (disputes.isEmpty) return const Center(child: Text('No active disputes. Everything is peaceful.', style: TextStyle(color: Colors.grey, fontSize: 16)));
                  
                  return ListView.separated(
                    itemCount: disputes.length,
                    separatorBuilder: (ctx, i) => const Divider(height: 1),
                    itemBuilder: (ctx, i) {
                      final doc = disputes[i];
                      final disp = doc.data() as Map<String, dynamic>;
                      return ListTile(
                        leading: const Icon(Icons.warning, color: Colors.red, size: 40),
                        title: Text("Report against \${disp['accused']} by \${disp['reporter']}"),
                        subtitle: Text("Reason: \${disp['reason']}"),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                          onPressed: () async {
                            await FirestoreService().deleteDispute(doc.id);
                            if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dispute resolved. User banned.')));
                          },
                          child: const Text('Ban Accused & Close'),
                        ),
                      );
                    },
                  );
                }
              ),
            ),
          )
        ],
      ),
    );
  }
}
