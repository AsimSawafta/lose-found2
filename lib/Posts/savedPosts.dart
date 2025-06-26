import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'post_actions.dart';

class SavedPostsScreen extends StatelessWidget {
  const SavedPostsScreen({Key? key}) : super(key: key);

  String formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inSeconds < 60) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final db = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(title:  Text('Saved Posts')),
      body: StreamBuilder(
        stream: db
            .collection('users')
            .doc(user.uid)
            .collection('savedPosts')
            .orderBy('savedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return  Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return  Center(child: Text('No saved posts yet.'));
          }

          final savedRefs = snapshot.data!.docs;
          return ListView.builder(
            padding:  EdgeInsets.all(8),
            itemCount: savedRefs.length,
            itemBuilder: (context, index) {
              final ref = savedRefs[index]['postRef'] as DocumentReference;

              return FutureBuilder(
                future: ref.get(),
                builder: (context, postSnap) {

                  if (!postSnap.hasData || !postSnap.data!.exists) {
                    return  SizedBox();
                  }

                  final doc = postSnap.data!;
                  final data = doc.data() as Map<String, dynamic>;
                  final postId = doc.id;
                  final createdAt = (data['createdAt'] as Timestamp).toDate();
                  final authorRef = data['authorRef'] as DocumentReference;

                  return Card(
                    margin:  EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    elevation: 2,
                    child: Padding(
                      padding:  EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // author info
                          StreamBuilder<DocumentSnapshot>(
                            stream: authorRef.snapshots(),
                            builder: (context, userSnap) {
                              if (userSnap.connectionState == ConnectionState.waiting) {
                                return  Row(
                                  children: [
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                    SizedBox(width: 8),
                                    Text('Loading…'),
                                  ],
                                );
                              }
                              if (!userSnap.hasData || !userSnap.data!.exists) {
                                return  Text(
                                  'Unknown user',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                );
                              }

                              final u = userSnap.data!.data()! as Map<String, dynamic>;
                              final avatar = (u['avatarURL'] as String?) ?? '';
                              final name = (u['username'] as String?) ?? '';

                              return Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: avatar.isNotEmpty ? NetworkImage(avatar) : null,
                                    child: avatar.isEmpty
                                        ?  Icon(Icons.person, size: 20, color: Colors.white)
                                        : null,
                                  ),
                                   SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(name,
                                          style:  TextStyle(fontWeight: FontWeight.bold)),
                                      Text(formatTimeAgo(createdAt),
                                          style:  TextStyle(
                                              fontSize: 12, color: Colors.grey)),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),

                          // description
                          if ((data['description'] as String).isNotEmpty) ...[
                             SizedBox(height: 8),
                            Text(data['description'] as String),
                          ],

                          // image
                          if ((data['imageURL'] as String).isNotEmpty) ...[
                             SizedBox(height: 8),
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

                           SizedBox(height: 8),
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
        },
      ),
    );
  }
}
