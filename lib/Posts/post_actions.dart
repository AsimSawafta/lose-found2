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

  @override
  void initState() {
    super.initState();
    _loadPost();
  }

  void _loadPost() async {
    final doc = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .get();

    final data = doc.data() ?? {};
    final List<dynamic> likedBy = data['likedBy'] ?? [];

    setState(() {
      likeCount = likedBy.length;
      isLiked = likedBy.contains(FirebaseAuth.instance.currentUser!.uid);
    });
  }

 void _toggleLike() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final postRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId);
//delete the id from likedBy
    if (isLiked) {

      await postRef.update({
        'likedBy': FieldValue.arrayRemove([uid]),
      });
      setState(() {
        likeCount--;
        isLiked = false;
      });
    } else {
      //add the id from likedBy
      await postRef.update({
        'likedBy': FieldValue.arrayUnion([uid]),
      });
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
        const SizedBox(width: 8),
        Text(
          widget.isResolved ? 'Founded' : 'Lose',
          style:  TextStyle(fontWeight: FontWeight.w600),
        ),

        const Spacer(),

        //
        IconButton(
          icon: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked ? Colors.red : Colors.black54,
          ),
          onPressed: _toggleLike,
        ),
        Text('$likeCount'),

        const SizedBox(width: 16),


        IconButton(
          icon: const Icon(Icons.mode_comment_outlined),
          onPressed: () => showCommentsSheet(context, widget.postId),
        ),
        SavePostButton(postId: widget.postId)
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

  @override
  void initState() {
    super.initState();
    _checkIfSaved();
  }

  Future<void> _checkIfSaved() async {
    final doc = await FirebaseFirestore.instance
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
    final savedRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('savedPosts')
        .doc(widget.postId);

    if (isSaved) {
      await savedRef.delete();
    } else {
      await savedRef.set({
        'postRef': FirebaseFirestore.instance.collection('posts').doc(widget.postId),
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
        color: isSaved ? Colors.orange : Colors.grey,
      ),
      onPressed: _toggleSave,
    );
  }
}

