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

  String? _token;
  String? _userName;
  String? _userEmail;
  String? _userRole;

  AuthCubit(this.authService, this.fileUploadService, this.apiService)
      : super(AuthInitial());

  String? get token => _token;

  String? get userName => _userName;

  String? get userEmail => _userEmail;

  String? get userRole => _userRole;

  void changeUserType(String userType) {
    emit(UserTypeSelected(userType));
  }

  // دالة خاصة لرفع الملفات
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

  // دالة عامة لرفع الملفات
  Future<void> uploadFileToServer(
      String filePath, String endpoint, String profileId,
      {required bool isImage}) async {
    try {
      String? fileUrl =
          await _uploadFile(filePath, '$endpoint/$profileId', isImage: isImage);

      if (fileUrl != null) {
        emit(AuthSuccessUpload(fileUrl));
      } else {
        emit(AuthFailureUpload('فشل في رفع الملف.'));
      }
    } catch (e) {
      emit(AuthFailureUpload(ErrorHandler.getErrorMessage(e)));
    }
  }

  Future<void> register(SignUpModel signUpModel) async {
    emit(AuthLoading());
    try {
      // 1. رفع الملفات قبل التسجيل
      String? profileImageUrl;
      if (signUpModel.profileImage != null) {
        profileImageUrl = await _uploadFile(
            signUpModel.profileImage, '/uploads/profile',
            isImage: true);
      }

      String? identityProofUrl;
      if (signUpModel.identityProof != null) {
        identityProofUrl = await _uploadFile(
            signUpModel.identityProof, '/uploads/documents',
            isImage: false);
      }

      String? drivingLicenseUrl;
      if (signUpModel.drivingLicense != null) {
        drivingLicenseUrl = await _uploadFile(
            signUpModel.drivingLicense, '/uploads/documents',
            isImage: false);
      }

      String? medicalCertificateUrl;
      if (signUpModel.medicalCertificate != null) {
        medicalCertificateUrl = await _uploadFile(
            signUpModel.medicalCertificate, '/uploads/documents',
            isImage: false);
      }

      // 2. تعديل قيم SignUpModel باستخدام الروابط التي تم رفعها
      signUpModel.profileImage = profileImageUrl;
      signUpModel.identityProof = identityProofUrl;
      signUpModel.drivingLicense = drivingLicenseUrl;
      signUpModel.medicalCertificate = medicalCertificateUrl;

      final response = await authService.register(signUpModel);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final profileId = response.data['data']['user']['profile'];

        if (response.data != null && response.data['token'] != null) {
          _token = response.data['token'];
          _userName = response.data['data']['user']['name'];
          _userEmail = response.data['data']['user']['email'];
          _userRole = response.data['data']['user']['role'];

          // حفظ بيانات المستخدم
          await storageService.saveUserData(
              _token!, _userName!, _userEmail!, _userRole!);

          emit(AuthSuccessSignup(profileId: profileId));
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

  Future<void> login(String identifier, String password) async {
    emit(AuthLoading());
    try {
      final response = await authService.login(identifier, password);
      if (response.statusCode == 200 || response.statusCode == 201) {
        _token = response.data['token'];
        _userName = response.data['data']['user']['name'];
        _userEmail = response.data['data']['user']['email'];
        _userRole = response.data['data']['user']['role'];

        await storageService.saveUserData(
            _token!, _userName!, _userEmail!, _userRole!);
        emit(AuthSuccessLogin());
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

  Future<void> requestPermissions() async {
    try {
      await PermissionsUtil.requestPermissions();
    } catch (e) {
      emit(AuthFailureSignup(ErrorHandler.getErrorMessage(e)));
    }
  }
}
