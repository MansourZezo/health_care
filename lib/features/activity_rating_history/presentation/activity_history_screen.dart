import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_theme.dart'; // افترضت وجود AppTheme لاستيراد لون المستخدم

class ActivityHistoryScreen extends StatefulWidget {
  const ActivityHistoryScreen({super.key});

  @override
  _ActivityHistoryScreenState createState() => _ActivityHistoryScreenState();
}

class _ActivityHistoryScreenState extends State<ActivityHistoryScreen> {
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
                title: const Text('سجل الأنشطة'),
                background: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _WavePainter(color: _userColor), // تعديل لون المستخدم هنا
                      ),
                    ),
                    Positioned(
                      top: 125,
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
                          child: Icon(
                            Icons.history_edu,
                            size: 50,
                            color: _userColor, // تعديل لون المستخدم هنا
                          ),
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
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return _buildActivityCard(
                      context,
                      activityTitle: 'نشاط $index',
                      activityDate: '2024-10-07',
                      volunteerRating: 4.5,
                      volunteerName: 'المتطوع $index',
                      activityDetails: 'تفاصيل حول النشاط وتفاصيل المشاركة...',
                    );
                  },
                  childCount: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(
      BuildContext context, {
        required String activityTitle,
        required String activityDate,
        required double volunteerRating,
        required String volunteerName,
        required String activityDetails,
      }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () {
          // تنفيذ عند الضغط لعرض التفاصيل
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // عرض العنوان وتاريخ النشاط
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    activityTitle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    activityDate,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // عرض اسم المتطوع
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.person, color: _userColor), // تعديل لون الأيقونة
                  const SizedBox(width: 5),
                  Text(
                    volunteerName,
                    style: TextStyle(fontWeight: FontWeight.bold, color: _userColor), // لون النص بناءً على المستخدم
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // عرض التقييم بشكل محاذي
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // جعل التقييم في الوسط
                children: _buildRatingStars(volunteerRating),
              ),
              const SizedBox(height: 10),

              // عرض التفاصيل بشكل أكثر وضوحًا
              Text(
                activityDetails,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildRatingStars(double rating) {
    return List.generate(5, (index) {
      if (index < rating.floor()) {
        return Icon(Icons.star, color: _userColor); // تغيير لون النجوم بناءً على المستخدم
      } else if (index < rating) {
        return Icon(Icons.star_half, color: _userColor); // تغيير لون النجوم النصفية
      } else {
        return Icon(Icons.star_border, color: _userColor); // تغيير لون النجوم الفارغة
      }
    });
  }
}

// رسم التموجات في الجزء العلوي مع لون المستخدم
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
