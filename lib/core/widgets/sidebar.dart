import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/theme/app_theme.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  CustomDrawerState createState() => CustomDrawerState();
}

class CustomDrawerState extends State<CustomDrawer> {
  final StorageService _storageService = StorageService(); // إنشاء كائن من StorageService

  Future<Color> _getUserColor() async {
    final prefs = await SharedPreferences.getInstance();
    final userRole = prefs.getString('role') ?? '';
    return AppTheme.getUserTypeColor(userRole);
  }

  Future<void> _logout() async {
    await _storageService.clearUserData(); // استخدام StorageService لمسح بيانات المستخدم
    Navigator.pushReplacementNamed(context, '/login'); // إعادة توجيه المستخدم لصفحة تسجيل الدخول
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Color>(
      future: _getUserColor(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // أثناء انتظار تحميل اللون، يمكنك إظهار لون افتراضي أو شاشة تحميل
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // في حالة وجود خطأ
          return Drawer(
            child: Center(
              child: Text('حدث خطأ في تحميل اللون'),
            ),
          );
        } else {
          // تم تحميل اللون بنجاح
          final userColor = snapshot.data ?? AppTheme.defaultUserColor;

          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: userColor, // اللون المخصص للمستخدم
                  ),
                  child: const Text(
                    'القائمة الجانبية',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('الرئيسية'),
                  onTap: () {
                    Navigator.pushNamed(context, '/home');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('الإعدادات'),
                  onTap: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('الإشعارات'),
                  onTap: () {
                    Navigator.pushNamed(context, '/notifications');
                  },
                ),
                const Divider(), // فاصل بين الأقسام
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('حول رعاية'),
                  onTap: () {
                    Navigator.pushNamed(context, '/about');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.question_answer),
                  title: const Text('الأسئلة الشائعة'),
                  onTap: () {
                    Navigator.pushNamed(context, '/faq');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.favorite),
                  title: const Text('المفضلة'),
                  onTap: () {
                    Navigator.pushNamed(context, '/favorites');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.star),
                  title: const Text('قيم التطبيق'),
                  onTap: () {
                    Navigator.pushNamed(context, '/rate');
                  },
                ),
                const Divider(), // فاصل بين الأقسام
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('تسجيل الخروج', style: TextStyle(color: Colors.red)),
                  onTap: () async {
                    await _logout(); // تنفيذ عملية تسجيل الخروج
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
