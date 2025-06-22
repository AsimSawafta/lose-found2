import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lose_found/Posts/post_actions.dart';

class UserPosts extends StatelessWidget {
  final String uid;

  const UserPosts({
    Key? key,
    required this.uid,
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
    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
    final query = FirebaseFirestore.instance
        .collection('posts')
        .where('authorRef', isEqualTo: userRef);


    return StreamBuilder(
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
                "haven't posted anything yet",
                style: TextStyle(color: Colors.black),
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: docs.length,
          shrinkWrap: true,
          physics:  NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),

          itemBuilder: (context, i) {
            final docSnapshot = docs[i];
            final data = docSnapshot.data();
            final thisPostId = docSnapshot.id;
            final createdAt = (data['createdAt'] as Timestamp).toDate();
            final description = data['description'] as String? ?? '';
            final imageURL = data['imageURL'] as String? ?? '';
            final isResolved = data['isResolved'] as bool? ?? false;
            final authorRef = data['authorRef'] as DocumentReference;

            return FutureBuilder(
              future: authorRef.get(),
              builder: (context, snap) {
                final hasUser = snap.hasData && snap.data!.exists;
                final userData = hasUser ? snap.data!.data()! as Map<String, dynamic>: <String, dynamic>{};
                final authorName = userData['username'] as String? ?? '';
                final authorAvatar = userData['avatarURL'] as String? ?? '';

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
                              backgroundImage: authorAvatar.isNotEmpty
                                  ? NetworkImage(authorAvatar)
                                  : null,
                              child: authorAvatar.isEmpty
                                  ? const Icon(Icons.person, size: 20, color: Colors.white)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  authorName,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  formatTimeAgo(createdAt),
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // description
                        if (description.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(description),
                        ],

                        // image
                        if (imageURL.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Container(
                            height: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(imageURL),
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
                          isResolved: isResolved,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

