import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountStatusPage extends StatefulWidget {
  @override
  _AccountStatusPageState createState() => _AccountStatusPageState();
}

class _AccountStatusPageState extends State<AccountStatusPage> {
  static const Color darkRed = Color(0xFF3D0A05);

  static const Color rubyRed = Color(0xFF7F1F0E);
  static const Color silk = Color(0xFFDAC1B1);


  String? email, username;
  DateTime? joined;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = FirebaseAuth.instance.currentUser!;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    final data = doc.data()!;


    setState(() {
      email = user.email;
      username = data['username'];
      joined = (data['createdAt'] as Timestamp).toDate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: silk.withOpacity(0.98),
      appBar: AppBar(
        backgroundColor: rubyRed,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Account Status',
          style: TextStyle(color: silk, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: darkRed.withOpacity(0.15),
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.verified_user, color: darkRed),
                  SizedBox(width: 10),
                  Text("Status: Active", style: TextStyle(fontSize: 16, color: darkRed)),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.person, color: darkRed),
                  SizedBox(width: 10),
                  Text("User Name: ${username ?? 'Loading...'}", style: TextStyle(fontSize: 16, color: darkRed)),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.email, color: darkRed),
                  SizedBox(width: 10),
                  Text("Email: ${email ?? 'Loading...'}", style: TextStyle(fontSize: 16, color: darkRed)),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.access_time, color: darkRed),
                  SizedBox(width: 10),
                  Text("Joined: ${joined != null ? joined.toString() : 'Loading...'}", style: TextStyle(fontSize: 16, color: darkRed)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
