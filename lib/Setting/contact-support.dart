import 'package:flutter/material.dart';

// هاي صفحة (ContactSupport) بتعرض معلومات التواصل مع  الجامعة
class ContactSupport extends StatelessWidget {
  const ContactSupport({super.key});

  // تعريف ألوان ثابتة لاستخدامها في التصميم
  static const Color darkRed = Color(0xFF3D0A05);
  static const Color greyBeige = Color(0xFFA58570);
  static const Color rubyRed = Color(0xFF7F1F0E);
  static const Color silk = Color(0xFFDAC1B1);
  static const Color indianRed = Color(0xFFAC746C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: silk.withOpacity(0.98), // خلفية الصفحة بلون حريري شبه شفاف
      appBar: AppBar(
        backgroundColor: rubyRed, // لون التطبيق في الأعلى
        elevation: 0, // بدون ظل
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: darkRed), // زر الرجوع
          onPressed: () => Navigator.pop(context), // يرجع للصفحة السابقة
        ),
        title: const Text(
          'Lost & Found Support',
          style: TextStyle(color: silk, fontWeight: FontWeight.bold), // العنوان بلون حريري
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0), // مسافة حول المحتوى
        child: Container(
          padding: const EdgeInsets.all(20), // مسافة داخل الكونتينر
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.97), // لون خلفية الكرت الأبيض
            borderRadius: BorderRadius.circular(16), // الزوايا مدوّرة
            boxShadow: [
              BoxShadow(
                color: indianRed.withOpacity(0.1), // ظل خفيف بلون أحمر هندي
                blurRadius: 6,
                offset: const Offset(0, 3), // اتجاه الظل
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // المحاذاة من اليسار
            children: [
              // عنوان مساعد
              const Text(
                "Need help with Lost & Found?",
                style: TextStyle(
                  fontSize: 18,
                  color: darkRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8), // فراغ صغير

              // شرح أو تعليمات
              const Text(
                "If you have any issues, questions, or need assistance, please contact our university support team:",
                style: TextStyle(fontSize: 15, color: Colors.black87),
              ),
              const SizedBox(height: 24), // فراغ كبير شوي

              // رقم الهاتف
              Row(
                children: const [
                  Icon(Icons.phone, color: darkRed), // أيقونة الهاتف
                  SizedBox(width: 12),
                  Text(
                    "+970 592 334 789", // رقم التواصل
                    style: TextStyle(fontSize: 16, color: darkRed),
                  ),
                ],
              ),
              const SizedBox(height: 16), // فراغ بين الصفوف

              // البريد الإلكتروني
              Row(
                children: const [
                  Icon(Icons.email_outlined, color: darkRed),
                  SizedBox(width: 12),
                  Text(
                    "lostfound@aaup.edu",
                    style: TextStyle(fontSize: 16, color: darkRed),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // أوقات الدوام
              Row(
                children: const [
                  Icon(Icons.access_time, color: darkRed),
                  SizedBox(width: 12),
                  Text(
                    "Sun – Thu, 8:30 AM – 4:00 PM", // أيام وساعات العمل
                    style: TextStyle(fontSize: 16, color: darkRed),
                  ),
                ],
              ),

              const SizedBox(height: 28),
              const Divider(thickness: 1, color: greyBeige), // خط فاصل
              const SizedBox(height: 12),

              // موقع المكتب
              Row(
                children: const [
                  Icon(Icons.location_on_outlined, color: darkRed),
                  SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      "Office: Student Affairs, 1st Floor, Main Building - AAUP Campus", // العنوان
                      style: TextStyle(fontSize: 15.5, color: darkRed),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
