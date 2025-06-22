import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lose_found/AnotherUsersProfiles/UserPosts.dart';

class UsersProfile extends StatefulWidget {
  final String uid;
  const UsersProfile({Key? key, required this.uid}) : super(key: key);

  @override
  _UsersProfileState createState() => _UsersProfileState();
}

class AppColors {
  static const Color darkRed   = Color(0xFF3D0A05);
  static const Color silk      = Color(0xFFDAC1B1);
  static const Color indianRed = Color(0xFFAC746C);
}

class _UsersProfileState extends State<UsersProfile> {
  String? username;
  String? bio;
  String? avatarUrl;
  bool _isLoading = true;
  DateTime? joined;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get();

    if (!doc.exists) {
      setState(() => _isLoading = false);
      return;
    }

    final data = doc.data()!;
    setState(() {
      username   = data['username']   as String?;
      bio        = data['bio']        as String?;
      avatarUrl  = data['avatarURL']  as String?;
      joined     = (data['createdAt'] as Timestamp).toDate();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.silk,
      body: ListView(
        children: [
          Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: AppColors.silk,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: avatarUrl != null
                        ? NetworkImage(avatarUrl!)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username ?? '',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkRed,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        bio ?? 'no bio',
                        style: const TextStyle(color: AppColors.indianRed),
                      ),
                      const SizedBox(height: 4),
                      if (joined != null)
                        Text(

                          'Joined: ${formatShortDate(joined!.toLocal())}',
                          style: const TextStyle(color: AppColors.indianRed),
                        ),
                    ],
                  ),
                ],
              ),
            ),

          ],
        ),
          Divider(color: Color(0xFFA58570)),
           UserPosts(
                key: ValueKey(widget.uid),
                uid: widget.uid,
              ),
            ]
      ),
    );
  }
}


String formatShortDate(DateTime date) {
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '${date.year}-$m-$d';
}
//'Joined: ${formatShortDate(joined!.toLocal())}',