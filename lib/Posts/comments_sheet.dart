import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


void showCommentsSheet(BuildContext context, String postId) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => CommentsSheet(postId: postId),
  );
}

class CommentsSheet extends StatefulWidget {
  final String postId;
  const CommentsSheet({Key? key, required this.postId}) : super(key: key);

  @override
  State<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  final _db = FirebaseFirestore.instance;
  final _user = FirebaseAuth.instance.currentUser!;
  final _ctrl = TextEditingController();

  List<Map<String, dynamic>> _comments = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  void _loadComments() async {
    final snap = await _db
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .get();

    _comments = snap.docs.map((d) {
      final data = d.data();
      return {
        'authorRef': data['authorRef'] as DocumentReference,
        'text': data['text'] as String,
        'createdAt': (data['createdAt'] as Timestamp).toDate(),
      };
    }).toList();

    setState(() {
      _loading = false;
    });
  }

  void _addComment() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;

    await _db
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .add({
      'authorRef': _db.doc('users/${_user.uid}'),
      'text': text,
      'createdAt': Timestamp.now(),
    });

    _ctrl.clear();
    setState(() => _loading = true);
    _loadComments();
  }

  String _formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inSeconds < 60) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            )
          else
            SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: _comments.length,
                itemBuilder: (ctx, i) {
                  final commnet = _comments[i];
                  final ts = commnet['createdAt'] as DateTime;
                  final authorRef = commnet['authorRef'] as DocumentReference;
                  //الفيوتشر بلدر بدي ابني واجهه بناء على عمليه متزامنه
                  return FutureBuilder(
                    future: authorRef.get(),
                    builder: (_, snap) {
                      //لما يبدا تحميل البيانات ازا البيانات ما وصلو
                      if (!snap.hasData) {
                        return ListTile(
                          leading: CircleAvatar(child: Icon(Icons.person)),
                          //...لا نعرف اسم المستخدم لانه البيانات لسا مو واصله من الفييربيس
                          title: Text('… • ${_formatTimeAgo(ts)}'),
                          subtitle: Text(commnet['text'] as String),
                        );
                      }
                      final user = snap.data!.data()! as Map<String, dynamic>;
                      return ListTile(
                        leading: user['avatarURL'] != null
                            ? CircleAvatar(
                          backgroundImage: NetworkImage(user['avatarURL']),
                        )
                            : const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(
                          '${user['username']} • ${_formatTimeAgo(ts)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        subtitle: Text(
                          commnet['text'] as String,
                          style: const TextStyle(fontSize: 17),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    decoration:  InputDecoration(
                      labelText: 'Write a comment…',

                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _addComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



