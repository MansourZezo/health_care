import 'package:flutter/material.dart';

class AddReminderOrActivityScreen extends StatefulWidget {
  const AddReminderOrActivityScreen({super.key});

  @override
  AddReminderOrActivityScreenState createState() => AddReminderOrActivityScreenState();
}

class AddReminderOrActivityScreenState extends State<AddReminderOrActivityScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool isAddingActivity = false;
  bool hasSelectedOption = false; // للتحقق إذا قام المستخدم بتحديد "نشاط" أو "تذكير"

  // Controllers for activity inputs
  final TextEditingController activityNameController = TextEditingController();
  final TextEditingController activityTypeController = TextEditingController();
  final TextEditingController activityDateController = TextEditingController();
  final TextEditingController activityDescriptionController = TextEditingController();
  final TextEditingController activityDurationController = TextEditingController();
  final TextEditingController activityStatusController = TextEditingController();

  // Controllers for reminder inputs
  final TextEditingController reminderTitleController = TextEditingController();
  final TextEditingController reminderTypeController = TextEditingController();
  final TextEditingController reminderDateController = TextEditingController();
  final TextEditingController reminderDescriptionController = TextEditingController();
  final TextEditingController reminderDurationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إضافة تذكير أو نشاط'),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 140,
                child: CustomPaint(
                  painter: _WavePainter(),
                ),
              ),
            ),
            Positioned(
              top: 70,
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
                  child: const Icon(Icons.notifications_active, size: 60, color: Colors.blueAccent),
                ),
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 160),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentStep = page;
                      });
                    },
                    children: [
                      _buildSelectionPage(context),
                      if (hasSelectedOption) _buildDetailsPage(context),
                      if (hasSelectedOption) _buildDatePage(context),
                    ],
                  ),
                ),
                if (hasSelectedOption) // إظهار الـ Stepper بعد تحديد خيار "نشاط" أو "تذكير"
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0), // Padding لضبط المسافات حول الـ Stepper
                    child: _buildStepper(),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'ماذا تريد أن تضيف؟',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildOptionCard(
                icon: Icons.event,
                label: 'إضافة نشاط',
                onTap: () {
                  setState(() {
                    isAddingActivity = true;
                    hasSelectedOption = true;
                  });
                  _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                },
              ),
              _buildOptionCard(
                icon: Icons.alarm,
                label: 'إضافة تذكير',
                onTap: () {
                  setState(() {
                    isAddingActivity = false;
                    hasSelectedOption = true;
                  });
                  _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: Colors.blueAccent),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isAddingActivity) ...[
            _buildTextField(
              controller: activityNameController,
              labelText: 'اسم النشاط',
              icon: Icons.title,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: activityTypeController,
              labelText: 'نوع النشاط',
              icon: Icons.category,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: activityDescriptionController,
              labelText: 'وصف النشاط',
              icon: Icons.description,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: activityDurationController,
              labelText: 'المدة المتوقعة (اختياري)',
              icon: Icons.timelapse,
            ),
          ] else ...[
            _buildTextField(
              controller: reminderTitleController,
              labelText: 'عنوان التذكير',
              icon: Icons.title,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: reminderTypeController,
              labelText: 'نوع التذكير',
              icon: Icons.category,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: reminderDescriptionController,
              labelText: 'وصف التذكير',
              icon: Icons.description,
            ),
          ],
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20), // Larger button
            ),
            child: const Text('التالي'),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isAddingActivity) ...[
            _buildTextField(
              controller: activityDateController,
              labelText: 'تاريخ النشاط',
              icon: Icons.calendar_today,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: activityStatusController,
              labelText: 'حالة النشاط (قيد التنفيذ/منجز)',
              icon: Icons.assignment_turned_in,
            ),
          ] else ...[
            _buildTextField(
              controller: reminderDateController,
              labelText: 'تاريخ التذكير',
              icon: Icons.calendar_today,
            ),
          ],
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              if (isAddingActivity) {
                Navigator.pushReplacementNamed(context, '/activity_report');
              } else {
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20), // Larger button
            ),
            child: Text(isAddingActivity ? 'إضافة نشاط' : 'إضافة تذكير'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildStepper() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepCircle(0, Icons.looks_one),
        _buildStepDivider(),
        _buildStepCircle(1, Icons.looks_two),
        _buildStepDivider(),
        _buildStepCircle(2, Icons.looks_3),
      ],
    );
  }

  Widget _buildStepCircle(int step, IconData icon) {
    return CircleAvatar(
      radius: _currentStep == step ? 18 : 15,
      backgroundColor: _currentStep == step ? Colors.blueAccent : Colors.grey[300],
      child: Icon(icon, color: _currentStep == step ? Colors.white : Colors.black, size: 20),
    );
  }

  Widget _buildStepDivider() {
    return Container(
      width: 40,
      height: 2,
      color: Colors.grey,
    );
  }
}

// رسم التموجات في الجزء العلوي
class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.8)
      ..quadraticBezierTo(
          size.width * 0.25, size.height * 0.95,
          size.width * 0.5, size.height * 0.8)
      ..quadraticBezierTo(
          size.width * 0.75, size.height * 0.65,
          size.width, size.height * 0.8)
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

