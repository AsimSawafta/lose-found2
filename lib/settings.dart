// settings.dart
import 'package:flutter/material.dart';
import 'package:lose_found/Profile/edit_profile.dart';

class settings extends StatefulWidget {
  const settings({Key? key}) : super(key: key);

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {
  static const Color darkRed = Color(0xFF3D0A05);
  static const Color greyBeige = Color(0xFFA58570);
  static const Color rubyRed = Color(0xFF7F1F0E);
  static const Color silk = Color(0xFFDAC1B1);
  static const Color indianRed = Color(0xFFAC746C);

  bool pushNotifications = true;
  bool emailNotifications = false;

  void _handleLogout() async {
    // sign-out logic here
    Navigator.pushReplacementNamed(context, '/signIn');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: silk.withOpacity(0.98),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        children: [
          Text(
            'Account',
            style: TextStyle(
              color: rubyRed,
              fontWeight: FontWeight.w800,
              fontSize: 22,
              letterSpacing: 0.5,
              shadows: [
                Shadow(
                  color: rubyRed.withOpacity(0.4),
                  offset: const Offset(0, 2),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
           SizedBox(height: 15),
          _buildSettingTile(
            icon: Icons.person_outline,
            title: 'Edit Profile',
            onTap: () {
              Navigator.pushNamed(context, '/editProfile');
            },
          ),

            _buildSettingTile(
            icon: Icons.lock_outline,
            title: 'Change Password',
            onTap: () {},
          ),

          _buildSettingTile(
            icon: Icons.bookmark_border_outlined,
            title: 'Saved Posts',
            onTap: () {},
          ),

          const SizedBox(height: 40),
          Text(
            'General',
            style: TextStyle(
              color: rubyRed,
              fontWeight: FontWeight.w800,
              fontSize: 22,
              letterSpacing: 0.5,
              shadows: [
                Shadow(
                  color: rubyRed.withOpacity(0.4),
                  offset: const Offset(0, 2),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
           SizedBox(height: 15),
          _buildSettingTile(
            icon: Icons.language_outlined,
            title: 'Language',
            onTap: () {},
          ),

          _buildSettingTile(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {},
          ),

          const SizedBox(height: 60),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: indianRed,
                padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                  side: BorderSide(color: rubyRed.withOpacity(0.8), width: 2),
                ),
                elevation: 8,
                shadowColor: indianRed,
              ),
              onPressed: _handleLogout,
              child: const Text(
                'Log Out',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        leading: Icon(icon, color: darkRed, size: 28),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF3D0A05),
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: greyBeige, size: 30),
        onTap: onTap,
      ),
    );
  }
}
