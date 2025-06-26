import 'package:flutter/material.dart';
import 'contact-support.dart';
import 'account-status.dart';
import 'report_problem.dart';
//import 'support_inbox.dart';

// هاي الصفحة الرئيسية لقسم "المساعدة والدعم"
class HelpnSupport extends StatelessWidget {
  const HelpnSupport({super.key});

  // تعريف الألوان المستخدمة
  static const Color darkRed = Color(0xFF3D0A05);
  static const Color greyBeige = Color(0xFFA58570);
  static const Color rubyRed = Color(0xFF7F1F0E);
  static const Color silk = Color(0xFFDAC1B1);
  static const Color indianRed = Color(0xFFAC746C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: silk.withOpacity(0.98), // لون الخلفية
      appBar: AppBar(
        backgroundColor: rubyRed, // لون الشريط العلوي
        leading: IconButton(
          icon:  Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        iconTheme:  IconThemeData(color: Colors.white),
        title: Text(
          'Help & Support', // عنوان الصفحة
          style: TextStyle(
            color: silk,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // القائمة اللي فيها خيارات الدعم
      body: ListView(
        children: [

          _buildHelpItem(Icons.help_outline, 'Help Center', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) =>  ContactSupport()),
            );
          }),


          _buildHelpItem(Icons.verified_user_outlined, 'Account Status', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) =>  AccountStatusPage()),
            );
          }),





          _buildHelpItem(Icons.error_outline, 'Report a problem', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) =>  ReportProblemPage()),
            );
          }),
        ],
      ),
    );
  }

  // دالة بتبني شكل العنصر الواحد في القائمة (زي بطاقة فيها أيقونة ونص)
  Widget _buildHelpItem(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin:  EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95), // لون الخلفية
        borderRadius: BorderRadius.circular(14), // تدوير الزوايا
        boxShadow: [
          BoxShadow(
            color: indianRed.withOpacity(0.15), // ظل خفيف
            blurRadius: 6,
            offset:  Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:  EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: CircleAvatar(
          backgroundColor: greyBeige.withOpacity(0.2), // دائرة خلف الأيقونة
          radius: 22,
          child: Icon(icon, color: darkRed), // الأيقونة نفسها
        ),
        title: Text(
          title,
          style: TextStyle(
            color: darkRed,
            fontSize: 16.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: greyBeige), //
        onTap: onTap,
      ),
    );
  }
}
