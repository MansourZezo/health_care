import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isDarkMode = false;
  double fontSize = 16.0;
  double brightness = 0.75;
  double pageSize = 1.0;
  String selectedLanguage = 'العربية';
  Color _userColor = AppTheme.defaultUserColor;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadUserColor();
  }

  Future<void> _loadUserColor() async {
    final prefs = await SharedPreferences.getInstance();
    final userRole = prefs.getString('role') ?? '';
    setState(() {
      _userColor = AppTheme.getUserTypeColor(userRole);
    });
  }

  void _showLanguageSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('العربية', style: TextStyle(color: selectedLanguage == 'العربية' ? _userColor : Colors.black)),
                onTap: () {
                  setState(() {
                    selectedLanguage = 'العربية';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('English', style: TextStyle(color: selectedLanguage == 'English' ? _userColor : Colors.black)),
                onTap: () {
                  setState(() {
                    selectedLanguage = 'English';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 260.0, // نفس الارتفاع كصفحة الملف الشخصي
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                titlePadding: const EdgeInsets.only(bottom: 5), // تعديل المسافة بين التموج والنص
                title: const Text('الإعدادات', style: TextStyle(fontWeight: FontWeight.normal)), // إزالة الخط العريض
                background: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _WavePainter(color: _userColor), // تعديل لون المستخدم
                      ),
                    ),
                    Positioned(
                      top: 125, // تعديل الموضع لزيادة المساحة الزرقاء
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          width: 80,
                          height: 80,
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
                          child: Icon(Icons.settings, size: 60, color: _userColor), // تغيير لون الأيقونة حسب نوع المستخدم
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const SizedBox(height: 10), // تعديل المسافات لتقليل الفجوة
                    _buildSettingsContent(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsContent() {
    return Theme(
      data: Theme.of(context).copyWith(
        tabBarTheme: TabBarTheme(
          labelColor: _userColor, // لون التبويبات المحددة
          //unselectedLabelColor: Colors.grey, // لون التبويبات غير المحددة
          indicator: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: _userColor, width: 2.0), // تغيير لون المؤشر إلى لون المستخدم
            ),
          ),
        ),
      ),
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'الإعدادات العامة'),
              Tab(text: 'الخصوصية'),
              Tab(text: 'الأمان'),
            ],
          ),
          SizedBox(
            height: 400, // تعديل حسب الحاجة
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildGeneralSettings(context),
                _buildPrivacySettings(context),
                _buildSecuritySettings(context),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildGeneralSettings(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('اللغة', style: TextStyle(fontSize: 18)),
            TextButton(
              onPressed: () => _showLanguageSelectionSheet(context),
              child: Text(selectedLanguage, style: TextStyle(fontSize: 18, color: _userColor)),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('الوضع المظلم', style: TextStyle(fontSize: 18)),
            Switch(
              value: isDarkMode,
              activeColor: _userColor, // تغيير لون زر التبديل بناءً على المستخدم
              onChanged: (bool newValue) {
                setState(() {
                  isDarkMode = newValue;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('حجم خط', style: TextStyle(fontSize: 18)),
            Row(
              children: [
                const Text('A', style: TextStyle(fontSize: 12, color: Colors.grey)),
                Slider(
                  value: fontSize,
                  min: 12.0,
                  max: 24.0,
                  activeColor: _userColor, // تغيير لون شريط التمرير
                  onChanged: (double newValue) {
                    setState(() {
                      fontSize = newValue;
                    });
                  },
                ),
                const Text('A', style: TextStyle(fontSize: 22, color: Colors.black)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('حجم الصفحة', style: TextStyle(fontSize: 18)),
            DropdownButton<double>(
              value: pageSize,
              dropdownColor: Colors.white,
              style: TextStyle(color: _userColor), // تغيير لون النص في DropdownButton
              items: const [
                DropdownMenuItem(value: 1.0, child: Text('100%')),
                DropdownMenuItem(value: 0.75, child: Text('75%')),
                DropdownMenuItem(value: 0.5, child: Text('50%')),
              ],
              onChanged: (double? newValue) {
                setState(() {
                  pageSize = newValue!;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('السطوع', style: TextStyle(fontSize: 18)),
            Row(
              children: [
                const Icon(Icons.brightness_low, color: Colors.grey),
                Slider(
                  value: brightness,
                  min: 0.0,
                  max: 1.0,
                  activeColor: _userColor, // تغيير لون شريط التمرير
                  onChanged: (double newValue) {
                    setState(() {
                      brightness = newValue;
                    });
                  },
                ),
                const Icon(Icons.brightness_high, color: Colors.black),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPrivacySettings(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: <Widget>[
        _buildSettingsOption(
          context,
          title: 'إعدادات الخصوصية',
          icon: Icons.lock,
          onTap: () {},
        ),
        _buildSettingsOption(
          context,
          title: 'الطوارئ',
          icon: Icons.phone_in_talk,
          onTap: () {},
        ),
        _buildSettingsOption(
          context,
          title: 'المتطوعين المحظورين',
          icon: Icons.block,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSecuritySettings(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: <Widget>[
        _buildSettingsOption(
          context,
          title: 'تغيير كلمة المرور',
          icon: Icons.password,
          onTap: () {},
        ),
        _buildSettingsOption(
          context,
          title: 'التحقق بخطوتين',
          icon: Icons.security,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSettingsOption(BuildContext context, {required String title, required IconData icon, required Function() onTap}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: _userColor), // تغيير لون الأيقونات حسب المستخدم
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
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
