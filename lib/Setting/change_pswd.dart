
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  static const Color darkRed = Color(0xFF3D0A05);
  static const Color greyBeige = Color(0xFFA58570);
  static const Color rubyRed = Color(0xFF7F1F0E);
  static const Color silk = Color(0xFFDAC1B1);
  static const Color indianRed = Color(0xFFAC746C);

  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;

  void _handleChangePassword() async {
    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();


    if (currentPassword.isEmpty || newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in both fields.")),
      );
      return;
    }


    if (newPassword.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("New password must be at least 6 characters.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {

      final user = FirebaseAuth.instance.currentUser!;
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );

        await user.reauthenticateWithCredential(credential);

        // Update to new password
        await user.updatePassword(newPassword);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Password changed successfully!")),
        );

        _currentPasswordController.clear();
        _newPasswordController.clear();
        Navigator.pushNamed(context, '/home');

    } catch (e) {
      // If any error happens, show a simple message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Make sure your current password is correct.")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
//Asim@2003

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:  IconThemeData(color: Colors.white),
        leading: IconButton(
          icon:  Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: rubyRed,
        foregroundColor: Colors.white,

        title: Text("Change Password"),

      ),
      backgroundColor: silk.withOpacity(0.95),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(24),
          margin: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12),
                Text(
                  "Your password must be at least 6 characters.",
                  style: TextStyle(fontSize: 14, color: rubyRed),
                ),
                SizedBox(height: 20),
                _buildTextField(
                  label: "Current password",
                  controller: _currentPasswordController,
                  obscureText: _obscureCurrentPassword,
                  onToggleVisibility: () {
                    setState(() => _obscureCurrentPassword = !_obscureCurrentPassword);
                  },
                ),
                SizedBox(height: 16),
                _buildTextField(
                  label: "New password",
                  controller: _newPasswordController,
                  obscureText: _obscureNewPassword,
                  onToggleVisibility: () {
                    setState(() => _obscureNewPassword = !_obscureNewPassword);
                  },
                ),
                SizedBox(height: 60),
                Center(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleChangePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: indianRed,
                      padding: EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                        side: BorderSide(color: rubyRed.withOpacity(0.8), width: 2),
                      ),
                      elevation: 8,
                      shadowColor: indianRed,
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                      "Save Change",
                      style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: darkRed),
        filled: true,
        fillColor: silk.withOpacity(0.3),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: rubyRed,
          ),
          onPressed: onToggleVisibility,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: greyBeige),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: greyBeige.withOpacity(0.6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: rubyRed, width: 2),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }
}
