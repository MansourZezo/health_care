import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_theme.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Color _userColor = Colors.blueAccent; // اللون الافتراضي بناءً على نوع المستخدم

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserColor(); // تحميل لون المستخدم بناءً على الدور
  }

  Future<void> _loadUserColor() async {
    final prefs = await SharedPreferences.getInstance();
    final userRole = prefs.getString('role') ?? ''; // الحصول على دور المستخدم من SharedPreferences
    setState(() {
      _userColor = AppTheme.getUserTypeColor(userRole); // تحميل اللون بناءً على دور المستخدم
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 78),
              title: const Text('التقارير'),
              background: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _WavePainter(color: _userColor),
                    ),
                  ),
                  Positioned(
                    top: 65,
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
                        child: Icon(Icons.receipt_long,
                            size: 50, color: _userColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: TabBar(
                controller: _tabController,
                labelColor: _userColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: _userColor,
                indicatorWeight: 3.0,
                tabs: const [
                  Tab(icon: Icon(Icons.assessment), text: 'تقارير الأنشطة'),
                  Tab(icon: Icon(Icons.health_and_safety), text: 'تقارير الصحة'),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildActivityReports(),
                _buildHealthReports(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityReports() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5, // عدد التقارير (مثال)
      itemBuilder: (context, index) {
        return Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.directions_run, color: _userColor),
                    const SizedBox(width: 8),
                    Text(
                      'النشاط ${index + 1}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'المتطوع: أحمد محمد\nالتقييم: 4.5/5\nملاحظات: أداء جيد وتعاون ممتاز',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHealthReports() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5, // عدد التقارير (مثال)
      itemBuilder: (context, index) {
        return Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.local_hospital, color: _userColor),
                    const SizedBox(width: 8),
                    Text(
                      'التقرير الصحي ${index + 1}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'المستفيد: محمد علي\nضغط الدم: 120/80\nمستوى السكر: 90 mg/dL\nالوزن: 75 kg',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// رسم التموجات في الخلفية
class _WavePainter extends CustomPainter {
  final Color color;

  _WavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.35)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.45,
          size.width * 0.5, size.height * 0.35)
      ..quadraticBezierTo(
          size.width * 0.75, size.height * 0.25, size.width, size.height * 0.35)
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
