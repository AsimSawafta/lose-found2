import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lose_found/Posts/post_actions.dart';

class UserPosts extends StatelessWidget {
  final String postId;

  const UserPosts({
    Key? key,
    required this.postId,
  }) : super(key: key);

  String formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inSeconds < 60) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
  }

  @override
  Widget build(BuildContext context) {
    final query = FirebaseFirestore.instance
        .collection('posts')
        .where('authorId', isEqualTo: postId);

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text(
                "Error loading posts",
                style: TextStyle(color: Colors.black),
              ),
            ),
          );
        }

        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text(
                "You haven't posted anything yet",
                style: TextStyle(color: Colors.black),
              ),
            ),
          );
        }

        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          itemCount: docs.length,
          itemBuilder: (context, i) {
            final docSnapshot = docs[i];
            final data = docSnapshot.data();
            final thisPostId = docSnapshot.id;
            final createdAt = (data['createdAt'] as Timestamp?)?.toDate();

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
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
                              ? const Icon(Icons.person, size: 20, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['authorName'] as String? ?? '',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            if (createdAt != null)
                              Text(
                                formatTimeAgo(createdAt),
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                          ],
                        ),
                      ],
                    ),

                    // description
                    if ((data['description'] as String?)?.isNotEmpty ?? false) ...[
                      const SizedBox(height: 8),
                      Text(data['description'] as String),
                    ],

                    // image
                    if ((data['imageURL'] as String?)?.isNotEmpty ?? false) ...[
                      const SizedBox(height: 8),
                      Container(
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(data['imageURL'] as String),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],

                    // actions
                    const SizedBox(height: 8),
                    PostActions(
                      key: ValueKey(thisPostId),
                      postId: thisPostId,
                      isResolved: data['isResolved'] as bool? ?? false,
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
