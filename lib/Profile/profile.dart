import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_posts_widget.dart';

class AppColors {
  static const Color darkRed   = Color(0xFF3D0A05);
  static const Color greyBeige = Color(0xFFA58570);
  static const Color rubyRed   = Color(0xFF7F1F0E);
  static const Color silk      = Color(0xFFDAC1B1);
  static const Color indianRed = Color(0xFFAC746C);
}

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<Profile> {
  String? uid, email, username, avatarUrl, bio;
  DateTime? joined;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = FirebaseAuth.instance.currentUser!;
    final doc  = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    final data = doc.data()!;

    setState(() {
      uid       = user.uid;
      email     = user.email;
      username  = data['username']   as String;
      avatarUrl = data['avatarURL']  as String;
      bio       = data['bio']        as String?;
      joined    = (data['createdAt'] as Timestamp).toDate();
      isLoading = false;
    });

  }

  // Future<void> _onEdit() async {
  //   final updated = await Navigator.push<ProfileData>(
  //     context,
  //     MaterialPageRoute(
  //       builder: (_) => EditProfileScreen(
  //         initial: ProfileData(username!, bio!, avatarUrl!),
  //       ),
  //     ),
  //   );
  //   if (updated != null) {
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(uid)
  //         .update({
  //       'username':  updated.name,
  //       'bio':       updated.bio,
  //       'avatarURL': updated.imageUrl,
  //     });
  //
  //     final posts = await FirebaseFirestore.instance
  //         .collection('posts')
  //         .where('authorId', isEqualTo: uid)
  //         .get();
  //
  //     for (final post in posts.docs) {
  //       await FirebaseFirestore.instance
  //           .collection('posts')
  //           .doc(post.id)
  //           .update({
  //         'authorName': updated.name,
  //         'authorAvatar': updated.imageUrl,
  //       });
  //     }
  //
  //     final allPosts = await FirebaseFirestore.instance
  //         .collection('posts')
  //         .get();
  //
  //     for (final post in allPosts.docs) {
  //       final comments = await FirebaseFirestore.instance
  //           .collection('posts')
  //           .doc(post.id)
  //           .collection('comments')
  //           .where('authorId', isEqualTo: uid)
  //           .get();
  //
  //       for (final comment in comments.docs) {
  //         await FirebaseFirestore.instance
  //             .collection('posts')
  //             .doc(post.id)
  //             .collection('comments')
  //             .doc(comment.id)
  //             .update({
  //           'username': updated.name,
  //           'avatarURL': updated.imageUrl,
  //         });
  //       }
  //     }
  //
  //     setState(() {
  //       _loadProfile();
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.silk,
      body: ListView(
        children: [

          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.silk,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(avatarUrl!),
                ),
                const SizedBox(width: 16),


                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkRed,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bio ?? '',
                      style: const TextStyle(color: AppColors.greyBeige),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Joined: ${joined!.toLocal().toShortDateString()}',
                      style: const TextStyle(color: AppColors.indianRed),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit, color: AppColors.darkRed),
                  // onPressed: _onEdit,
                  onPressed: ()async {
                    await Navigator.pushNamed(context, '/editProfile');
                    await _loadProfile();
                  setState(() {

                  });

                  }

                ),
              ],
            ),
          ),

           Divider(color: AppColors.greyBeige),

          // ----- POSTS -----
           UserPostsWidget(),
        ],
      ),
    );
  }
}

extension on DateTime {
  String toShortDateString() {
    final m = month.toString().padLeft(2, '0');
    final d = day.toString().padLeft(2, '0');
    return '$year-$m-$d';
  }
}
