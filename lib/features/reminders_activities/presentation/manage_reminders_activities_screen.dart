import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_theme.dart';

class ManageRemindersActivitiesScreen extends StatefulWidget {
  const ManageRemindersActivitiesScreen({super.key});

  @override
  ManageRemindersActivitiesScreenState createState() =>
      ManageRemindersActivitiesScreenState();
}

class ManageRemindersActivitiesScreenState
    extends State<ManageRemindersActivitiesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Color _userColor = Colors.blueAccent; // اللون الافتراضي

  final List<Map<String, String>> activities = [
    {"title": "المشي الصباحي", "details": "قم بالمشي لمدة 30 دقيقة في الحديقة"},
    {
      "title": "جلسة يوغا",
      "details": "انضم إلى جلسة اليوغا المجتمعية الساعة 5 مساءً"
    },
    {"title": "التسوق", "details": "ساعد في شراء البقالة الساعة 4 مساءً"},
    {"title": "مساعدة في التنظيف", "details": "قم بالمساعدة في مهام التنظيف"},
    {"title": "القراءة", "details": "اقرأ كتاب لمدة ساعة"},
    {"title": "طبخ العشاء", "details": "قم بإعداد العشاء الساعة 6 مساءً"},
    {"title": "مشي مسائي", "details": "قم بالمشي في المساء لمدة 20 دقيقة"},
    {"title": "التسوق الأسبوعي", "details": "قم بشراء المستلزمات الأسبوعية"},
    {
      "title": "جلسة تمرين",
      "details": "حضور جلسة تمرين رياضية في الساعة 3 مساءً"
    },
    {"title": "لقاء العائلة", "details": "لقاء العائلة مساءً الساعة 8 مساءً"},
    {
      "title": "مراجعة المستندات",
      "details": "راجع مستندات العمل الساعة 2 مساءً"
    },
    {
      "title": "العمل على المشروع",
      "details": "تابع العمل على المشروع الساعة 4 مساءً"
    },
  ];

  final List<Map<String, String>> reminders = [
    {
      "title": "موعد الطبيب",
      "details": "قم بزيارة د. سميث الساعة 10:00 صباحًا"
    },
    {
      "title": "تذكير بالدواء",
      "details": "تناول دواء ضغط الدم الساعة 8 صباحًا"
    },
    {
      "title": "تذكير بالتمارين",
      "details": "تمارين اليوغا الصباحية الساعة 7 صباحًا"
    },
    {"title": "تذكير بالشرب", "details": "اشرب كوب ماء كل ساعة"},
    {
      "title": "تذكير بالمكملات الغذائية",
      "details": "تناول مكملات الفيتامينات الساعة 12 ظهراً"
    },
    {"title": "تذكير بالراحة", "details": "خذ استراحة من العمل لمدة 10 دقائق"},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserColor(); // تحميل لون المستخدم
  }

  Future<void> _loadUserColor() async {
    final prefs = await SharedPreferences.getInstance();
    final userRole = prefs.getString('role') ?? '';
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: 250.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                titlePadding: const EdgeInsets.only(bottom: 78), // رفع العنوان
                title: const Text('إدارة التذكيرات والأنشطة'),
                background: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _WavePainter(color: _userColor), // تمرير لون المستخدم
                      ),
                    ),
                    Positioned(
                      top: 65, // رفع الأيقونة لمركز التموج
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
                          child: Icon(Icons.alarm, size: 50, color: _userColor), // تغيير لون الأيقونة بناءً على المستخدم
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
                  labelColor: _userColor, // لون التبويبة المختارة
                  unselectedLabelColor: Colors.grey, // لون التبويبات غير المختارة
                  indicatorColor: _userColor, // تغيير لون المؤشر بناءً على المستخدم
                  indicatorWeight: 3.0,
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.group),
                      text: 'الأنشطة',
                    ),
                    Tab(
                      icon: Icon(Icons.notifications),
                      text: 'التذكيرات',
                    ),
                  ],
                ),
              ),
            ),
            SliverFillRemaining(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildActivitiesTab(),
                  _buildRemindersTab(),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'manageActivitiesActionButton',
          onPressed: () {
            Navigator.pushNamed(context, '/add_reminder_or_activity');
          },
          backgroundColor: _userColor, // تغيير لون الزر بناءً على المستخدم
          child: const Icon(Icons.add, size: 30),
        ),
      ),
    );
  }

  Widget _buildActivitiesTab() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: activities.length,
        itemBuilder: (context, index) {
          return _buildCard(activities[index], "Activity", _userColor); // تمرير لون المستخدم
        },
      ),
    );
  }

  Widget _buildRemindersTab() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: reminders.length,
        itemBuilder: (context, index) {
          return _buildCard(reminders[index], "Reminder", _userColor); // تمرير لون المستخدم
        },
      ),
    );
  }

  Widget _buildCard(Map<String, String> item, String type, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(
          type == "Reminder" ? Icons.alarm : Icons.local_activity,
          size: 40,
          color: color, // استخدام لون المستخدم
        ),
        title: Text(
          item["title"] ?? "",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(item["details"] ?? ""),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.pushNamed(context, '/activity_reminder_details');
        },
      ),
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
      ..color = color // استخدام اللون الممرر
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
