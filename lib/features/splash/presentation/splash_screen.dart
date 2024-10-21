import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/scheduler.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/storage_service.dart';
import '../cubit/splash_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoAnimation;
  late Animation<double> _textFadeAnimation;
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();

    // Animation controller for the logo scaling
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Animation controller for text fade-in
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Scale animation for the logo
    _logoAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    // Fade animation for the text
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );

    // Start the logo animation
    _logoController.forward();

    // Start the text fade-in animation after the logo finishes
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        _textController.forward();
      });
    });

    _startSplash(); // التحقق من حالة المستخدم بعد فترة زمنية معينة
  }

  Future<void> _startSplash() async {
    await Future.delayed(const Duration(seconds: 3)); // تأخير 3 ثواني
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final token = await _storageService.getToken();

    if (token != null) {
      // المستخدم مسجل دخوله مسبقًا، الانتقال إلى الصفحة الرئيسية
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      // المستخدم ليس مسجلًا، الانتقال إلى صفحة تسجيل الدخول أو عرض صفحة landing للمستخدم لأول مرة
      context.read<SplashCubit>().checkAppState();
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashReturningUser) {
          Navigator.of(context).pushReplacementNamed('/login');
        } else if (state is SplashFirstTimeUser) {
          Navigator.of(context).pushReplacementNamed('/landing');
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.defaultUserColor, // استخدام اللون الافتراضي للمستخدم
                AppTheme.defaultUserColor.withOpacity(0.2), // تدرج في نفس اللون
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Animation for the logo
                ScaleTransition(
                  scale: _logoAnimation,
                  child: SvgPicture.asset(
                    'assets/images/logo.svg',
                    width: 230,
                    height: 230,
                  ),
                ),
                const SizedBox(height: 20),
                // Animated fade for English text
                FadeTransition(
                  opacity: _textFadeAnimation,
                  child: Text(
                    'CareLink',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Color.lerp(
                          Colors.black87, AppTheme.defaultUserColor, 0.5),
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Animated fade for Arabic text
                FadeTransition(
                  opacity: _textFadeAnimation,
                  child: Text(
                    'رعاية',
                    style: TextStyle(
                      fontSize: 46,
                      fontWeight: FontWeight.w500,
                      color: Color.lerp(
                          Colors.black87, AppTheme.defaultUserColor, 0.5),
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.defaultUserColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
