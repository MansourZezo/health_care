import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/storage_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  Color _userColor = AppTheme.defaultUserColor;
  final StorageService _storageService = StorageService(); // إنشاء كائن من StorageService

  @override
  void initState() {
    super.initState();
    _loadUserColor();
  }

  Future<void> _loadUserColor() async {
    final prefs = await SharedPreferences.getInstance();
    final userRole = prefs.getString('role') ?? '';
    setState(() {
      _userColor = AppTheme.getUserTypeColor(userRole);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 260.0, // زيادة الارتفاع لزيادة المساحة الزرقاء
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 5), // تعديل المسافة بين التموج والنص
              title: const Text('منصور قاسم'), // استبدال العنوان باسم المستخدم
              background: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _WavePainter(color: _userColor),
                    ),
                  ),
                  Positioned(
                    top: 125, // تعديل الموضع لزيادة المساحة الزرقاء
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: SvgPicture.asset(
                            'assets/images/profile_picture.svg',
                            fit: BoxFit.cover,
                            width: 80,
                            height: 80,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.qr_code),
              onPressed: () {
                // الانتقال إلى صفحة QR Code
                //Navigator.pushNamed(context, '/qr_code');
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.pushNamed(context, '/settings');
                },
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  const SizedBox(height: 10), // تعديل المسافات لتقليل الفجوة
                  _buildProfileDetails(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 10), // تقليل المسافة بين الصورة والعناصر الأخرى

        // البريد الإلكتروني
        Text(
          'mansour@example.com', // بريد المستخدم
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 20), // تقليل المسافة بعد البريد الإلكتروني

        // معلومات إضافية (مثل رقم الهاتف أو العنوان)
        ListTile(
          leading: Icon(Icons.phone, color: _userColor),
          title: const Text('رقم الهاتف'),
          subtitle: const Text('+123 456 7890'), // رقم الهاتف
        ),
        ListTile(
          leading: Icon(Icons.location_on, color: _userColor),
          title: const Text('العنوان'),
          subtitle: const Text('Elm Street, Springfield, USA 1234'), // العنوان
        ),
        const SizedBox(height: 20), // تقليل المسافة بين العنوان والقائمة

        // قائمة الخيارات
        _buildOptionList(context),
      ],
    );
  }

  Widget _buildOptionList(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.edit, color: _userColor),
          title: const Text('تعديل الملف الشخصي'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.pushNamed(context, '/edit_profile');
          },
        ),
        ListTile(
          leading: Icon(Icons.health_and_safety, color: _userColor),
          title: const Text('المعلومات الصحية'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.pushNamed(context, '/health_info');
          },
        ),
        ListTile(
          leading: Icon(Icons.history, color: _userColor),
          title: const Text('تاريخ الأنشطة'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.pushNamed(context, '/activity_history');
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('تسجيل الخروج', style: TextStyle(color: Colors.red)),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.red),
          onTap: () {
            _showLogoutDialog(context);
          },
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تأكيد الخروج'),
          content: const Text('هل أنت متأكد أنك تريد تسجيل الخروج؟'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () async {
                await _logout(); // تنفيذ عملية تسجيل الخروج باستخدام StorageService
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('تأكيد'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    await _storageService.clearUserData(); // استخدام StorageService لمسح بيانات المستخدم
    // هنا يمكنك إضافة أي عمليات أخرى تتعلق بتسجيل الخروج إذا لزم الأمر.
  }
}

// رسم التموجات مع لون المستخدم
class _WavePainter extends CustomPainter {
  final Color color;

  _WavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.6)
      ..quadraticBezierTo(
          size.width * 0.25, size.height * 0.75,
          size.width * 0.5, size.height * 0.6)
      ..quadraticBezierTo(
          size.width * 0.75, size.height * 0.45,
          size.width, size.height * 0.6)
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
