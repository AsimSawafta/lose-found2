
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Posts/posts.dart';
import 'Search.dart';
import 'Profile/profile.dart';
import 'Setting/settings.dart';
import 'messages.dart';

class AppColors {
  static const Color darkRed = Color(0xFF3D0A05);
  static const Color greyBeige = Color(0xFFA58570);
  static const Color rubyRed = Color(0xFF7F1F0E);
  static const Color silk = Color(0xFFDAC1B1);
  static const Color indianRed = Color(0xFFAC746C);
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 1; // 0=Profile, 1=Home, 2=Search, 3=Settings, 4=Messages
  String? _uid;
  String? _avatarUrl;
  bool _isLoading = true;

  final _formKey = GlobalKey<FormState>();
  final _descCtrl = TextEditingController();
  final _imageUrlCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser!;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    final data = doc.data()!;
    setState(() {
      _uid       = user.uid;
      _avatarUrl = data['avatarURL'] as String?;
      _isLoading = false;
    });
  }

  void _showAddPostDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.silk,
        title: Text('Add New Post', style: TextStyle(color: AppColors.darkRed)),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _descCtrl,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: AppColors.darkRed),
                  hintText: 'Enter description',
                  hintStyle: TextStyle(color: AppColors.greyBeige),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.rubyRed),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.indianRed, width: 2),
                  ),
                ),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                style: TextStyle(color: AppColors.darkRed),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _imageUrlCtrl,
                decoration: InputDecoration(
                  labelText: 'Image URL',
                  labelStyle: TextStyle(color: AppColors.darkRed),
                  hintText: 'https://example.com/img.jpg',
                  hintStyle: TextStyle(color: AppColors.greyBeige),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.rubyRed),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.indianRed, width: 2),
                  ),
                ),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                style: TextStyle(color: AppColors.darkRed),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _descCtrl.clear();
              _imageUrlCtrl.clear();
              Navigator.pop(context);
            },
            child: Text('Cancel', style: TextStyle(color: AppColors.darkRed)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.rubyRed,
            ),
            onPressed: () async {
              if (!(_formKey.currentState?.validate() ?? false)) return;
              await FirebaseFirestore.instance.collection('posts').add({
                // now store reference to the user document
                'authorRef': FirebaseFirestore.instance.doc('users/$_uid'),
                'description': _descCtrl.text.trim(),
                'imageURL': _imageUrlCtrl.text.trim(),
                'isResolved': false,
                // وظيفه الTimestamp
                'createdAt': Timestamp.now(),
              });

              _descCtrl.clear();
              _imageUrlCtrl.clear();
              Navigator.pop(context);
              setState(() {}); // refresh list

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Post published!')),
              );
            },
            child: const Text('Publish', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    _imageUrlCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      Profile(),
      Center(
        child: _isLoading
            ? CircularProgressIndicator(color: AppColors.rubyRed)
            : PostsList(),
      ),
      Search(),
      settings(),
      _uid != null
          ? Messages(currentUserId: _uid!)
          : Center(child: CircularProgressIndicator()),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          ['Profile', 'Home', 'Search', 'Settings', 'Messages'][_currentIndex],
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppColors.rubyRed,
        centerTitle: true,
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (idx) => setState(() => _currentIndex = idx),
        selectedItemColor: AppColors.rubyRed,
        unselectedItemColor: AppColors.greyBeige,
        backgroundColor: AppColors.silk,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
        ],
      ),
      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton(
        backgroundColor: AppColors.rubyRed,
        onPressed: _showAddPostDialog,
        child: const Icon(Icons.add, color: Colors.white),
      )
          : null,
    );
  }
}
