import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_theme.dart';

class HealthInfoScreen extends StatefulWidget {
  const HealthInfoScreen({super.key});

  @override
  State<HealthInfoScreen> createState() => _HealthInfoScreenState();
}

class _HealthInfoScreenState extends State<HealthInfoScreen> {
  // Controllers for editable fields
  final TextEditingController generalHealthConditionController = TextEditingController(text: 'ارتفاع ضغط الدم والسكري.');
  final TextEditingController weightController = TextEditingController(text: '72 kg');
  final TextEditingController bloodPressureController = TextEditingController(text: '120/80 mmHg');
  final TextEditingController sugarLevelController = TextEditingController(text: '90 mg/dL');
  final TextEditingController cholesterolController = TextEditingController(text: '180 mg/dL');
  final TextEditingController heartRateController = TextEditingController(text: '72 bpm');
  final TextEditingController allergiesController = TextEditingController(text: 'الفول السوداني، البنسلين.');
  final TextEditingController medicationsController = TextEditingController(text: 'Aspirin - 100 mg - Once daily\nMetformin - 500 mg - Twice daily');

  bool isEditing = false;
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
                title: const Text('المعلومات الصحية'),
                background: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _WavePainter(color: _userColor), // استخدام لون المستخدم للتموجات
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
                          child: Icon(Icons.health_and_safety, size: 50, color: _userColor), // تغيير لون الأيقونة
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(isEditing ? Icons.check : Icons.edit),
                  onPressed: () {
                    setState(() {
                      isEditing = !isEditing;
                    });
                  },
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0), // إضافة مسافات من الجانبين
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    const SizedBox(height: 20),
                    _buildSectionWithIcon(Icons.health_and_safety, 'الحالة الصحية العامة'),
                    _buildEditableMultilineTextField(generalHealthConditionController),
                    const SizedBox(height: 20),

                    _buildSectionWithIcon(Icons.monitor_weight, 'الوزن'),
                    _buildEditableTextField(weightController),
                    const SizedBox(height: 20),

                    _buildSectionWithIcon(Icons.favorite, 'ضغط الدم'),
                    _buildEditableTextField(bloodPressureController),
                    const SizedBox(height: 20),

                    _buildSectionWithIcon(Icons.bloodtype, 'مستوى السكر في الدم'),
                    _buildEditableTextField(sugarLevelController),
                    const SizedBox(height: 20),

                    _buildSectionWithIcon(Icons.egg, 'الكوليسترول'),
                    _buildEditableTextField(cholesterolController),
                    const SizedBox(height: 20),

                    _buildSectionWithIcon(Icons.heart_broken, 'معدل ضربات القلب'),
                    _buildEditableTextField(heartRateController),
                    const SizedBox(height: 20),

                    _buildSectionWithIcon(Icons.medical_services, 'الأدوية الحالية'),
                    _buildEditableMultilineTextField(medicationsController),
                    const SizedBox(height: 20),

                    _buildSectionWithIcon(Icons.warning, 'الحساسية'),
                    _buildEditableMultilineTextField(allergiesController),
                    const SizedBox(height: 40),

                    if (isEditing)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Center(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.save),
                            label: const Text('حفظ التعديلات'),
                            onPressed: () {
                              setState(() {
                                isEditing = false;
                              });
                              // حفظ التعديلات
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              backgroundColor: _userColor, // تغيير لون الزر بناءً على المستخدم
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widgets to build the sections and data rows with icons
  Widget _buildSectionWithIcon(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: _userColor, size: 28), // تغيير لون الأيقونات بناءً على المستخدم
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildEditableTextField(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextField(
        controller: controller,
        enabled: isEditing,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _userColor), // تغيير لون الحدود بناءً على المستخدم
          ),
        ),
      ),
    );
  }

  // حقل إدخال متعدد الأسطر
  Widget _buildEditableMultilineTextField(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextField(
        controller: controller,
        enabled: isEditing,
        maxLines: 4,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _userColor), // تغيير لون الحدود بناءً على المستخدم
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
