import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/file_picker_service.dart';
import '../../../core/theme/app_theme.dart';
import '../cubit/auth_cubit.dart';

class ConfirmationScreen extends StatefulWidget {
  final String userType;
  final bool isFilesComplete;
  final List<String> missingFiles;
  final String profileId; // تأكد من استلام profileId هنا

  const ConfirmationScreen({
    super.key,
    required this.userType,
    this.isFilesComplete = true,
    this.missingFiles = const [],
    required this.profileId, // تمرير profileId
  });

  @override
  ConfirmationScreenState createState() => ConfirmationScreenState();
}

class ConfirmationScreenState extends State<ConfirmationScreen> {
  List<String> remainingFiles = [];
  List<String> uploadedFiles = [];
  final filePickerService = FilePickerService();
  String? identityProofImage;
  String? drivingLicenseImage;
  String? medicalCertificateImage;

  @override
  void initState() {
    super.initState();

    // التأكد من الملفات المرفوعة مسبقاً إذا كانت البيانات تم استلامها من الصفحة السابقة
    identityProofImage =
        widget.missingFiles.contains('إثبات الهوية') ? null : 'تم رفع الملف';
    drivingLicenseImage =
        widget.missingFiles.contains('رخصة القيادة') ? null : 'تم رفع الملف';
    medicalCertificateImage =
        widget.missingFiles.contains('شهادة الإسعاف أو التمريض')
            ? null
            : 'تم رفع الملف';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تأكيد البيانات'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/confirmation_success.svg',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 20),
                Text(
                  'تم إرسال بياناتك بنجاح!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  'الرجاء الانتظار حتى يتم تأكيد بياناتك. سيتم إبلاغك عند إتمام المراجعة.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                if (widget.userType == 'Beneficiary' ||
                    widget.userType == 'Caregiver') ...[
                  _buildPhoneEmailInput(),
                ] else if (widget.userType == 'Volunteer') ...[
                  _buildVolunteerDocuments(),
                ] else ...[
                  _buildLoginRedirectButton(context),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneEmailInput() {
    return Column(
      children: [
        const Text(
          'أدخل رقم الهاتف أو البريد الإلكتروني للشخص المرتبط بك:',
          style: TextStyle(fontSize: 16, color: Colors.black87),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            labelText: 'البريد الإلكتروني أو رقم الهاتف',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildVolunteerDocuments() {
    return Wrap(
      alignment: WrapAlignment.center, // يجعل الأيقونات تتمركز بشكل أفقي
      spacing: 20.0, // المسافة الأفقية بين الأيقونات
      runSpacing: 20.0, // المسافة العمودية بين الأيقونات
      children: [
        // التحقق من حالة إثبات الهوية
        if (identityProofImage == null) // التحقق من أن الملف غير مرفوع مسبقاً
          _buildFileUploadField(
            label: 'إثبات الهوية',
            fileType: 'identityProof',
          )
        else
          _buildFileUploadedIcon('إثبات الهوية'),

        // التحقق من حالة رخصة القيادة
        if (drivingLicenseImage == null)
          _buildFileUploadField(
            label: 'رخصة القيادة',
            fileType: 'drivingLicense',
          )
        else
          _buildFileUploadedIcon('رخصة القيادة'),

        // التحقق من حالة الشهادة الطبية
        if (medicalCertificateImage == null)
          _buildFileUploadField(
            label: 'شهادة الإسعاف أو التمريض',
            fileType: 'medicalCertificate',
          )
        else
          _buildFileUploadedIcon('شهادة الإسعاف أو التمريض'),
      ],
    );
  }

  Widget _buildFileUploadField({
    required String label,
    required String fileType,
  }) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              String? filePath =
                  await filePickerService.pickImageOrFile(context, 'pdf');
              if (filePath != null) {
                // رفع الملف باستخدام profileId
                await context.read<AuthCubit>().uploadFileToServer(
                    filePath, '/documents', widget.profileId,
                    isImage: false);

                setState(() {
                  if (fileType == 'identityProof') {
                    identityProofImage = filePath;
                  } else if (fileType == 'drivingLicense') {
                    drivingLicenseImage = filePath;
                  } else if (fileType == 'medicalCertificate') {
                    medicalCertificateImage = filePath;
                  }
                  uploadedFiles.add(fileType);
                  remainingFiles.remove(fileType);
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              width: 130,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.file_upload,
                    size: 20,
                    color: AppTheme.defaultUserColor,
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    'إرفاق ملف',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.defaultUserColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // عرض رسالة أو أيقونة تؤكد رفع الملف
  Widget _buildFileUploadedIcon(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
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

  Widget _buildLoginRedirectButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        backgroundColor: Colors.green,
      ),
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/login');
      },
      child: const Text('العودة لتسجيل الدخول'),
    );
  }
}
