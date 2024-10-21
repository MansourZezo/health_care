import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ConfirmationScreen extends StatelessWidget {
  final String userType;

  const ConfirmationScreen({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تأكيد البيانات'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView( // تفعيل التمرير
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/confirmation_success.svg',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 20),
                Text(
                  'تم إرسال بياناتك بنجاح!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  'الرجاء الانتظار حتى يتم تأكيد بياناتك. سيتم إبلاغك عند إتمام المراجعة.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                // في حالة المستخدم "مستفيد" أو "مساعد" نضيف حقل لرقم الهاتف أو الإيميل المرتبط
                if (userType == 'Beneficiary' || userType == 'Caregiver') ...[
                  const Text(
                    'أدخل رقم الهاتف أو البريد الإلكتروني للشخص المرتبط بك:',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'البريد الإلكتروني أو رقم الهاتف',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      // عند الضغط يتم إرسال البريد الإلكتروني أو رقم الهاتف
                      // هنا يمكنك إضافة الكود لإرسال البيانات
                    },
                    child: const Text('إرسال'),
                  ),
                ] else ...[
                  // إذا لم يكن المستخدم مستفيدًا أو مساعدًا (زر تسجيل الدخول فقط)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      // عند الضغط يتم توجيه المستخدم لصفحة تسجيل الدخول
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text('العودة لتسجيل الدخول'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
