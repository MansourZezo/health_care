import 'package:flutter/material.dart';
import 'package:health_care/features/home/presentation/navigation_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/splash/presentation/landing_page.dart';
import '../../features/authentication/presentation/login_screen.dart';
import '../../features/authentication/presentation/signup_screen.dart';
import '../../features/authentication/presentation/verify_data_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/medical_supervisors/presentation/medical_supervisors_info_screen.dart';
import '../../features/activity_rating_history/presentation/activity_history_screen.dart';
import '../../features/performance_statistics/presentation/performance_statistics_screen.dart';
import '../../features/reminders_activities/presentation/add_reminder_or_activity_screen.dart';
import '../../features/activity_reports/presentation/activity_report_screen.dart';
import '../../features/available_activities/presentation/view_available_activities_screen.dart';
import '../../features/profile/presentation/health_info_screen.dart';
import '../../features/profile/presentation/edit_profile_screen.dart';
import '../../features/reminders_activities/presentation/activity_reminder_details_screen.dart';
import '../../features/authentication/presentation/confirmation_screen.dart';
import '../../features/activity_management/presentation/activity_management_screen.dart';
import '../../features/user_management/presentation/manage_users_screen.dart';
import '../../features/report/presentation/reports_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String signup = '/signup';
  static const String verifyData = '/verify_data';
  static const String confirmation = '/confirmation';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String medicalSupervisorsInfo = '/medical_supervisors_info';
  static const String activityHistory = '/activity_history';
  static const String performanceStatistics = '/performance_statistics';
  static const String addReminderOrActivity = '/add_reminder_or_activity';
  static const String activityReport = '/activity_report';
  static const String viewAvailableActivities = '/view_available_activities';
  static const String landingPage = '/landing';
  static const String healthInfo = '/health_info';
  static const String editProfile = '/edit_profile';
  static const String activityReminderDetails = '/activity_reminder_details';
  static const String manageUsers = '/manage_users';
  static const String activityManagement = '/activity_management';
  static const String reports = '/reports';

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const NavigationScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case verifyData:
        return MaterialPageRoute(builder: (_) => const VerifyDataScreen());
      case confirmation:
        return MaterialPageRoute(
          builder: (_) {
            final args = routeSettings.arguments as Map<String, dynamic>;

            return ConfirmationScreen(
              userType: args['userType'] as String,
              isFilesComplete: args['isFilesComplete'] as bool,
              missingFiles: args['missingFiles'] as List<String>,
              profileId: args['profileId'] as String, // تأكد من تمرير profileId
            );
          },
        );
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case medicalSupervisorsInfo:
        return MaterialPageRoute(
            builder: (_) => const MedicalSupervisorsInfoScreen());
      case activityHistory:
        return MaterialPageRoute(builder: (_) => const ActivityHistoryScreen());
      case performanceStatistics:
        return MaterialPageRoute(
            builder: (_) => const PerformanceStatisticsScreen());
      case addReminderOrActivity:
        return MaterialPageRoute(
            builder: (_) => const AddReminderOrActivityScreen());
      case activityReport:
        return MaterialPageRoute(builder: (_) => const ActivityReportScreen());
      case viewAvailableActivities:
        return MaterialPageRoute(
            builder: (_) => const ViewAvailableActivitiesScreen());
      case landingPage:
        return MaterialPageRoute(builder: (_) => const LandingPage());
      case healthInfo:
        return MaterialPageRoute(builder: (_) => const HealthInfoScreen());
      case editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case activityReminderDetails:
        return MaterialPageRoute(
            builder: (_) =>
                const ActivityReminderDetailsScreen(isActivity: true));
      case manageUsers:
        return MaterialPageRoute(builder: (_) => const ManageUsersScreen());
      case activityManagement:
        return MaterialPageRoute(
            builder: (_) => const ActivityManagementScreen());
      case reports:
        return MaterialPageRoute(builder: (_) => const ReportsScreen());

      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
