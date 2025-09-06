/*import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy doctor list for now
    final doctors = [
      {
        "doctorId": "1",
        "doctorName": "Dr. Alice Tan",
        "photo": "https://randomuser.me/api/portraits/women/44.jpg",
        "lastMessage": "See you at 10am tomorrow!",
      },
      {
        "doctorId": "2",
        "doctorName": "Dr. John Lee",
        "photo": "https://randomuser.me/api/portraits/men/32.jpg",
        "lastMessage": "Thank you for your feedback.",
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Chat with Doctor")),
      body: ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (context, i) {
          final doc = doctors[i];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                doc["photo"] ?? '',
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(doc["doctorName"] ?? ''),
            subtitle: Text(doc["lastMessage"] ?? ''),
            onTap: () {
              // Navigate to chat screen with this doctor
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          DoctorChatScreen(doctorId: doc["doctorId"] ?? ""),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Dummy chat screen for a doctor
class DoctorChatScreen extends StatelessWidget {
  final String doctorId;
  const DoctorChatScreen({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat with Doctor")),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              // Show chat messages here
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                    ),
                  ),
                ),
                IconButton(icon: const Icon(Icons.send), onPressed: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy doctor list for now
    final doctors = [
      {
        "doctorId": "1",
        "doctorName": "Dr. Alice Tan",
        "photo": "https://randomuser.me/api/portraits/women/44.jpg",
        "lastMessage": "See you at 10am tomorrow!",
      },
      {
        "doctorId": "2",
        "doctorName": "Dr. John Lee",
        "photo": "https://randomuser.me/api/portraits/men/32.jpg",
        "lastMessage": "Thank you for your feedback.",
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Chat with Doctor")),
      body: ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (context, i) {
          final doc = doctors[i];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                doc["photo"] ?? '',
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(doc["doctorName"] ?? ''),
            subtitle: Text(doc["lastMessage"] ?? ''),
            onTap: () {
              // Navigate to chat screen with this doctor
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          DoctorChatScreen(doctorId: doc["doctorId"] ?? ""),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// 🔹 Chat screen with extra options (message, call, video)
class DoctorChatScreen extends StatelessWidget {
  final String doctorId;
  const DoctorChatScreen({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat with Doctor"),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Voice call feature coming soon")),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Video call feature coming soon")),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: const [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Hello, how can I help you today?"),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    // message sending logic
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
