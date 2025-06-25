//import 'package:flutter/material.dart';

//class SupportInboxPage extends StatelessWidget {
  //const SupportInboxPage({super.key});

  //static const Color darkRed = Color(0xFF3D0A05);
  //static const Color silk = Color(0xFFDAC1B1);
  //static const Color greyBeige = Color(0xFFA58570);
  //static const Color rubyRed = Color(0xFF7F1F0E);

  //final List<Map<String, String>> _messages = const [
    //{
      //"title": "Lost item not found",
      //"status": "Pending",
      //"date": "June 20, 2025",
    //},
    //{
     // "title": "Login issue resolved",
      //"status": "Replied",
      //"date": "June 18, 2025",
    //},
    //{
     // "title": "Incorrect item details",
      //"status": "Replied",
/*
      "date": "June 15, 2025",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: silk.withOpacity(0.98),
      appBar: AppBar(
        backgroundColor: rubyRed,
        title: const Text("Support Inbox", style: TextStyle(color: silk,fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final message = _messages[index];
          final isReplied = message["status"] == "Replied";

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: greyBeige.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              title: Text(
                message["title"]!,
                style: const TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.bold,
                  color: darkRed,
                ),
              ),
              subtitle: Row(
                children: [
                  Icon(
                    isReplied ? Icons.check_circle_outline : Icons.access_time,
                    size: 18,
                    color: isReplied ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "${message["status"]} • ${message["date"]}",
                    style: TextStyle(color: greyBeige),
                  ),
                ],
              ),
              trailing: const Icon(Icons.chevron_right, color: greyBeige),
              onTap: () {
                // You can add a detailed message view here
              },
            ),
          );
        },
      ),
    );
  }
}

 */
