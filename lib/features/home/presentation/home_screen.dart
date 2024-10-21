import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_theme.dart';
import '/core/widgets/sidebar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
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
        drawer: const CustomDrawer(),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 250.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                titlePadding: const EdgeInsets.only(bottom: 10),
                title: const Text('مرحبا منصور'),
                background: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _WavePainter(color: _userColor),
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
                          child: Icon(Icons.home, size: 50, color: _userColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () {
                    Navigator.pushNamed(context, '/notifications');
                  },
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        _buildActivityCard(
                          context,
                          icon: Icons.volunteer_activism,
                          title: 'أنشطة التطوع',
                          description: 'اطلع على فرص التطوع القريبة.',
                          userColor: _userColor,
                        ),
                        const SizedBox(height: 10),
                        _buildActivityCard(
                          context,
                          icon: Icons.schedule,
                          title: 'التذكيرات المجدولة',
                          description: 'مواعيدك وتذكيراتك القادمة.',
                          userColor: _userColor,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 200,
                          child: PageView(
                            children: <Widget>[
                              Image.asset('assets/images/photo_gallery_1.jpg'),
                              Image.asset('assets/images/photo_gallery_2.jpg'),
                              Image.asset('assets/images/photo_gallery_3.jpg'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildHealthInfoSection(userColor: _userColor),
                        const SizedBox(height: 20),
                        _buildHealthTipsCarousel(),
                      ],
                    );
                  },
                  childCount: 1,
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'homeActionButton',
          backgroundColor: _userColor,
          onPressed: () {
            _showEmergencyBottomSheet(context);
          },
          child: const Icon(Icons.phone_in_talk),
        ),
      ),
    );
  }

  Widget _buildActivityCard(BuildContext context,
      {required IconData icon,
        required String title,
        required String description,
        required Color userColor}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: ListTile(
        leading: Icon(icon, size: 40, color: userColor), // تغيير لون الأيقونة
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // التنقل إلى صفحة التفاصيل
        },
      ),
    );
  }

  Widget _buildHealthTipsCarousel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'نصائح صحية',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 150,
          child: PageView(
            children: <Widget>[
              _buildHealthTipCard(
                icon: Icons.local_drink,
                title: 'اشرب الكثير من الماء',
                description: 'شرب الماء يعزز الصحة ويحسن وظائف الجسم.',
                userColor: _userColor, // تمرير لون المستخدم
              ),
              _buildHealthTipCard(
                icon: Icons.fitness_center,
                title: 'مارس التمارين الرياضية',
                description: 'الحفاظ على نشاطك البدني يعزز مناعتك وصحتك.',
                userColor: _userColor, // تمرير لون المستخدم
              ),
              _buildHealthTipCard(
                icon: Icons.food_bank,
                title: 'تناول الغذاء الصحي',
                description: 'تناول الفواكه والخضراوات بانتظام.',
                userColor: _userColor, // تمرير لون المستخدم
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildHealthTipCard({
    required IconData icon,
    required String title,
    required String description,
    required Color userColor, // إضافة لون المستخدم كـ parameter
  }) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        child: ListTile(
          leading: Icon(icon, size: 40, color: userColor), // استخدام لون المستخدم بدلاً من اللون الثابت
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(description),
        ),
      ),
    );
  }


  Widget _buildHealthInfoSection({required Color userColor}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.monitor_heart, size: 50, color: userColor),
              title: const Text('المعلومات الصحية',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text(
                  'ضغط الدم: 120/80 mmHg\nمستوى السكر: 90 mg/dL\nمعدل ضربات القلب: 72 bpm'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // الانتقال إلى صفحة التفاصيل الصحية
              },
            ),
            const SizedBox(height: 10),
            const Text(
              'مزيد من المعلومات الصحية هنا...',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  void _showEmergencyBottomSheet(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'جهات الاتصال الطارئة',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  backgroundColor: Colors.redAccent,
                ),
                icon: const Icon(Icons.local_hospital, size: 28),
                label: const Text('اتصال بالمشرف الطبي',
                    style: TextStyle(fontSize: 18)),
                onPressed: () {
                  // الاتصال بالمشرف الطبي
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  backgroundColor: Colors.orangeAccent,
                ),
                icon: const Icon(Icons.family_restroom, size: 28),
                label: const Text('اتصال بمقدم الرعاية',
                    style: TextStyle(fontSize: 18)),
                onPressed: () {
                  // الاتصال بمقدم الرعاية
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  backgroundColor: Colors.blueAccent,
                ),
                icon: const Icon(Icons.local_police, size: 28),
                label: const Text('اتصال بخدمات الطوارئ',
                    style: TextStyle(fontSize: 18)),
                onPressed: () {
                  // الاتصال بخدمات الطوارئ
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

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
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.75,
          size.width * 0.5, size.height * 0.6)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.45,
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
