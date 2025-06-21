import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_post.dart';
import 'package:firebase_auth/firebase_auth.dart';


// Reuse your AppColors class
class AppColors {
  static const Color darkRed = Color(0xFF3D0A05);
  static const Color greyBeige = Color(0xFFA58570);
  static const Color rubyRed = Color(0xFF7F1F0E);
  static const Color silk = Color(0xFFDAC1B1);
  static const Color indianRed = Color(0xFFAC746C);
}

class SavedPostsScreen extends StatelessWidget {
  const SavedPostsScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final savedQuery = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('savedPosts');

    return Scaffold(
      backgroundColor: AppColors.darkRed,
      appBar: AppBar(
        backgroundColor: AppColors.rubyRed,
        title:
            const Text('Saved Posts', style: TextStyle(color: AppColors.silk)),
        iconTheme: const IconThemeData(color: AppColors.silk),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: savedQuery.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.silk));
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text('No saved posts',
                  style: TextStyle(color: AppColors.silk)),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final postRef = docs[index]['postRef'] as DocumentReference;
              return FutureBuilder<DocumentSnapshot>(
                future: postRef.get(),
                builder: (context, snap) {
                  if (!snap.hasData) return const SizedBox();
                  final postData = snap.data!.data() as Map<String, dynamic>;
                  final docId = docs[index].id;

                  return Card(
                    color: AppColors.rubyRed,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (postData['imageURL'] != null &&
                            postData['imageURL'].isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12)),
                              child: Image.network(postData['imageURL']),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                postData['description'] ?? '',
                                style: const TextStyle(
                                    color: AppColors.silk, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Found? ${(postData['isResolved'] ?? false) ? 'Yes' : 'No'}',
                                style: TextStyle(
                                  color: (postData['isResolved'] ?? false)
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            const Spacer(),
                       //     SavePostButton(postId: docId),
                            ButtonBar(
                              children: [
                                TextButton.icon(
                                  icon: const Icon(Icons.edit,
                                      color: AppColors.indianRed),
                                  label: const Text('Edit',
                                      style: TextStyle(
                                          color: AppColors.indianRed)),
                                  onPressed: () async {
                                    await Navigator.push<Map<String, dynamic>>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => EditPostScreen(
                                          docId: docId,
                                          initial: postData,
                                        ),
                                      ),
                                    );
                                    // No manual update needed, stream handles it
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
