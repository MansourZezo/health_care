import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';
import '../services/auth_service.dart';
import '../../../core/services/file_upload_service.dart';
import '../../../core/services/permissions_util.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/models/signup_model.dart';
import '../../../core/utils/error_handler.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;
  final FileUploadService fileUploadService;
  final ApiService apiService;
  final StorageService storageService = StorageService();

  // المتغيرات لتخزين التوكن وبيانات المستخدم
  String? _token;
  String? _userName;
  String? _userEmail;
  String? _userRole;

  AuthCubit(this.authService, this.fileUploadService, this.apiService)
      : super(AuthInitial());

  // Getters لاسترجاع البيانات
  String? get token => _token;

  String? get userName => _userName;

  String? get userEmail => _userEmail;

  String? get userRole => _userRole;

  // دالة لتغيير نوع المستخدم
  void changeUserType(String userType) {
    emit(UserTypeSelected(userType));
  }

  // دالة لرفع الملفات
  Future<String?> _uploadFile(String? filePath, String endpoint,
      {required bool isImage}) async {
    if (filePath != null) {
      try {
        final fullUrl = apiService.baseUrl + endpoint;
        final response = await fileUploadService.uploadFile(filePath, fullUrl,
            isImage: isImage);
        return response.data['fileUrl'];
      } catch (e) {
        emit(AuthFailureSignup(ErrorHandler.getErrorMessage(e)));
        return null;
      }
    }
    return null;
  }

  // دالة التسجيل
  Future<void> register(SignUpModel signUpModel) async {
    emit(AuthLoading());
    try {
      // رفع الملفات وصورة الملف الشخصي
      String? profileImageUrl = await _uploadFile(
          signUpModel.profileImage, '/uploads/profile',
          isImage: true);
      String? identityProofUrl = await _uploadFile(
          signUpModel.identityProof, '/uploads/documents',
          isImage: false);
      String? drivingLicenseUrl = await _uploadFile(
          signUpModel.drivingLicense, '/uploads/documents',
          isImage: false);
      String? medicalCertificateUrl = await _uploadFile(
          signUpModel.medicalCertificate, '/uploads/documents',
          isImage: false);

      // تحديث روابط الملفات في النموذج
      signUpModel.profileImage = profileImageUrl;
      signUpModel.identityProof = identityProofUrl;
      signUpModel.drivingLicense = drivingLicenseUrl;
      signUpModel.medicalCertificate = medicalCertificateUrl;

      // استدعاء دالة التسجيل في AuthService
      final response = await authService.register(signUpModel);

      // التحقق من نجاح العملية
      if (response.statusCode == 200 || response.statusCode == 201) {
        // التحقق من أن response.data ليست null
        if (response.data != null && response.data['token'] != null) {
          _token = response.data['token'];
          _userName = response.data['data']['user']['name'];
          _userEmail = response.data['data']['user']['email'];
          _userRole = response.data['data']['user']['role'];

          // التأكد من أن التوكن والبيانات ليست null قبل حفظها
          if (_token != null &&
              _userName != null &&
              _userEmail != null &&
              _userRole != null) {
            await storageService.saveUserData(
                _token!, _userName!, _userEmail!, _userRole!);
            emit(AuthSuccessSignup()); // تأكيد نجاح التسجيل
          } else {
            emit(AuthFailureSignup('بيانات التسجيل غير مكتملة.'));
          }
        } else {
          emit(AuthFailureSignup('فشل في الحصول على بيانات المستخدم.'));
        }
      } else {
        emit(AuthFailureSignup(
            'فشل التسجيل. ${ErrorHandler.getErrorMessage(response)}'));
      }
    } catch (e) {
      emit(AuthFailureSignup(
          'حدث خطأ أثناء التسجيل: ${ErrorHandler.getErrorMessage(e)}'));
    }
  }

  // دالة تسجيل الدخول
  Future<void> login(String identifier, String password) async {
    emit(AuthLoading());
    try {
      final response = await authService.login(identifier, password);

      // تحقق من نجاح تسجيل الدخول
      if (response.statusCode == 200 || response.statusCode == 201) {
        // تخزين الـ token وبيانات المستخدم
        _token = response.data['token'];
        _userName = response.data['data']['user']['name'];
        _userEmail = response.data['data']['user']['email'];
        _userRole = response.data['data']['user']['role'];

        // حفظ البيانات في التخزين المؤقت
        await storageService.saveUserData(
            _token!, _userName!, _userEmail!, _userRole!);

        emit(AuthSuccessLogin()); // تأكيد نجاح تسجيل الدخول
      } else {
        emit(AuthFailureLogin(ErrorHandler.getErrorMessage(response)));
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        emit(AuthFailureLogin(
            "انتهت مهلة الاتصال. يرجى التحقق من اتصالك بالخادم."));
      } else {
        emit(AuthFailureLogin(ErrorHandler.getErrorMessage(e)));
      }
    } catch (e) {
      emit(AuthFailureLogin("حدث خطأ غير متوقع: ${e.toString()}"));
    }
  }

  // دالة لطلب الأذونات
  Future<void> requestPermissions() async {
    try {
      await PermissionsUtil.requestPermissions();
    } catch (e) {
      emit(AuthFailureSignup(ErrorHandler.getErrorMessage(e)));
    }
  }
}
