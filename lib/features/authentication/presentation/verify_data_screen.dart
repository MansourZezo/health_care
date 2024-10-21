import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VerifyDataScreen extends StatelessWidget {
  const VerifyDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحقق من بياناتك'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/verify_data.svg',
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 20),
              Text(
                'حسابك تحت المراجعة',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'يرجى الانتظار حتى يقوم المشرف الطبي بالتحقق من بياناتك. سيتم إعلامك بمجرد الموافقة على حسابك.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 20),
                ),
                onPressed: () {
                  // تنقل المستخدم إلى صفحة تسجيل الدخول
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text('العودة لتسجيل الدخول'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
