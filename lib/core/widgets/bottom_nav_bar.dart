import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_theme.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onItemTapped,
  });

  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  String _userRole = '';
  Color _userColor = AppTheme.defaultUserColor;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final userRole = prefs.getString('role') ?? '';
    setState(() {
      _userRole = userRole;
      _userColor = AppTheme.getUserTypeColor(userRole);
    });
  }

  List<BottomNavigationBarItem> _buildBottomNavBarItems() {
    switch (_userRole) {
      case 'Volunteer':
        return [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: _userColor),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_available, color: _userColor),
            label: 'الأنشطة المتاحة',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart, color: _userColor),
            label: 'الإحصائيات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: _userColor),
            label: 'الملف الشخصي',
          ),
        ];
      case 'Caregiver':
      case 'Beneficiary':
        return [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: _userColor),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule, color: _userColor),
            label: 'الأنشطة والمواعيد',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervisor_account, color: _userColor),
            label: 'المشرفين',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: _userColor),
            label: 'الملف الشخصي',
          ),
        ];
      case 'MedicalSupervisor':
        return [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: _userColor),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts, color: _userColor),
            label: 'إدارة المستخدمين',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_run, color: _userColor),
            label: 'إدارة الأنشطة',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description, color: _userColor),
            label: 'التقارير',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: _userColor),
            label: 'الملف الشخصي',
          ),
        ];
      default:
        return [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: _userColor),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: _userColor),
            label: 'الإعدادات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: _userColor),
            label: 'الملف الشخصي',
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: widget.onItemTapped,
      unselectedItemColor: Colors.grey,
      selectedItemColor: _userColor,
      items: _buildBottomNavBarItems(),
    );
  }
}
