import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppColors {
  static const Color darkRed = Color(0xFF3D0A05);
  static const Color greyBeige = Color(0xFFA58570);
  static const Color rubyRed = Color(0xFF7F1F0E);
  static const Color silk = Color(0xFFDAC1B1);
  static const Color indianRed = Color(0xFFAC746C);
}

class EditPostScreen extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> initial;

  const EditPostScreen({
    Key? key,
    required this.docId,
    required this.initial,
  }) : super(key: key);

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  late TextEditingController _descCtrl, _imgCtrl;
  bool _found = false;

  @override
  void initState() {
    super.initState();
    _descCtrl = TextEditingController(text: widget.initial['description']);
    _imgCtrl = TextEditingController(text: widget.initial['imageURL']);
    _found = widget.initial['isResolved'] ?? false;
  }

  void _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.darkRed,
        title:  Text('Delete Post', style: TextStyle(color: AppColors.silk)),
        content:  Text(
          'Are you sure you want to delete this post?',
          style: TextStyle(color: AppColors.greyBeige),
        ),
        actions: [
          TextButton(
            child:  Text('Cancel', style: TextStyle(color: AppColors.indianRed)),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child:  Text('Delete'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.docId)
          .delete();
      Navigator.pop(context, {'deleted': true});
    }
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    _imgCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.docId)
        .update({
      'description': _descCtrl.text.trim(),
      'imageURL': _imgCtrl.text.trim(),
      'isResolved': _found,
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    );

    return Scaffold(
      backgroundColor: AppColors.silk,
      appBar: AppBar(
        backgroundColor: AppColors.rubyRed,
        title:  Text('Edit Post', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon:  Icon(Icons.delete_outline),
            color: Colors.white,
            tooltip: 'Delete Post',
            onPressed: _delete,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding:  EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

             Text('Image URL', style: TextStyle(
               color: AppColors.rubyRed,
               fontWeight: FontWeight.w200,
               fontSize: 22,
               letterSpacing: 0.5,

             )),
             SizedBox(height: 8),
            TextField(
              controller: _imgCtrl,
              style:  TextStyle(color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: border,
                enabledBorder: border,
                focusedBorder: border,
                contentPadding:  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
             SizedBox(height: 16),

             Text('Description',  style: TextStyle(
              color: AppColors.rubyRed,
              fontWeight: FontWeight.w200,
              fontSize: 22,
              letterSpacing: 0.5,

            )),
             SizedBox(height: 8),
            TextField(
              controller: _descCtrl,
              maxLines: 4,
              style:  TextStyle(color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: border,
                enabledBorder: border,
                focusedBorder: border,
                contentPadding:  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
             SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SwitchListTile(
                contentPadding:  EdgeInsets.symmetric(horizontal: 16),
                activeColor: Colors.green,
                inactiveThumbColor: Colors.red,
                title:  Text('Found?', style: TextStyle(color: Colors.black)),
                value: _found,
                onChanged: (v) => setState(() => _found = v),
              ),
            ),
             SizedBox(height: 32),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.rubyRed,
                padding:  EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child:  Text('Save Changes', style: TextStyle(color: Colors.white,fontSize: 16,)),
            ),
          ],
        ),
      ),
    );
  }
}
