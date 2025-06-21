import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'post_actions.dart';

class PostsList extends StatelessWidget {
  const PostsList({Key? key}) : super(key: key);

  String formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inSeconds < 60) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No posts yet.'));
        }

        final docs = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: docs.length,
          itemBuilder: (context, i) {
            final data = docs[i].data() as Map<String, dynamic>;
            final postId = docs[i].id;

            final createdAt = (data['createdAt'] as Timestamp?)?.toDate();

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              elevation: 2,
              child: Padding(
                padding:  EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // header
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: (data['authorAvatar'] as String).isNotEmpty
                              ? NetworkImage(data['authorAvatar'])
                              : null,
                          child: (data['authorAvatar'] as String).isEmpty
                              ? const Icon(Icons.person,
                              size: 20, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['authorName'],
                                style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                            if (createdAt != null)
                              Text(formatTimeAgo(createdAt),
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),

                    // description
                    if ((data['description'] as String).isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(data['description']),
                    ],

                    // image
                    if ((data['imageURL'] as String).isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(data['imageURL']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],

                    // actions
                    const SizedBox(height: 8),
                    PostActions(
                      key: ValueKey(postId),
                      postId: postId,
                      isResolved: data['isResolved'] as bool,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
