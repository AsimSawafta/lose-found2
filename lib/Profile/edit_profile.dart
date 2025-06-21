import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  final _nameCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _imgCtrl = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser!;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    final data = doc.data()!;

    _nameCtrl.text = data['username'] as String;
    _bioCtrl.text = data['bio'] as String? ?? '';
    _imgCtrl.text = data['avatarURL'] as String;

    setState(() => _loading = false);
  }

  Future<void> _save() async {
    setState(() => _loading = true);
    final user = FirebaseAuth.instance.currentUser!;
    final newName = _nameCtrl.text.trim();
    final newBio = _bioCtrl.text.trim();
    final newUrl = _imgCtrl.text.trim();

    // update user doc
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({
      'username': newName,
      'bio': newBio,
      'avatarURL': newUrl,
    });
    Navigator.pop(context);
    // update posts
    final posts = await FirebaseFirestore.instance
        .collection('posts')
        .where('authorId', isEqualTo: user.uid)
        .get();
    for (final post in posts.docs) {
      await post.reference.update({
        'authorName': newName,
        'authorAvatar': newUrl,
      });
    }

    // update comments
    final allPosts = await FirebaseFirestore.instance
        .collection('posts')
        .get();
    for (final post in allPosts.docs) {
      final comments = await post.reference
          .collection('comments')
          .where('authorId', isEqualTo: user.uid)
          .get();
      for (final c in comments.docs) {
        await c.reference.update({
          'username': newName,
          'avatarURL': newUrl,
        });
      }
    }
   // Navigator.pop(context);
    setState(() {});

  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _bioCtrl.dispose();
    _imgCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFDAC1B1),
      appBar: AppBar(
        title: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF7F1F0E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Name',
              style: TextStyle(
                color: Color(0xFF7F1F0E),
                fontWeight: FontWeight.w200,
                fontSize: 22,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameCtrl,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: border,
                enabledBorder: border,
                focusedBorder: border,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Bio',
              style: TextStyle(
                color: Color(0xFF7F1F0E),
                fontWeight: FontWeight.w200,
                fontSize: 22,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _bioCtrl,
              style: const TextStyle(color: Colors.black),
              maxLines: 3,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: border,
                enabledBorder: border,
                focusedBorder: border,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Avatar URL',
              style: TextStyle(
                color: Color(0xFF7F1F0E),
                fontWeight: FontWeight.w200,
                fontSize: 22,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _imgCtrl,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: border,
                enabledBorder: border,
                focusedBorder: border,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7F1F0E),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

