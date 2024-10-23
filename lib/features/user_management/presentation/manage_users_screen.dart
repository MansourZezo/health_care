import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_theme.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  ManageUsersScreenState createState() => ManageUsersScreenState();
}

class ManageUsersScreenState extends State<ManageUsersScreen>
    with SingleTickerProviderStateMixin {
  String? selectedUser; // المستخدم المختار
  late TabController _tabController;
  Color _userColor = Colors.blueAccent; // اللون الافتراضي للمستخدم

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        body: Stack(
          children: [
            CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  expandedHeight: 250.0,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    titlePadding: const EdgeInsets.only(bottom: 78), // رفع العنوان
                    title: const Text('إدارة المستخدمين'),
                    background: Stack(
                      children: [
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _WavePainter(color: _userColor), // التموجات بناءً على لون المستخدم
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
                              child: Icon(Icons.group, size: 50, color: _userColor), // أيقونة المستخدم
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
                        Tab(icon: Icon(Icons.person), text: 'المستفيدين'),
                        Tab(icon: Icon(Icons.family_restroom), text: 'المساعدين'),
                        Tab(icon: Icon(Icons.volunteer_activism), text: 'المتطوعين'),
                      ],
                    ),
                  ),
                ),
                SliverFillRemaining(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildUserList(context, 'Beneficiaries'),
                      _buildUserList(context, 'Assistants'),
                      _buildUserList(context, 'Volunteers'),
                    ],
                  ),
                ),
              ],
            ),
            // البطاقة المثبتة التي تعرض فوق القائمة
            if (selectedUser != null) _buildUserCard(context),
          ],
        ),
      ),
    );
  }

  // قائمة المستخدمين لكل تصنيف
  Widget _buildUserList(BuildContext context, String userType) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 200), // لإعطاء مساحة للبطاقة
      itemCount: 10, // استبدل بعدد المستخدمين الفعلي لكل فئة
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: Icon(Icons.person, size: 40, color: _userColor), // أيقونة بجانب المستخدم
            title: Text('$userType $index'),
            subtitle: Text('تفاصيل $userType'),
            onTap: () {
              setState(() {
                selectedUser = '$userType $index'; // تعيين المستخدم المختار
              });
            },
          ),
        );
      },
    );
  }

  // بطاقة عرض معلومات المستخدم المثبتة في الأعلى
  Widget _buildUserCard(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'تفاصيل $selectedUser',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text('الحالة الصحية: الحالة جيدة'),
              const SizedBox(height: 10),
              Text('الأنشطة التي قام بها: المشي اليومي، قراءة كتاب'),
              const SizedBox(height: 10),
              Text('التقييم: 5 نجوم'),
              const SizedBox(height: 10),
              // الأزرار لتعديل البيانات على شكل أيقونات
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildIconButton(context,
                      icon: Icons.health_and_safety,
                      label: 'البيانات الصحية',
                      onTap: () {}),
                  _buildIconButton(
                    context,
                    icon: Icons.person,
                    label: 'البيانات الشخصية',
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // زر الإجراء لتعديل البيانات على شكل أيقونة مع نص
  Widget _buildIconButton(
      BuildContext context, {
        required IconData icon,
        required String label,
        required VoidCallback onTap,
      }) {
    return Column(
      children: [
        IconButton(
          onPressed: onTap,
          icon: Icon(icon, size: 30, color: _userColor),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: _userColor),
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
