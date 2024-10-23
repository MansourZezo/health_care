import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_theme.dart';

class ActivityManagementScreen extends StatefulWidget {
  const ActivityManagementScreen({super.key});

  @override
  ActivityManagementScreenState createState() =>
      ActivityManagementScreenState();
}

class ActivityManagementScreenState extends State<ActivityManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedRole = 'Beneficiary'; // المستفيد أو المتطوع
  String selectedUser = ''; // المستخدم المختار
  List<String> beneficiaries = ['مستفيد 1', 'مستفيد 2', 'مستفيد 3'];
  List<String> volunteers = ['متطوع 1', 'متطوع 2', 'متطوع 3'];
  Color _userColor = Colors.blueAccent; // اللون الافتراضي

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    selectedUser = beneficiaries[0]; // المستخدم الافتراضي
    _loadUserColor(); // تحميل لون المستخدم بناءً على الدور
  }

  Future<void> _loadUserColor() async {
    final prefs = await SharedPreferences.getInstance();
    final userRole = prefs.getString('role') ?? '';
    setState(() {
      _userColor = AppTheme.getUserTypeColor(
          userRole); // تحميل اللون بناءً على دور المستخدم
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
              title: const Text('إدارة الأنشطة'),
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
                        child: Icon(Icons.local_activity,
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
                  Tab(icon: Icon(Icons.person), text: 'مستفيدين'),
                  Tab(icon: Icon(Icons.volunteer_activism), text: 'متطوعين'),
                ],
                onTap: (index) {
                  setState(() {
                    selectedRole = index == 0 ? 'Beneficiary' : 'Volunteer';
                    selectedUser = index == 0
                        ? beneficiaries.isNotEmpty
                        ? beneficiaries[0]
                        : ''
                        : volunteers.isNotEmpty
                        ? volunteers[0]
                        : '';
                  });
                },
              ),
            ),
          ),
          SliverFillRemaining(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: _buildSelectionButton(selectedRole),
                  ), // زر الاختيار الجديد المصغر داخل الـ Column
                  const SizedBox(height: 10),
                  if (selectedUser.isNotEmpty)
                    Text(
                      'تفاصيل $selectedUser',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  const SizedBox(height: 20),
                  selectedRole == 'Beneficiary'
                      ? _buildBeneficiaryActivities()
                      : _buildVolunteerActivities(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // عرض Bottom Sheet لاختيار المستخدم
  void _showUserSelectionModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'اختر ${selectedRole == 'Beneficiary' ? 'مستفيد' : 'متطوع'}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: selectedRole == 'Beneficiary'
                      ? beneficiaries.length
                      : volunteers.length,
                  itemBuilder: (context, index) {
                    String user = selectedRole == 'Beneficiary'
                        ? beneficiaries[index]
                        : volunteers[index];
                    return ListTile(
                      title: Text(user),
                      onTap: () {
                        setState(() {
                          selectedUser = user;
                        });
                        Navigator.pop(
                            context); // إغلاق الـ Bottom Sheet بعد الاختيار
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSelectionButton(String role) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      // ضبط المسافة العلوية والسفلية
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 3,
        child: InkWell(
          onTap: _showUserSelectionModal,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            // تصغير الـ padding حول المحتوى
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  role == 'Beneficiary'
                      ? Icons.person
                      : Icons.volunteer_activism,
                  size: 30, // تصغير حجم الأيقونة
                  color: _userColor,
                ),
                const SizedBox(height: 5), // تصغير المسافة بين الأيقونة والنص
                Text(
                  'اختر ${role == 'Beneficiary' ? 'مستفيد' : 'متطوع'}',
                  style: TextStyle(
                    fontSize: 14, // تصغير حجم النص
                    fontWeight: FontWeight.bold,
                    color: _userColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // واجهة عرض الأنشطة للمستفيدين (تعديل وتخصيص الأنشطة)
  Widget _buildBeneficiaryActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildActivityDetails(),
        const SizedBox(height: 20),
        _buildEditActivityForm(), // تعديل الأنشطة
      ],
    );
  }

  // واجهة عرض الأنشطة للمتطوعين (عرض التفاصيل فقط)
  Widget _buildVolunteerActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildActivityDetails(), // عرض الأنشطة التي قام بها المتطوع
        const SizedBox(height: 20),
        _buildVolunteerReportSection(), // عرض تقرير المتطوع
      ],
    );
  }

  // عرض تفاصيل الأنشطة (مستفيدين أو متطوعين)
  Widget _buildActivityDetails() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الأنشطة المنجزة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildActivityTile('المشي اليومي', 'مكتمل', 5),
            _buildActivityTile('زيارة الطبيب', 'غير مكتمل', 3),
          ],
        ),
      ),
    );
  }

  // عنصر صغير لعرض نشاط
  Widget _buildActivityTile(String activity, String status, int rating) {
    return ListTile(
      title: Text(activity),
      subtitle: Text('الحالة: $status'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          rating,
              (index) => const Icon(Icons.star, color: Colors.amber),
        ),
      ),
    );
  }

  // نموذج تعديل الأنشطة للمستفيدين
  Widget _buildEditActivityForm() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تعديل الأنشطة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildTextField('اسم النشاط', 'المشي اليومي'),
            const SizedBox(height: 10),
            _buildTextField('الحالة', 'مكتمل'),
            const SizedBox(height: 10),
            _buildTextField('التقييم', '5'),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // تنفيذ الحفظ
                },
                icon: const Icon(Icons.save),
                label: const Text('حفظ التعديلات'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.submitButtonColor,
                  // لون الزر الأخضر من الـ Theme
                  padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // حقل إدخال نصي لتعديل الأنشطة
  Widget _buildTextField(String label, String initialValue) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      controller: TextEditingController(text: initialValue),
    );
  }

  // عرض تقرير المتطوع
  Widget _buildVolunteerReportSection() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تقرير المتطوع',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildTextDisplay('التقييم العام', '4'),
            const SizedBox(height: 10),
            _buildTextDisplay('ملاحظات', 'قام بإنهاء النشاط بنجاح'),
          ],
        ),
      ),
    );
  }

  // عرض النصوص فقط في تقرير المتطوع
  Widget _buildTextDisplay(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
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
