import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_theme.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  NotificationsScreenState createState() => NotificationsScreenState();
}

class NotificationsScreenState extends State<NotificationsScreen> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشعارات'),
        centerTitle: true,
        backgroundColor: _userColor, // تغيير لون AppBar بناءً على المستخدم
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildDateSection(context, 'اليوم', [
              _buildNotificationCard(
                context,
                title: 'موعد الدواء',
                description: 'حان موعد الدواء يجب عليك أن تأخذه',
                dateTime: 'الآن',
                icon: Icons.medication,
              ),
              _buildNotificationCard(
                context,
                title: 'مراجعة الطبيب',
                description: 'حان موعد مراجعة الطبيب',
                dateTime: '12:20',
                icon: Icons.local_hospital,
              ),
              _buildNotificationCard(
                context,
                title: 'موعد الغذاء',
                description: 'وقت الغذاء',
                dateTime: '09:38',
                icon: Icons.restaurant,
              ),
            ]),
            const SizedBox(height: 20),
            _buildDateSection(context, 'أمس', [
              _buildNotificationCard(
                context,
                title: 'موعد الدواء',
                description: 'حان موعد الدواء يجب عليك أن تأخذه',
                dateTime: '06:23',
                icon: Icons.medication,
              ),
              _buildNotificationCard(
                context,
                title: 'موعد النوم',
                description: 'حان موعد النوم يجب أن تأخذه',
                dateTime: '12:20',
                icon: Icons.bedtime,
              ),
            ]),
            const SizedBox(height: 20),
            _buildDateSection(context, 'الجمعة 11/10/2024', [
              _buildNotificationCard(
                context,
                title: 'موعد الدواء',
                description: 'حان موعد الدواء يجب عليك أن تأخذه',
                dateTime: '08:00',
                icon: Icons.medication,
              ),
              _buildNotificationCard(
                context,
                title: 'مراجعة الطبيب',
                description: 'حان موعد مراجعة الطبيب',
                dateTime: '12:20',
                icon: Icons.local_hospital,
              ),
            ]),
          ],
        ),
      ),
    );
  }

  // دالة لبناء قسم يحتوي على إشعارات لتاريخ معين مع خط فاصل
  Widget _buildDateSection(BuildContext context, String dateTitle, List<Widget> notifications) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Divider(thickness: 1, color: _userColor.withOpacity(0.4))), // تغيير لون الخط بناءً على لون المستخدم
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                dateTitle,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _userColor.withOpacity(0.6)), // تغيير لون النص بناءً على لون المستخدم
              ),
            ),
            Expanded(child: Divider(thickness: 1, color: _userColor.withOpacity(0.4))), // تغيير لون الخط بناءً على لون المستخدم
          ],
        ),
        const SizedBox(height: 10),
        Column(children: notifications),
      ],
    );
  }

  // دالة لبناء بطاقة الإشعار
  Widget _buildNotificationCard(
      BuildContext context, {
        required String title,
        required String description,
        required String dateTime,
        required IconData icon,
      }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, color: _userColor, size: 40), // تغيير لون الأيقونة بناءً على المستخدم
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            const SizedBox(height: 5),
            Text(
              dateTime,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        onTap: () {
          // تنفيذ عند الضغط على الإشعار
        },
      ),
    );
  }
}
