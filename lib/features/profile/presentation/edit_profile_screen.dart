import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_theme.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController(text: 'John Doe');
  final TextEditingController emailController = TextEditingController(text: 'johndoe@example.com');
  final TextEditingController phoneController = TextEditingController(text: '+123 456 7890');
  final TextEditingController addressController = TextEditingController(text: '1234 Elm Street, Springfield, USA');
  final TextEditingController dateOfBirthController = TextEditingController(text: '01/01/1990');

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
              expandedHeight: 260.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                titlePadding: const EdgeInsets.only(bottom: 0),
                title: const Text('تعديل الملف الشخصي', style: TextStyle(fontWeight: FontWeight.normal)),
                background: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _WavePainter(color: _userColor),
                      ),
                    ),
                    Positioned(
                      top: 115,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.transparent,
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/profile_picture.png',
                                  fit: BoxFit.cover,
                                  width: 120,
                                  height: 120,
                                ),
                              ),
                            ),
                            if (isEditing)
                              Positioned(
                                bottom: 0,
                                right: -7,
                                child: InkWell(
                                  onTap: () {
                                    // سيتم إضافة منطق تعديل الصورة لاحقًا
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: _userColor,
                                    radius: 17,
                                    child: const Icon(Icons.edit, color: Colors.white, size: 20),
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
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const SizedBox(height: 20),
                    _buildEditableField(
                      label: 'الاسم',
                      controller: nameController,
                      icon: Icons.person,
                      isEditable: isEditing,
                    ),
                    const SizedBox(height: 20),
                    _buildEditableField(
                      label: 'البريد الإلكتروني',
                      controller: emailController,
                      icon: Icons.email,
                      isEditable: isEditing,
                    ),
                    const SizedBox(height: 20),
                    _buildEditableField(
                      label: 'رقم الهاتف',
                      controller: phoneController,
                      icon: Icons.phone,
                      isEditable: isEditing,
                    ),
                    const SizedBox(height: 20),
                    _buildEditableField(
                      label: 'العنوان',
                      controller: addressController,
                      icon: Icons.location_on,
                      isEditable: isEditing,
                    ),
                    const SizedBox(height: 20),
                    _buildEditableField(
                      label: 'تاريخ الميلاد',
                      controller: dateOfBirthController,
                      icon: Icons.calendar_today,
                      isDate: true,
                      isEditable: isEditing,
                    ),
                    const SizedBox(height: 40),
                    if (isEditing)
                      ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text('حفظ التعديلات'),
                        onPressed: () {
                          setState(() {
                            isEditing = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          backgroundColor: _userColor,
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

  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isDate = false,
    required bool isEditable,
  }) {
    return TextField(
      controller: controller,
      readOnly: !isEditable || isDate,
      onTap: isDate && isEditable ? () {} : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: _userColor),
        filled: true,
        fillColor: isEditable ? Colors.white : Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: isEditable ? _userColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: isEditable ? _userColor : Colors.transparent,
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
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.75, size.width * 0.5, size.height * 0.6)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.45, size.width, size.height * 0.6)
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
