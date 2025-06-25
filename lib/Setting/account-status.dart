import 'package:flutter/material.dart';

class AccountStatusPage extends StatelessWidget {
  const AccountStatusPage({super.key});

  static const Color darkRed = Color(0xFF3D0A05);
  static const Color greyBeige = Color(0xFFA58570);
  static const Color rubyRed = Color(0xFF7F1F0E);
  static const Color silk = Color(0xFFDAC1B1);
  static const Color indianRed = Color(0xFFAC746C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: silk.withOpacity(0.98),
      appBar: AppBar(
        backgroundColor: rubyRed,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Account Status',
          style: TextStyle(color: silk, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: darkRed.withOpacity(0.15),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
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
                  Text("User Type: Student", style: TextStyle(fontSize: 16, color: darkRed)),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.email, color: darkRed),
                  SizedBox(width: 10),
                  Text("Email: aqdar@student.aaup.edu", style: TextStyle(fontSize: 16, color: darkRed)),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.access_time, color: darkRed),
                  SizedBox(width: 10),
                  Text("Last Login: June 22, 2025 - 3:45 PM", style: TextStyle(fontSize: 16, color: darkRed)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
