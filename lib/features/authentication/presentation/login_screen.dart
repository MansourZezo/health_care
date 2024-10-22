import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/permissions_util.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/network_service.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isRememberMeChecked = false;
  bool _isTermsAccepted = false;
  final StorageService _storageService = StorageService();

  bool _isLoading = false; // متغير للتحكم بحالة التحميل

  @override
  void initState() {
    super.initState();
    requestPermissions();
    _loadRememberMeStatus();
  }

  Future<void> requestPermissions() async {
    await PermissionsUtil.requestPermissions();
  }

  Future<void> _loadRememberMeStatus() async {
    // تحميل حالة "تذكرني" من SharedPreferences
    bool? isRemembered = await _storageService.getRememberMe();

    setState(() {
      // ضبط الحالة الافتراضية إلى false إذا كانت null
      _isRememberMeChecked = isRemembered ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // الحصول على حجم لوحة المفاتيح
    final viewInsets = MediaQuery.of(context).viewInsets;
    final isKeyboardVisible = viewInsets.bottom > 0;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Positioned(
              top: isKeyboardVisible ? -50 : 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 200,
                child: CustomPaint(
                  painter: _WavePainter(color: AppTheme.defaultUserColor),
                ),
              ),
            ),
            Positioned(
              top: isKeyboardVisible ? 30 : 100,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 150,
                  height: 150,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: BlocListener<AuthCubit, AuthState>(
                  listener: (context, state) async {
                    if (state is AuthLoading) {
                      setState(() {
                        _isLoading = true;
                      });
                    } else {
                      setState(() {
                        _isLoading = false;
                      });
                    }

                    if (state is AuthSuccessLogin) {
                      final authCubit = context.read<AuthCubit>();

                      if (authCubit.token != null &&
                          authCubit.userName != null &&
                          authCubit.userEmail != null &&
                          authCubit.userRole != null) {
                        // تخزين بيانات المستخدم
                        await _storageService.saveUserData(
                          authCubit.token!,
                          authCubit.userName!,
                          authCubit.userEmail!,
                          authCubit.userRole!,
                          rememberMe:
                              _isRememberMeChecked, // تمرير حالة "تذكرني"
                        );

                        Navigator.pushReplacementNamed(context, '/home');
                      } else {
                        _showSnackBar(
                            "حدث خطأ أثناء تسجيل الدخول. يرجى المحاولة مرة أخرى.");
                      }
                    } else if (state is AuthFailureLogin) {
                      _showSnackBar(
                          "خطأ في تسجيل الدخول: ${state.errorMessage}");
                    }
                  },
                  child: Stack(
                    children: [
                      _buildForm(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 180),
          _buildTextField(
            controller: _emailController,
            labelText: 'البريد الإلكتروني أو رقم الهاتف',
            icon: Icons.person,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _passwordController,
            labelText: 'كلمة المرور',
            icon: Icons.lock,
            obscureText: !_isPasswordVisible,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: AppTheme.defaultUserColor,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: _isRememberMeChecked,
                    onChanged: (value) {
                      setState(() {
                        _isRememberMeChecked = value ?? false;
                      });
                    },
                    activeColor: AppTheme.defaultUserColor,
                    checkColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  const SizedBox(width: 8), // تقليل المسافة
                  Text(
                    'تذكرني',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  // منطق استعادة كلمة المرور
                },
                child: Text(
                  'نسيت كلمة المرور؟',
                  style: TextStyle(color: AppTheme.defaultUserColor),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: _isTermsAccepted,
                onChanged: (value) {
                  setState(() {
                    _isTermsAccepted = value ?? false;
                  });
                },
                activeColor: AppTheme.defaultUserColor,
                checkColor: Theme.of(context).colorScheme.onPrimary,
              ),
              Text(
                'أوافق على الشروط والأحكام',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _login, // تعطيل الزر أثناء التحميل
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white, // لون المؤشر
                        strokeWidth: 2.0, // سمك المؤشر
                      ),
                    )
                  : const Text('تسجيل الدخول'),
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/signup');
            },
            child: Text(
              'ليس لديك حساب؟ سجل الآن',
              style: TextStyle(color: AppTheme.defaultUserColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppTheme.defaultUserColor),
        suffixIcon: suffixIcon,
        labelText: labelText,
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  void _login() async {
    NetworkService networkService = NetworkService();

    setState(() {
      _isLoading = true;
    });

    // التحقق من الاتصال بالسيرفر
    bool isServerConnected = await networkService.checkServerConnection();
    if (!isServerConnected) {
      _showSnackBar("لا يوجد اتصال بالسيرفر. يرجى التحقق من الاتصال.");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final identifier = _emailController.text;
    final password = _passwordController.text;

    if (_isTermsAccepted && identifier.isNotEmpty && password.isNotEmpty) {
      context.read<AuthCubit>().login(identifier, password);
    } else {
      _showSnackBar(
          'يرجى إدخال البريد الإلكتروني/رقم الهاتف وكلمة المرور والموافقة على الشروط.');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
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
      ..moveTo(0, size.height * 0.85)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.95,
          size.width * 0.5, size.height * 0.85)
      ..quadraticBezierTo(
          size.width * 0.75, size.height * 0.7, size.width, size.height * 0.85)
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
