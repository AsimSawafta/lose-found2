import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppColors {
  static const Color darkRed = Color(0xFF3D0A05);
  static const Color greyBeige = Color(0xFFA58570);
  static const Color rubyRed = Color(0xFF7F1F0E);
  static const Color silk = Color(0xFFDAC1B1);
  static const Color indianRed = Color(0xFFAC746C);
  static const Color background = Color(0xFFF5F5F5);
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  void _signUp() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_passwordCtrl.text != _confirmPasswordCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    setState(() {
      _loading = true;
    });

    final email = _emailCtrl.text.trim();
    final username = _usernameCtrl.text.trim();
    final pass = _passwordCtrl.text;

    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
      final uid = cred.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'email': email,
        'username': username,
        'bio': '',
        'avatarURL':
        'https://media.istockphoto.com/id/1337144146/vector/default-avatar-profile-icon-vector.jpg?s=612x612&w=0&k=20&c=BIbFwuv7FxTWvh5S3vB6bkT0Qv8Vn8N5Ffseq84ClGI=',
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration Successfully')),
      );

      Navigator.pushNamed(context, '/signIn');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign-up failed: ${e.message}'),
          backgroundColor: AppColors.rubyRed,
        ),
      );
    }  finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.rubyRed,
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ],
                  image: DecorationImage(
                    image: AssetImage('assets/img.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 28),
              Text(
                'Create Account',
                style: TextStyle(
                  color: AppColors.darkRed,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(
                      color: AppColors.rubyRed,
                      offset: Offset(0, 2),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Join us now!',
                style: TextStyle(
                  color: AppColors.indianRed,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                          color: AppColors.darkRed,
                          fontWeight: FontWeight.w600),
                      decoration: _inputDecoration('Email', Icons.email_outlined),
                      validator: (val) =>
                      (val == null || val.isEmpty) ? 'Email is required' : null,
                    ),
                    SizedBox(height: 24),
                    TextFormField(
                      controller: _usernameCtrl,
                      style: TextStyle(
                          color: AppColors.darkRed,
                          fontWeight: FontWeight.w600),
                      decoration:
                      _inputDecoration('Username', Icons.person_outline),
                      validator: (val) => (val == null || val.isEmpty)
                          ? 'Username is required'
                          : null,
                    ),
                    SizedBox(height: 24),
                    TextFormField(
                      controller: _passwordCtrl,
                      obscureText: _obscurePassword,
                      style: TextStyle(
                          color: AppColors.darkRed,
                          fontWeight: FontWeight.w600),
                      decoration: _inputDecoration(
                        'Password',
                        Icons.lock_outline,
                        toggle: () => setState(() {
                          _obscurePassword = !_obscurePassword;
                        }),
                        isObscure: _obscurePassword,
                      ),
                      validator: (val) => (val == null || val.length < 6)
                          ? 'Min 6 characters'
                          : null,
                    ),
                    SizedBox(height: 24),
                    TextFormField(
                      controller: _confirmPasswordCtrl,
                      obscureText: _obscureConfirm,
                      style: TextStyle(
                          color: AppColors.darkRed,
                          fontWeight: FontWeight.w600),
                      decoration: _inputDecoration(
                        'Confirm Password',
                        Icons.lock_outline,
                        toggle: () => setState(() {
                          _obscureConfirm = !_obscureConfirm;
                        }),
                        isObscure: _obscureConfirm,
                      ),
                      validator: (val) => (val == null || val.length < 6)
                          ? 'Min 6 characters'
                          : null,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.rubyRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 8,
                    shadowColor: AppColors.rubyRed,
                  ),
                  child: _loading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.silk,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(
                        color: AppColors.darkRed,
                        fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/signIn'),
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        color: AppColors.rubyRed,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                        letterSpacing: 1,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon,
      { toggle, bool isObscure = false}) {

    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hint,
      hintStyle:
      TextStyle(color: AppColors.greyBeige, fontWeight: FontWeight.w500),
      prefixIcon: Icon(icon, color: AppColors.rubyRed),
      suffixIcon: toggle != null
          ? IconButton(
        icon: Icon(
          isObscure
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: AppColors.rubyRed,
        ),
        onPressed: toggle,
      ) : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: AppColors.rubyRed),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: AppColors.rubyRed, width: 2),
      ),
    );
  }
}
