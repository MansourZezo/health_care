import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_theme.dart';

class PerformanceStatisticsScreen extends StatefulWidget {
  const PerformanceStatisticsScreen({super.key});

  @override
  _PerformanceStatisticsScreenState createState() => _PerformanceStatisticsScreenState();
}

class _PerformanceStatisticsScreenState extends State<PerformanceStatisticsScreen> {
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
                title: const Text('إحصائيات الأداء'),
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
                          child: Icon(Icons.health_and_safety, size: 50, color: _userColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(bottom: 30), // أضف Padding أسفل القائمة
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    const SizedBox(height: 20),

                    // البطاقات الثلاثة المتحركة (Carousel)
                    _buildSwipeablePerformanceCards(),

                    const SizedBox(height: 30),

                    // مخطط الأنشطة المكتملة
                    _buildChartSection(
                      context,
                      title: 'الأنشطة المكتملة بمرور الوقت',
                      chart: LineChart(_buildActivityLineChart()),
                    ),
                    const SizedBox(height: 30),

                    // مخطط متوسط التقييمات (مخطط أعمدة)
                    _buildChartSection(
                      context,
                      title: 'متوسط التقييمات بمرور الوقت',
                      chart: BarChart(_buildRatingsBarChart()),
                    ),
                    const SizedBox(height: 30),

                    // مخطط توزيع الأنشطة
                    _buildChartSection(
                      context,
                      title: 'توزيع الأنشطة حسب النوع',
                      chart: PieChart(_buildActivityDistributionChart()),
                    ),
                    const SizedBox(height: 30),

                    // نصائح تحسين الأداء
                    _buildSwipeablePerformanceTips(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // رسم البطاقات الثلاثة المتحركة
  Widget _buildSwipeablePerformanceCards() {
    return SizedBox(
      height: 150,
      child: PageView(
        controller: PageController(viewportFraction: 0.8),
        children: [
          _buildSingleCard('إجمالي الأنشطة', '25', Icons.task_alt, _userColor),
          _buildSingleCard('متوسط التقييمات', '4.5', Icons.star_rate, _userColor),
          _buildSingleCard('متوسط المدة', '30 دقيقة', Icons.timer, _userColor),
        ],
      ),
    );
  }

  // بناء بطاقة فردية
  Widget _buildSingleCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  // نصائح الأداء المتحركة
  Widget _buildSwipeablePerformanceTips() {
    return SizedBox(
      height: 150,
      child: PageView(
        controller: PageController(viewportFraction: 0.8),
        children: [
          _buildSingleTipCard('استجب بسرعة للطلبات لتحسين تقييمك.'),
          _buildSingleTipCard('شارك في مجموعة متنوعة من الأنشطة لتوسيع مهاراتك.'),
          _buildSingleTipCard('استهدف الأنشطة التي تتطلب مستوى أعلى من التفاعل للحصول على تقييمات أفضل.'),
        ],
      ),
    );
  }

  // بناء بطاقة نصائح فردية
  Widget _buildSingleTipCard(String tip) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            tip,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  // رسم المخططات
  Widget _buildChartSection(BuildContext context, {required String title, required Widget chart}) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: chart,
            ),
          ],
        ),
      ),
    );
  }

  // رسم مخطط الأنشطة المكتملة
  LineChartData _buildActivityLineChart() {
    return LineChartData(
      gridData: const FlGridData(show: true),
      titlesData: const FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true),
        ),
      ),
      borderData: FlBorderData(show: true),
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 1),
            FlSpot(1, 3),
            FlSpot(2, 2),
            FlSpot(3, 5),
            FlSpot(4, 3),
            FlSpot(5, 6),
          ],
          isCurved: true,
          color: Colors.blue, // استخدام اللون الافتراضي للمخططات
          barWidth: 4,
          dotData: const FlDotData(show: false),
        ),
      ],
    );
  }

  // رسم مخطط متوسط التقييمات (مخطط أعمدة)
  BarChartData _buildRatingsBarChart() {
    return BarChartData(
      gridData: const FlGridData(show: true),
      titlesData: const FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true),
        ),
      ),
      borderData: FlBorderData(show: true),
      barGroups: [
        BarChartGroupData(
          x: 0,
          barRods: [BarChartRodData(toY: 4, color: Colors.green)],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [BarChartRodData(toY: 3.5, color: Colors.green)],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [BarChartRodData(toY: 4.5, color: Colors.green)],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [BarChartRodData(toY: 5, color: Colors.green)],
        ),
        BarChartGroupData(
          x: 4,
          barRods: [BarChartRodData(toY: 4.2, color: Colors.green)],
        ),
        BarChartGroupData(
          x: 5,
          barRods: [BarChartRodData(toY: 4.8, color: Colors.green)],
        ),
      ],
    );
  }

  // رسم مخطط توزيع الأنشطة
  PieChartData _buildActivityDistributionChart() {
    return PieChartData(
      sections: [
        PieChartSectionData(
          color: Colors.blue, // استخدام اللون الافتراضي للمخططات
          value: 40,
          title: 'طبي',
          radius: 60,
        ),
        PieChartSectionData(
          color: Colors.orange,
          value: 30,
          title: 'رياضة',
          radius: 50,
        ),
        PieChartSectionData(
          color: Colors.purple,
          value: 20,
          title: 'ترفيه',
          radius: 50,
        ),
        PieChartSectionData(
          color: Colors.red,
          value: 10,
          title: 'آخر',
          radius: 40,
        ),
      ],
    );
  }
}

// رسم التموجات
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
