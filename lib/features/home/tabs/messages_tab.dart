import 'package:flutter/material.dart';
import 'package:milgaya/services/mock_database.dart';

class MessagesTab extends StatefulWidget {
  const MessagesTab({super.key});

  @override
  State<MessagesTab> createState() => _MessagesTabState();
}

class _MessagesTabState extends State<MessagesTab> {
  @override
  Widget build(BuildContext context) {
    final msgs = MockDatabase().messages;

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
          child: msgs.isEmpty
            ? const Center(child: Text('No messages yet', style: TextStyle(color: Colors.grey)))
            : ListView.separated(
                itemCount: msgs.length,
                separatorBuilder: (ctx, i) => const Divider(height: 1, indent: 70),
                itemBuilder: (context, index) {
                  final m = msgs[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.blue.shade50,
                          child: Text(m['avatar'], style: const TextStyle(color: Color(0xFF1976D2), fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        if (m['unread'])
                          Positioned(
                            right: 0, top: 0,
                            child: Container(width: 12, height: 12, decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2))),
                          )
                      ],
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(m['name'], style: TextStyle(fontWeight: m['unread'] ? FontWeight.bold : FontWeight.normal, fontSize: 16)),
                        Text(m['time'], style: TextStyle(color: m['unread'] ? const Color(0xFF1976D2) : Colors.grey, fontSize: 12, fontWeight: m['unread'] ? FontWeight.bold : FontWeight.normal)),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(m['msg'], style: TextStyle(color: m['unread'] ? Colors.black87 : Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: () {
                      setState(() => m['unread'] = false);
                    },
                  );
                },
              ),
        ),
      ],
    );
  }
}
