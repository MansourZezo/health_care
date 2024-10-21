import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import '../../Report/presentation/reports_screen.dart';
import '../../activity_management/presentation/activity_management_screen.dart';
import '../../user_management/presentation/manage_users_screen.dart';
import '../../available_activities/presentation/view_available_activities_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../reminders_activities/presentation/manage_reminders_activities_screen.dart';
import '../../medical_supervisors/presentation/medical_supervisors_info_screen.dart';
import '../../performance_statistics/presentation/performance_statistics_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  NavigationScreenState createState() => NavigationScreenState();
}

class NavigationScreenState extends State<NavigationScreen> {
  int _currentIndex = 0;
  String _userRole = '';

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  // تحميل دور المستخدم من SharedPreferences
  Future<void> _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final userRole = prefs.getString('role') ?? '';
    setState(() {
      _userRole = userRole;
    });
  }

  // بناء الصفحات بناءً على نوع المستخدم
  List<Widget> _buildPages() {
    switch (_userRole) {
      case 'Volunteer':
        return [
          const HomeScreen(),
          const ViewAvailableActivitiesScreen(), // الأنشطة المتاحة
          const PerformanceStatisticsScreen(), // الإحصائيات
          const ProfileScreen(), // الملف الشخصي
        ];
      case 'Caregiver':
      case 'Beneficiary':
        return [
          const HomeScreen(),
          const ManageRemindersActivitiesScreen(), // الأنشطة والمواعيد
          const MedicalSupervisorsInfoScreen(), // المشرفين
          const ProfileScreen(), // الملف الشخصي
        ];
      case 'MedicalSupervisor':
        return [
          const HomeScreen(),
          const ManageUsersScreen(), // إدارة المستخدمين
          const ActivityManagementScreen(), // إدارة الأنشطة
          const ReportsScreen(), // التقارير
          const ProfileScreen(), // الملف الشخصي
        ];
      default:
        return [
          const HomeScreen(),
          const SettingsScreen(), // الإعدادات
          const ProfileScreen(), // الملف الشخصي
        ];
    }
  }

  // التحكم في التنقل بين الصفحات
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _buildPages(), // استخدام الصفحات المبنية على دور المستخدم
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
