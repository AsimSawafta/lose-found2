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
          return  Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return  Center(child: Text('No posts yet.'));
        }

        final docs = snapshot.data!.docs;
        return ListView.builder(
          padding:  EdgeInsets.all(8),
          itemCount: docs.length,
          itemBuilder: (context, i) {
            final doc = docs[i];
            final data = doc.data() as Map<String, dynamic>;
            final postId = doc.id;
            final createdAt = (data['createdAt'] as Timestamp).toDate();
            final authorRef = data['authorRef'] ;

            return Card(
              margin:  EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              elevation: 2,

              child: Padding(
                padding:  EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // header with StreamBuilder
                    StreamBuilder(
                      stream: (authorRef as DocumentReference).snapshots(),
                      builder: (context, snap) {
                        if (snap.connectionState == ConnectionState.waiting) {
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
                        if (!snap.hasData || !snap.data!.exists) {
                          return  Text(
                            'Unknown user',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          );
                        }
                        final user = snap.data!.data()! as Map<String, dynamic>;
                        final avatar = (user['avatarURL'] as String?) ?? '';
                        final name = (user['username'] as String?) ?? '';
                        return Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage:
                              avatar.isNotEmpty ? NetworkImage(avatar) : null,
                              child: avatar.isEmpty
                                  ?  Icon(Icons.person,
                                  size: 20, color: Colors.white)
                                  : null,
                            ),
                             SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name, style:
                                     TextStyle(fontWeight: FontWeight.bold)),
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

                    // actions
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
  }
}

