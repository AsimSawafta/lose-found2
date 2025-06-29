
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'comments_sheet.dart';

class PostActions extends StatefulWidget {
  final String postId;
  final bool isResolved;

  const PostActions({
    Key? key,
    required this.postId,
    required this.isResolved,
  }) : super(key: key);

  @override
  State<PostActions> createState() => _PostActionsState();
}

class _PostActionsState extends State<PostActions> {
  int likeCount = 0;
  bool isLiked = false;
  final _db = FirebaseFirestore.instance;
  final _user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    _loadPost();
  }


  void _loadPost() async {
    final snap = await _db
        .collection('posts')
        .doc(widget.postId)
        .collection('likes')
        .get();
    setState(() {
      likeCount = snap.docs.length;
      //is liked تاكد هل المستخدم الحالي عامل لايك على هاد البوست او لأ
      isLiked = snap.docs.any((d) => d.id == _user.uid);
    });
  }
//هاد بفحص ازا المستخدم عمل لايك على اشي ازا عمل بظهر انه عمل عند عدد الكاونت ازا ما عمل ما بظهر
  void _toggleLike() async {
    final likeRef = _db
        .collection('posts')
        .doc(widget.postId)
        .collection('likes')
        .doc(_user.uid);

    if (isLiked) {
      await likeRef.delete();
      setState(() {
        likeCount--;
        isLiked = false;
      });
    } else {
      //Timestamp هو نوع بيانات خاص بـ Firebase Firestore، يُستخدم لتخزين التواريخ والأوقات بدقة
      //,nowانه بتنشا وقت زمني حالي مثلا بظهر للمستخدم لايك قبل 3 دقايق
      await likeRef.set({'timestamp': Timestamp.now()});
      setState(() {
        likeCount++;
        isLiked = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          widget.isResolved ? Icons.check_circle : Icons.error_outline,
          color: widget.isResolved ? Colors.green : Colors.red,
        ),
         SizedBox(width: 8),
        Text(
          widget.isResolved ? 'Founded' : 'Lose',
          style:  TextStyle(fontWeight: FontWeight.w600),
        ),

         Spacer(),

        IconButton(
          icon: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked ? Colors.red : Colors.black,
          ),
          onPressed: _toggleLike,
        ),
        Text('$likeCount'),

         SizedBox(width: 16),

        IconButton(
          icon:  Icon(Icons.mode_comment_outlined),
          onPressed: () => showCommentsSheet(context, widget.postId),
        ),
        SavePostButton(postId: widget.postId),
      ],
    );
  }
}

class SavePostButton extends StatefulWidget {
  final String postId;

  const SavePostButton({Key? key, required this.postId}) : super(key: key);

  @override
  _SavePostButtonState createState() => _SavePostButtonState();
}

class _SavePostButtonState extends State<SavePostButton> {
  bool isSaved = false;
  final user = FirebaseAuth.instance.currentUser!;
  final _db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _checkIfSaved();
  }

  Future<void> _checkIfSaved() async {
    final doc = await _db
        .collection('users')
        .doc(user.uid)
        .collection('savedPosts')
        .doc(widget.postId)
        .get();
    setState(() {
      isSaved = doc.exists;
    });
  }

  Future<void> _toggleSave() async {
    final savedRef = _db
        .collection('users')
        .doc(user.uid)
        .collection('savedPosts')
        .doc(widget.postId);

    if (isSaved) {
      await savedRef.delete();
    } else {
      await savedRef.set({
        'postRef': FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId),
        'savedAt': Timestamp.now(),
      });
    }

    setState(() {
      isSaved = !isSaved;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isSaved ? Icons.bookmark : Icons.bookmark_border,
        color: isSaved ? Colors.orange : Colors.black,
      ),
      onPressed: _toggleSave,
    );
  }
}

