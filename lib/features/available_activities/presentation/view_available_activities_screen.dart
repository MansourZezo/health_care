import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_theme.dart';

class ViewAvailableActivitiesScreen extends StatefulWidget {
  const ViewAvailableActivitiesScreen({super.key});

  @override
  _ViewAvailableActivitiesScreenState createState() => _ViewAvailableActivitiesScreenState();
}

class _ViewAvailableActivitiesScreenState extends State<ViewAvailableActivitiesScreen> {
  Color _userColor = AppTheme.defaultUserColor;

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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 250.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                titlePadding: const EdgeInsets.only(bottom: 20),
                title: const Text('النشاطات المتاحة'),
                background: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _WavePainter(color: _userColor),
                      ),
                    ),
                    Positioned(
                      top: 125, // تعديل الارتفاع لجعل الأيقونة بين الموجة والبيانات
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          width: 75,
                          height: 75,
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
                          child: Icon(Icons.assignment, size: 50, color: _userColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    _buildActivityCard(context, 'موعد طبي', 'د. أحمد', '2:00 PM', Icons.local_hospital, _userColor),
                    _buildActivityCard(context, 'مساعدة في التمارين', 'محمد علي', '3:30 PM', Icons.fitness_center, _userColor),
                    _buildActivityCard(context, 'التسوق', 'مريم يوسف', '4:00 PM', Icons.shopping_cart, _userColor),
                    _buildActivityCard(context, 'المشي في الحديقة', 'أحمد ناصر', '5:00 PM', Icons.directions_walk, _userColor),
                    _buildActivityCard(context, 'مرافقة لحضور اجتماع', 'أسماء خالد', '6:00 PM', Icons.group, _userColor),
                    _buildActivityCard(context, 'مساعدة في الأعمال المنزلية', 'سارة علي', '7:00 PM', Icons.home, _userColor),
                    _buildActivityCard(context, 'زيارة الطبيب', 'د. مروان', '8:30 PM', Icons.medical_services, _userColor),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // تصميم البطاقة الخاصة بكل نشاط
  Widget _buildActivityCard(BuildContext context, String title, String beneficiary, String time, IconData icon, Color userColor) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10), // إضافة مسافة بين البطاقات
      child: InkWell(
        onTap: () {
          // هنا يمكن إضافة عمل عند الضغط على البطاقة (مثل عرض تفاصيل النشاط)
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // أيقونة النشاط
              Icon(icon, size: 40, color: userColor),
              const SizedBox(width: 20),
              // تفاصيل النشاط
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // عنوان النشاط
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    // اسم المستفيد
                    Text('المستفيد: $beneficiary'),
                    const SizedBox(height: 5),
                    // وقت النشاط
                    Text('الوقت: $time'),
                  ],
                ),
              ),
              // أزرار الموافقة والتجاهل
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check_circle, color: Colors.green),
                    onPressed: () {
                      // إجراء للموافقة على النشاط
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.grey), // استبدال أيقونة X بأيقونة التجاهل
                    onPressed: () {
                      // إجراء لتجاهل النشاط
                    },
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

// رسم التموجات في الجزء العلوي
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
        size.width * 0.5, size.height * 0.6,
      )
      ..quadraticBezierTo(
        size.width * 0.75, size.height * 0.45,
        size.width, size.height * 0.6,
      )
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
