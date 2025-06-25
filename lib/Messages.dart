import 'package:flutter/material.dart';

class AppColors {
  static const Color darkRed = Color(0xFF3D0A05);
  static const Color greyBeige = Color(0xFFA58570);
  static const Color rubyRed = Color(0xFF7F1F0E);
  static const Color silk = Color(0xFFDAC1B1);
  static const Color indianRed = Color(0xFFAC746C);
}

class Messages extends StatelessWidget {
  final String currentUserId;

  const Messages({Key? key, required this.currentUserId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> chatUsers = [
      {
        'name': 'Ahmed',
        'lastMessage': 'Hey, how are you doing today? This message might be long so let\'s see how it wraps.',
        'imageURL': 'https://images.unsplash.com/photo-1527980965255-d3b416303d12?w=100',
        'lastActive': '2 min ago',
      },
      {
        'name': 'Sara',
        'lastMessage': 'I will call you later.',
        'imageURL': 'https://images.unsplash.com/photo-1502767089025-6572583495b4?w=100',
        'lastActive': '10 min ago',
      },
      {
        'name': 'Mona',
        'lastMessage': 'Thanks for your help! See you soon.',
        'imageURL': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
        'lastActive': '1 hr ago',
      },
      {
        'name': 'Omar',
        'lastMessage': 'Check your email.',
        'imageURL': 'https://images.unsplash.com/photo-1547425260-76bcadfb4f2c?w=100',
        'lastActive': 'Yesterday',
      },
      {
        'name': 'Asim',
        'lastMessage': 'Let’s meet after class.',
        'imageURL': 'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?w=100',
        'lastActive': '5 min ago',
      },
      {
        'name': 'Noor',
        'lastMessage': 'Sure, I will bring it tomorrow.',
        'imageURL': 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=100',
        'lastActive': '30 min ago',
      },
      {
        'name': 'Zozo',
        'lastMessage': 'Haha, that was funny!',
        'imageURL': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100',
        'lastActive': 'Today',
      },
      {
        'name': 'Yahya',
        'lastMessage': 'Don’t forget the meeting.',
        'imageURL': 'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=100',
        'lastActive': '2 hrs ago',
      },
      {
        'name': 'Lama',
        'lastMessage': 'Can you send me the file?',
        'imageURL': 'https://images.unsplash.com/photo-1544005313-6b6b37cd9c5b?w=100',
        'lastActive': '1 hr ago',
      },
      {
        'name': 'Tariq',
        'lastMessage': 'Let’s catch up soon.',
        'imageURL': 'https://images.unsplash.com/photo-1552374196-c4e7ffc6e126?w=100',
        'lastActive': 'Yesterday',
      },
    ];


    final List<Map<String, dynamic>> recentChats = [
      {
        'name': 'Lina',
        'imageURL': 'https://images.unsplash.com/photo-1542156822-7e89f6e80f16?w=80',
      },
      {
        'name': 'Yousef',
        'imageURL': 'https://images.unsplash.com/photo-1546525848-3ce03ca516f6?w=80',
      },
      {
        'name': 'Nada',
        'imageURL': 'https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?w=80',
      },
      {
        'name': 'Fadi',
        'imageURL': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=80',
      },
      {
        'name': 'Rana',
        'imageURL': 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=80',
      },
      {
        'name': 'Asim',
        'imageURL': 'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?w=80',
      },
      {
        'name': 'Noor',
        'imageURL': 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=80',
      },
      {
        'name': 'Zozo',
        'imageURL': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=80',
      },
      {
        'name': 'Yahya',
        'imageURL': 'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=80',
      },
      {
        'name': 'Tariq',
        'imageURL': 'https://images.unsplash.com/photo-1552374196-c4e7ffc6e126?w=80',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.silk,

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 12, bottom: 8),
            child: Text(
              "Recent Chats",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.rubyRed,
              ),
            ),
          ),
          SizedBox(
            height: 90,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: recentChats.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final user = recentChats[index];
                return GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Open chat with ${user['name']}')),
                    );
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(user['imageURL']),
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: 60,
                        child: Text(
                          user['name'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.indianRed,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.only(left: 16, bottom: 8),
            child: Text(
              "All Chats",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.rubyRed,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: chatUsers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final user = chatUsers[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        offset: const Offset(0, 2),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(user['imageURL']),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    user['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: AppColors.rubyRed,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  user['lastActive'],
                                  style: const TextStyle(
                                    color: AppColors.indianRed,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              user['lastMessage'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.indianRed,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      //  شلت أزرار Call و Chat عشان ما يصير overflow
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),

    );
  }
}
