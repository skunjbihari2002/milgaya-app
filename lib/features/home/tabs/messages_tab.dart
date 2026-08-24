import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:milgaya/services/firestore_service.dart';

class MessagesTab extends StatefulWidget {
  const MessagesTab({super.key});

  @override
  State<MessagesTab> createState() => _MessagesTabState();
}

class _MessagesTabState extends State<MessagesTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Text('Messages', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.grey.shade100,
          child: const Text('CHATS', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1)),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirestoreService().getMessagesStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
              if (snapshot.hasError) return const Center(child: Text('Error loading messages'));
              
              final msgs = snapshot.data?.docs ?? [];
              if (msgs.isEmpty) return const Center(child: Text('No messages yet', style: TextStyle(color: Colors.grey)));

              return ListView.separated(
                itemCount: msgs.length,
                separatorBuilder: (ctx, i) => const Divider(height: 1, indent: 70),
                itemBuilder: (context, index) {
                  final m = msgs[index].data() as Map<String, dynamic>;
                  final isUnread = m['unread'] == true;
                  final name = m['name'] ?? 'Unknown';
                  final msgText = m['msg'] ?? '';
                  final time = m['time'] ?? 'Just now';
                  final avatar = m['avatar'] ?? (name.isNotEmpty ? name[0] : 'U');

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.blue.shade50,
                          child: Text(avatar, style: const TextStyle(color: Color(0xFF1976D2), fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        if (isUnread)
                          Positioned(
                            right: 0, top: 0,
                            child: Container(width: 12, height: 12, decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2))),
                          )
                      ],
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(name, style: TextStyle(fontWeight: isUnread ? FontWeight.bold : FontWeight.normal, fontSize: 16)),
                        Text(time, style: TextStyle(color: isUnread ? const Color(0xFF1976D2) : Colors.grey, fontSize: 12, fontWeight: isUnread ? FontWeight.bold : FontWeight.normal)),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(msgText, style: TextStyle(color: isUnread ? Colors.black87 : Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: () async {
                      if (isUnread) {
                        // Mark as read in Firestore
                        await FirebaseFirestore.instance.collection('messages').doc(msgs[index].id).update({'unread': false});
                      }
                    },
                  );
                },
              );
            }
          ),
        ),
      ],
    );
  }
}
