import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lose_found/Posts/savedPosts.dart';
import 'package:lose_found/Profile/edit_profile.dart';

import 'firebase_options.dart';
import 'home.dart';
import 'registration/signInPage.dart';
import 'registration/signUpPage.dart';
import 'AnotherUsersProfiles/UsersProfile.dart';
import 'Setting/change_pswd.dart';
import 'Setting/help_n_support.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Found & Lose',
      debugShowCheckedModeBanner: false,
      initialRoute: '/signIn',
      routes: {
        '/signIn': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        '/home': (context) => Home(),
        '/editProfile':(context)=>EditProfileScreen(),
        '/savedPosts':(context)=>SavedPostsScreen(),
        '/changePassword': (context) =>  ChangePassword(),
        '/helpSupport': (context) =>  HelpnSupport(),

      },
    );
  }
}
