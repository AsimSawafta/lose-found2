import 'package:flutter/material.dart';

// صفحة للإبلاغ عن مشكلة (مشكلة في التطبيق مثلاً)
class ReportProblemPage extends StatefulWidget {
  const ReportProblemPage({super.key});

  @override
  State<ReportProblemPage> createState() => _ReportProblemPageState();
}

class _ReportProblemPageState extends State<ReportProblemPage> {
  // ألوان خاصة للتصميم
  static const Color darkRed = Color(0xFF3D0A05);
  static const Color silk = Color(0xFFDAC1B1);
  static const Color rubyRed = Color(0xFF7F1F0E);

  // متحكم بنص المشكلة
  final TextEditingController _problemController = TextEditingController();

  // النوع الافتراضي للمشكلة
  String _selectedType = 'App Crash';

  // الأنواع المتاحة للمشاكل
  final List<String> _problemTypes = [
    'App Crash',
    'Login Issue',
    'Lost Item not listed',
    'Wrong Information',
    'Other',
  ];

  // دالة الإرسال لما المستخدم يضغط زر "Submit"
  void _submitProblem() {
    final problemText = _problemController.text.trim(); // حذف الفراغات من البداية والنهاية
    if (problemText.isEmpty) {
      // إذا المستخدم ما كتب إشي، بنعرضله رسالة
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text("Please describe your problem.")),
      );
      return;
    }


    ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text("Your report has been submitted. Thank you!")),
    );

    // بعد الإرسال، نفرغ الحقول ونرجع الاختيار لأول خيار
    _problemController.clear();
    setState(() => _selectedType = _problemTypes[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: silk.withOpacity(0.98),
      appBar: AppBar(
        iconTheme:  IconThemeData(color: Colors.white),
        leading: IconButton(
          icon:  Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: rubyRed,
        title:  Text('Report a Problem', style: TextStyle(color: silk, fontWeight: FontWeight.bold)),

      ),
      body: Padding(
        padding:  EdgeInsets.all(24.0),
        child: Container(
          padding:  EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

               Text(
                "Select Problem Type:",
                style: TextStyle(fontSize: 16, color: darkRed),
              ),
               SizedBox(height: 8),

              // قائمة منسدلة لاختيار نوع المشكلة
              DropdownButton<String>(
                value: _selectedType,
                isExpanded: true,
                items: _problemTypes
                    .map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type),
                ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _selectedType = value);
                },
              ),
               SizedBox(height: 16),


               Text(
                "Describe the problem:",
                style: TextStyle(fontSize: 16, color: darkRed),
              ),
               SizedBox(height: 8),


              TextField(
                controller: _problemController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Write here...",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  fillColor: silk.withOpacity(0.2),
                  filled: true,
                ),
              ),
               SizedBox(height: 20),


              Center(
                child: ElevatedButton.icon(
                  onPressed: _submitProblem,
                  icon:  Icon(Icons.send),
                  label:  Text("Submit"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: rubyRed,
                    foregroundColor: Colors.white,
                    padding:  EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
