import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


// showCommentsSheet(context, postId);
void showCommentsSheet(BuildContext context, String postId) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // يسمح للوحة بالصعود عند ظهور لوحة المفاتيح (اسأل عنها)
    builder: (_) => CommentsSheet(postId: postId),
  );
}

/// واجهة الـ BottomSheet التي تعرض التعليقات وتسمح بإضافة جديد
class CommentsSheet extends StatefulWidget {
  final String postId;
  const CommentsSheet({Key? key, required this.postId}) : super(key: key);

  @override
  State<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  final _db     = FirebaseFirestore.instance;
  final _user   = FirebaseAuth.instance.currentUser!;
  final _ctrl   = TextEditingController();

  List<Map<String, dynamic>> _comments = []; // قائمة التعليقات المحمّلة
  bool _loading = true;                     // حالة التحميل

  @override
  void initState() {

    super.initState();
    _loadComments(); // جلب التعليقات عند إنشاء الودجت
    setState(() {
    });
  }


  //get all comment for post (id)
  void _loadComments() async {
    setState(() {});
    final snap = await _db
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .get();

    _comments = snap.docs.map((d) { // اسأل عن docs and the object
      final data = d.data();
      return {
        'authorId':  data['authorId'],
        'username':  data['username'],
        'avatarURL': data['avatarURL'],
        'text':      data['text'],
        'createdAt': (data['createdAt'] as Timestamp).toDate(),
      };
    }).toList();

    setState(() {
      _loading = false;
    });
  }

  /// يضيف تعليق جديد ثم يعيد تحميل القائمة
  void _addComment() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return; // لا نفعل شيئاً إذا لم يُدخل نص

    // جلب اسم المستخدم وصورة الحساب
    final userDoc = await _db
        .collection('users')
        .doc(_user.uid)
        .get();
    final username  = userDoc.data()?['username']  as String?;
    final avatarURL = userDoc.data()?['avatarURL'] as String?;

    // إضافة التعليق في Firestore
    await _db
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .add({
      'authorId':  _user.uid,
      'username':  username,
      'avatarURL': avatarURL,
      'text':      text,
      'createdAt': Timestamp.now(),
    });

    _ctrl.clear();    // مسح حقل النص
    setState(() => _loading = true);
     _loadComments(); // إعادة التحميل لعرض التعليق الجديد
  }


  String _formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inSeconds < 60) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours   < 24) return '${diff.inHours} hr ago';
    return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      // يضمن صعود الـ BottomSheet عند ظهور لوحة المفاتيح
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min, // يقصر الارتفاع على المحتوى فقط
        children: [
          // إذا كنا في وضع التحميل، نظهر مؤشر دائري
          if (_loading)
             Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            )
          else
          // صندوق ثابت الارتفاع يحتوي على قائمة التعليقات
            SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: _comments.length,
                itemBuilder: (ctx, i) {
                  final c  = _comments[i];
                  final ts = c['createdAt'] as DateTime;
                  return ListTile(
                    // عرض صورة الحساب أو أيقونة افتراضية
                    leading: c['avatarURL'] != null
                        ? CircleAvatar(
                      backgroundImage: NetworkImage(c['avatarURL'] as String),
                    )
                        :  CircleAvatar(child: Icon(Icons.person)),//
                   title: Text(
                      '${c['username']} • ${_formatTimeAgo(ts)} ',style: TextStyle(fontSize: 12),
                    ), // اسم المستخدم و "منذ"
                      subtitle: Text(c['text'],style: TextStyle(fontSize: 17)),  // نص التعليق

                  );
                },
              ),
            ),

          // صف لإضافة تعليق جديد
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [

                Container(
                  width: MediaQuery.of(context).size.width - 80,
                  child: TextField(
                    controller: _ctrl,
                    decoration:  InputDecoration(
                      labelText: 'Write a comment…',
                    ),
                  ),
                ),
                // زر الإرسال
                IconButton(
                  icon:  Icon(Icons.send),
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
