import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../../../core/services/file_picker_service.dart';
import '../../../core/services/network_service.dart';
import '../../../core/models/signup_model.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  int _currentStep = 0;
  String? selectedUserType;

  // إنشاء كائن FilePickerService
  final FilePickerService filePickerService = FilePickerService();

  // Controllers for input fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();

  // Controllers for health info (only for Beneficiary)
  final TextEditingController conditionController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController bloodPressureController = TextEditingController();

  // Images and documents for volunteers
  String? profileImage;
  String? identityProofImage;
  String? drivingLicenseImage;
  String? medicalCertificateImage;

  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('التسجيل'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        resizeToAvoidBottomInset: true, // يسمح بتفادي التداخل مع لوحة المفاتيح
        body: SafeArea(
          child: BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccessSignup) {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/confirmation');
              } else if (state is AuthFailureSignup) {
                Navigator.pop(context);
                _showSnackBar("خطأ في التسجيل: ${state.errorMessage}");
              } else if (state is UserTypeSelected) {
                setState(() {
                  selectedUserType = state.userType;
                });
              }
            },
            child: Stack(
              children: [
                _buildBackgroundWave(), // الخلفية
                _buildAppLogo(), // الشعار
                Padding(
                  padding: const EdgeInsets.only(top: 160.0),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: _buildContent(), // المحتوى القابل للتمرير
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper methods for UI
  Widget _buildBackgroundWave() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SizedBox(
        height: 140,
        child: CustomPaint(
          painter: _WavePainter(color: AppTheme.defaultUserColor),
        ),
      ),
    );
  }

  Widget _buildAppLogo() {
    return Positioned(
      top: 37,
      left: 0,
      right: 0,
      child: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 120,
          height: 120,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme
                  .defaultUserColor, // لون الخطوة الحالية والخطوط بين الخطوات
            ),
          ),
          child: Stepper(
            key: UniqueKey(),
            currentStep: _currentStep,
            onStepContinue: _nextStep,
            onStepCancel: _previousStep,
            steps: _buildSteps(),
            controlsBuilder: (BuildContext context, ControlsDetails details) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: details.onStepContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _currentStep ==
                                _buildSteps().length - 1
                            ? AppTheme
                                .submitButtonColor // اللون الأخضر للزر في آخر خطوة
                            : AppTheme.defaultUserColor, // اللون الافتراضي للزر
                      ),
                      child: _currentStep == _buildSteps().length - 1
                          ? const Text('إرسال')
                          : const Text('التالي'),
                    ),
                    if (_currentStep > 0)
                      TextButton(
                        onPressed: details.onStepCancel,
                        child: const Text('رجوع'),
                      ),
                  ],
                ),
              );
            },
            type: StepperType.vertical,
            physics: const ClampingScrollPhysics(),
          ),
        ),
      ],
    );
  }

  List<Step> _buildSteps() {
    List<Step> steps = [
      Step(
        title: const Text('اختيار نوع المستخدم'),
        content: _buildUserSelection(),
        isActive: _currentStep == 0,
      ),
      Step(
        title: const Text('معلومات الدخول'),
        content: _buildLoginInfo(),
        isActive: _currentStep == 1,
      ),
      Step(
        title: const Text('المعلومات الشخصية'),
        content: _buildPersonalInfo(),
        isActive: _currentStep == 2,
      ),
    ];

    if (selectedUserType == 'Beneficiary') {
      steps.add(
        Step(
          title: const Text('المعلومات الصحية'),
          content: _buildHealthInfo(),
          isActive: _currentStep == steps.length,
        ),
      );
    }

    if (selectedUserType == 'Volunteer') {
      steps.add(
        Step(
          title: const Text('مستندات المتطوع'),
          content: _buildVolunteerDocuments(),
          isActive: _currentStep == steps.length,
        ),
      );
    }

    return steps;
  }

  Widget _buildUserSelection() {
    return Column(
      children: [
        const Text('اختر نوع المستخدم:'),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildUserOption(
              type: 'Volunteer',
              label: 'المتطوع',
              icon: Icons.volunteer_activism,
            ),
            _buildUserOption(
              type: 'Caregiver',
              label: 'المساعد',
              icon: Icons.family_restroom,
            ),
            _buildUserOption(
              type: 'Beneficiary',
              label: 'المستفيد',
              icon: Icons.person,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUserOption({
    required String type,
    required String label,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () {
        context.read<AuthCubit>().changeUserType(type);
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selectedUserType == type
                    ? AppTheme.defaultUserColor
                    : Colors.grey, // لون رمادي إذا لم يتم التحديد
                width: 2,
              ),
            ),
            padding: const EdgeInsets.all(10),
            child: Icon(
              icon,
              size: 60,
              color: selectedUserType == type
                  ? AppTheme.defaultUserColor
                  : Colors.grey, // لون رمادي إذا لم يتم التحديد
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: selectedUserType == type
                  ? AppTheme.defaultUserColor
                  : Colors.black, // لون أسود للنص إذا لم يتم التحديد
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginInfo() {
    return Column(
      children: [
        const SizedBox(height: 20),
        _buildTextField(
          controller: emailController,
          labelText: 'البريد الإلكتروني',
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: phoneNumberController,
          labelText: 'رقم الهاتف',
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: passwordController,
          labelText: 'كلمة المرور',
          icon: Icons.lock,
          obscureText: true,
        ),
        const SizedBox(height: 10),
        const Text(
          'يجب إدخال إما البريد الإلكتروني أو رقم الهاتف. كلاهما ليس إلزاميًا.',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildPersonalInfo() {
    return Column(
      children: [
        _buildProfilePictureField(),
        const SizedBox(height: 20),
        _buildTextField(
          controller: fullNameController,
          labelText: 'الاسم الكامل',
          icon: Icons.person,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: addressController,
          labelText: 'العنوان (اختياري)',
          icon: Icons.home,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: dateOfBirthController,
          labelText: 'تاريخ الميلاد (اختياري)',
          icon: Icons.calendar_today,
          keyboardType: TextInputType.datetime,
        ),
      ],
    );
  }

  Widget _buildHealthInfo() {
    return Column(
      children: [
        const SizedBox(height: 20),
        _buildTextField(
          controller: conditionController,
          labelText: 'الحالة الصحية العامة',
          icon: Icons.health_and_safety,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: weightController,
          labelText: 'الوزن',
          icon: Icons.monitor_weight,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: bloodPressureController,
          labelText: 'ضغط الدم',
          icon: Icons.favorite,
        ),
      ],
    );
  }

  // بناء حقل إدخال النصوص
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildProfilePictureField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'الصورة الشخصية',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () async {
            String? pickedImage =
                await filePickerService.pickImageOrFile(context, 'image');
            if (pickedImage != null) {
              setState(() {
                profileImage = pickedImage;
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: const Offset(0, 3)),
              ],
            ),
            child: profileImage == null
                ? Icon(
                    Icons.camera_alt,
                    size: 40,
                    color: AppTheme
                        .defaultUserColor, // تأكد من استخدام defaultUserColor
                  )
                : ClipOval(
                    child: Image.file(File(profileImage!), fit: BoxFit.cover),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'يسمح فقط بملفات jpg, jpeg, png بحد أقصى 5MB',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildVolunteerDocuments() {
    return Column(
      children: [
        if (identityProofImage == null &&
            drivingLicenseImage == null &&
            medicalCertificateImage == null)
          const Text(
            'يسمح بملفات pdf, docx, txt بحد أقصى 5MB',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        const SizedBox(height: 8),
        _buildFileUploadField(
          label: 'إثبات الهوية',
          fileType: 'identityProof',
        ),
        const SizedBox(height: 20),
        _buildFileUploadField(
          label: 'رخصة القيادة',
          fileType: 'drivingLicense',
        ),
        const SizedBox(height: 20),
        _buildFileUploadField(
          label: 'شهادة الإسعاف أو التمريض',
          fileType: 'medicalCertificate',
        ),
      ],
    );
  }

  Widget _buildFileUploadField({
    required String label,
    required String fileType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _pickImageOrFile(fileType),
          child: Container(
            padding: const EdgeInsets.all(6),
            width: 80,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.file_upload,
                  size: 20,
                  color: AppTheme.defaultUserColor,
                ),
                const SizedBox(height: 4),
                Text(
                  'إرفاق ملف',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.defaultUserColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (fileType == 'identityProof' && identityProofImage != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.check_circle, color: Colors.green, size: 18),
              SizedBox(width: 5),
              Text("تم رفع الملف", style: TextStyle(color: Colors.green)),
            ],
          ),
        if (fileType == 'drivingLicense' && drivingLicenseImage != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.check_circle, color: Colors.green, size: 18),
              SizedBox(width: 5),
              Text("تم رفع الملف", style: TextStyle(color: Colors.green)),
            ],
          ),
        if (fileType == 'medicalCertificate' && medicalCertificateImage != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.check_circle, color: Colors.green, size: 18),
              SizedBox(width: 5),
              Text("تم رفع الملف", style: TextStyle(color: Colors.green)),
            ],
          ),
      ],
    );
  }

  Future<void> _pickImageOrFile(String fileType) async {
    String? filePath =
        await filePickerService.pickImageOrFile(context, fileType);
    setState(() {
      switch (fileType) {
        case 'profile':
          profileImage = filePath;
          break;
        case 'identityProof':
          identityProofImage = filePath;
          break;
        case 'drivingLicense':
          drivingLicenseImage = filePath;
          break;
        case 'medicalCertificate':
          medicalCertificateImage = filePath;
          break;
      }
    });
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  // Utility methods for functionality
  void _nextStep() {
    if (_currentStep == 0 && selectedUserType == null) {
      _showSnackBar('يرجى اختيار نوع المستخدم');
      return;
    }

    if (_currentStep == 1) {
      if (emailController.text.isEmpty && phoneNumberController.text.isEmpty) {
        _showSnackBar('يرجى إدخال البريد الإلكتروني أو رقم الهاتف');
        return;
      }
      if (passwordController.text.isEmpty) {
        _showSnackBar('يرجى إدخال كلمة المرور');
        return;
      }
    }

    if (_currentStep == 2 && fullNameController.text.isEmpty) {
      _showSnackBar('يرجى إدخال الاسم الكامل');
      return;
    }

    if (_currentStep < _buildSteps().length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      _submitRegistration();
    }
  }

  Future<void> _submitRegistration() async {
    NetworkService networkService = NetworkService();

    // التحقق من الاتصال بالإنترنت
    bool isConnected = await networkService.checkInternetConnection();
    if (!isConnected) {
      _showSnackBar("لا يوجد اتصال بالإنترنت");
      return;
    }

    // عرض مؤشر التحميل
    _showLoadingDialog(context);

    try {
      // بناء الكائن SignUpModel المستخدم للتسجيل
      SignUpModel signUpModel = SignUpModel(
        email: emailController.text.isNotEmpty ? emailController.text : null,
        phoneNumber: phoneNumberController.text.isNotEmpty
            ? phoneNumberController.text
            : null,
        password: passwordController.text,
        name: fullNameController.text,
        profileImage: profileImage,
        address:
            addressController.text.isNotEmpty ? addressController.text : null,
        dateOfBirth: dateOfBirthController.text.isNotEmpty
            ? dateOfBirthController.text
            : null,
        role: selectedUserType,
        identityProof:
            selectedUserType == 'Volunteer' ? identityProofImage : null,
        drivingLicense:
            selectedUserType == 'Volunteer' ? drivingLicenseImage : null,
        medicalCertificate:
            selectedUserType == 'Volunteer' ? medicalCertificateImage : null,
        healthInfo: selectedUserType == 'Beneficiary'
            ? HealthInfo(
                generalHealthCondition: conditionController.text.isNotEmpty
                    ? conditionController.text
                    : null,
                weight: weightController.text.isNotEmpty
                    ? int.parse(weightController.text)
                    : null,
                bloodPressure: bloodPressureController.text.isNotEmpty
                    ? bloodPressureController.text
                    : null,
              )
            : null,
      );

      // إرسال بيانات التسجيل عبر AuthCubit
      context.read<AuthCubit>().register(signUpModel);
    } catch (e) {
      Navigator.pop(context); // إغلاق Dialog التحميل عند حدوث خطأ
      _showSnackBar('حدث خطأ أثناء التسجيل: ${e.toString()}');
    }
  }

  // دالة لعرض مؤشر التحميل
  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // لا يمكن إغلاقه بالضغط على الشاشة
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("جاري الإرسال..."),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3), // مدة عرض الـ SnackBar
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
      ..moveTo(0, size.height * 0.7) // زيادة طفيفة في الطول
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.8,
          size.width * 0.5, size.height * 0.7)
      ..quadraticBezierTo(
          size.width * 0.75, size.height * 0.55, size.width, size.height * 0.7)
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
