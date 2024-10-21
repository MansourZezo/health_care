import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'routes/app_routes.dart';
import '../core/theme/app_theme.dart';
import 'features/authentication/cubit/auth_cubit.dart';
import 'features/splash/cubit/splash_cubit.dart'; // إضافة SplashCubit
import 'features/authentication/services/auth_service.dart';
import 'core/services/api_service.dart';
import 'core/services/file_upload_service.dart';
import 'core/services/storage_service.dart'; // استيراد StorageService

void main() {
  runApp(const CareLinkApp());
}

class CareLinkApp extends StatelessWidget {
  const CareLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dio = Dio();

    // إنشاء الخدمات التي يحتاجها AuthCubit و SplashCubit
    final apiService = ApiService();
    final authService = AuthService(apiService: apiService);
    final fileUploadService = FileUploadService(dio);
    final storageService = StorageService(); // إنشاء StorageService

    return MultiBlocProvider(
      providers: [
        // AuthCubit: مسؤول عن المصادقة
        BlocProvider(
          create: (context) =>
              AuthCubit(authService, fileUploadService, apiService),
        ),
        // SplashCubit: مسؤول عن شاشة البدء والتحقق من حالة المستخدم
        BlocProvider(
          create: (context) => SplashCubit(storageService),
        ),
      ],
      child: MaterialApp(
        title: 'CareLink',
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash, // البدء من صفحة SplashScreen
        onGenerateRoute: AppRoutes.generateRoute,
        debugShowCheckedModeBanner: false,
        builder: (context, widget) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: widget!,
          );
        },
      ),
    );
  }
}
