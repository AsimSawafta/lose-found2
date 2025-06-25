import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lose_found/Posts/post_actions.dart';
import 'edit_post.dart';

class UserPostsWidget extends StatelessWidget {
  const UserPostsWidget({Key? key}) : super(key: key);

  String formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inSeconds < 60) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
  }

  @override
  Widget build(BuildContext context) {
    //!يعني متاكد انه القيمه الحاليه مش null
    //userRef يمثل مرجعًا (Pointer) إلى بيانات المستخدم الحالي المخزنة في Firestore ضمن مجموعة users
    final user = FirebaseAuth.instance.currentUser!;
    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .where('authorRef', isEqualTo: userRef).snapshots(),
      builder: (context, snapshot) {
        //كانه قويري وين الuthorRef نفسه UserRef
        //ي حاله ما في  كةنينشكن بظهر دائره التحميل
        if (snapshot.connectionState == ConnectionState.waiting) {
          return  Center(child: CircularProgressIndicator());
        }
        //في حاله ما قي بوست بظهر نو بوست يت
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return  Center(child: Text('No posts yet.'));
        }
        //ازا ولا حاله
        //لسناب شوت متغير فيه داتا من الفييربيس
        //ازا ولا شرط ببني lisview طولها نفس طول الدوكس
        final docs = snapshot.data!.docs;
        return ListView.builder(
          shrinkWrap: true,
          physics:  NeverScrollableScrollPhysics(),
          //حتى ما تاخذ القيمه ارتفاع اكبر من محتواها
          //
          itemCount: docs.length,
          itemBuilder: (context, i) {
            final data = docs[i].data()! as Map<String, dynamic>;
            final postId = docs[i].id;
            final createdAt = (data['createdAt'] as Timestamp).toDate();
            final imageURL = data['imageURL'] as String;
            final description = data['description'] as String;
            final isResolved = data['isResolved'] as bool;
            final authorRef = data['authorRef'] as DocumentReference;
             //برجع كارد في مواصفات التالنيه
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              elevation: 2,//يعني الظل
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // header with real-time author info + edit button
                    StreamBuilder(
                      stream: authorRef.snapshots(),
                      builder: (context, snap) {
                        if (snap.connectionState == ConnectionState.waiting) {
                          return Row(
                            children: const [
                              CircleAvatar(radius: 20),
                              SizedBox(width: 12),
                              Text(
                                'Loading…',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          );
                        }
                        if (!snap.hasData || !snap.data!.exists) {
                          return Row(
                            children: const [
                              CircleAvatar(radius: 20),
                              SizedBox(width: 12),
                              Text(
                                'Unknown user',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          );
                        }
                        final userData =
                        snap.data!.data()! as Map<String, dynamic>;
                        final authorName =
                            userData['username'] as String? ?? '';
                        final authorAvatar =
                            userData['avatarURL'] as String? ?? '';
                        return Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: authorAvatar.isNotEmpty
                                  ? NetworkImage(authorAvatar)
                                  : null,
                              child: authorAvatar.isEmpty
                                  ? const Icon(Icons.person,
                                  size: 20, color: Colors.white)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  authorName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  formatTimeAgo(createdAt),
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                size: 20,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditPostScreen(
                                      docId: postId,
                                      initial: data,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
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

                    const SizedBox(height: 8),
                    PostActions(
                      key: ValueKey(postId),
                      postId: postId,
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
  }
}
