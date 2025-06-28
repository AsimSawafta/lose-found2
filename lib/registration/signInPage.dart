import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AppColors {
  static const Color darkRed = Color(0xFF3D0A05);
  static const Color greyBeige = Color(0xFFA58570);
  static const Color rubyRed = Color(0xFF7F1F0E);
  static const Color silk = Color(0xFFDAC1B1);
  static const Color indianRed = Color(0xFFAC746C);
  static const Color background = Color(0xFFF9F6F1);
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _loading = false;

  @override

  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _signIn() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    try {

       await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
      );

      Navigator.pushReplacementNamed(context, '/home');
    }
    on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign-in failed: Check your Email or Password'),
          backgroundColor: AppColors.rubyRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding:  EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.rubyRed,
                      blurRadius: 18,
                      offset:  Offset(0, 8),
                    ),
                  ],
                  image:  DecorationImage(
                    image: AssetImage('assets/img.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

               SizedBox(height: 28),


              Text(
                'Found & Lose',
                style: TextStyle(
                  color: AppColors.darkRed,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(
                      color: AppColors.rubyRed,
                      offset:  Offset(0, 2),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),

               SizedBox(height: 10),


              Text(
                'Welcome Back!',
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
                      style: TextStyle(color: AppColors.darkRed, fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Email',
                        hintStyle: TextStyle(color: AppColors.greyBeige, fontWeight: FontWeight.w500),
                        prefixIcon: Icon(Icons.email_outlined, color: AppColors.rubyRed),
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
                      ),
                      validator: (val) => (val == null || val.isEmpty) ? 'Email is required' : null,
                    ),

                     SizedBox(height: 24),


                    TextFormField(
                      controller: _passwordCtrl,
                      obscureText: _obscurePassword,
                      style: TextStyle(color: AppColors.darkRed, fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Password',
                        hintStyle: TextStyle(color: AppColors.greyBeige, fontWeight: FontWeight.w500),
                        prefixIcon: Icon(Icons.lock_outline, color: AppColors.rubyRed),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: AppColors.rubyRed,
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
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
                      ),
                      validator: (val) => (val == null || val.isEmpty ) ? 'Password is required' : null,
                    ),
                  ],
                ),
              ),

               SizedBox(height: 40),


              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _loading ? null : _signIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.rubyRed,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 8,
                    shadowColor: AppColors.rubyRed,
                  ),
                  child: _loading
                      ?  CircularProgressIndicator(color: Colors.white)
                      :  Text(
                    'Sign In',
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
                    "Don't have an account? ",
                    style: TextStyle(color: AppColors.darkRed, fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/signUp'),
                    child: Text(
                      'Sign Up',
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
}
