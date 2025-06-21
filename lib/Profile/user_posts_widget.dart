import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lose_found/Posts/post_actions.dart';
import 'edit_post.dart';

class AppColors {
  static const Color darkRed   = Color(0xFF3D0A05);
  static const Color greyBeige = Color(0xFFA58570);
  static const Color rubyRed   = Color(0xFF7F1F0E);
  static const Color silk      = Color(0xFFDAC1B1);
  static const Color indianRed = Color(0xFFAC746C);
}

class UserPostsWidget extends StatelessWidget {
  const UserPostsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Text(
            "User not logged in",
            style: TextStyle(color: AppColors.silk),
          ),
        ),
      );
    }

    final query  = FirebaseFirestore.instance
        .collection('posts')
        .where('authorId', isEqualTo: currentUser.uid);

    return StreamBuilder(
      stream: query.snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: AppColors.silk),
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
                style: TextStyle(color: AppColors.silk),
              ),
            ),
          );
        }

        // This ListView.builder itself is NOT scrollable;
        // it will expand to fit its children and let the outer ListView scroll.
        return ListView.builder(
          physics:  NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding:  EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          itemCount: docs.length,
          itemBuilder: (ctx, i) {
            final data = docs[i].data() as Map<String, dynamic>;
            final docId = docs[i].id;

            return Card(
              elevation: 2,
              margin:
               EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Padding(
                padding:  EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if ((data['imageURL'] as String).isNotEmpty) ...[
                       SizedBox(height: 8),
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
                    if ((data['description'] as String).isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        data['description'],
                        style: const TextStyle(color: AppColors.darkRed),
                      ),
                    ],
                    const SizedBox(height: 8),
                    PostActions(
                      key: ValueKey(docId),
                      postId: docId,
                      isResolved: data['isResolved'] as bool,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          icon: const Icon(Icons.edit, color: AppColors.indianRed),
                          label: const Text(
                            'Edit',
                            style: TextStyle(color: AppColors.indianRed),
                          ),
                          onPressed: () {
                            Navigator.push(
                              ctx,
                              MaterialPageRoute(
                                builder: (_) => EditPostScreen(
                                  docId: docId,
                                  initial: data,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
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
