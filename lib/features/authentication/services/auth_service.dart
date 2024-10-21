import 'package:dio/dio.dart';
import '/core/services/api_service.dart';
import '../../../core/models/signup_model.dart';
import '../../../core/utils/error_handler.dart';

class AuthService {
  final ApiService apiService;

  AuthService({required this.apiService});

  // تسجيل الدخول
  Future<Response> login(String identifier, String password) async {
    Map<String, dynamic> data = {
      'identifier': identifier,
      'password': password,
    };
    return await apiService.postRequest('/auth/login', data);
  }

  // التسجيل
  Future<Response> register(SignUpModel signUpModel) async {
    try {
      Map<String, dynamic> data = signUpModel.toJson();
      return await apiService.postRequest('/auth/signup', data);
    } on DioException catch (e) {
      throw Exception(
          ErrorHandler.getErrorMessage(e)); // معالجة الأخطاء في AuthService
    } catch (e) {
      throw Exception(ErrorHandler.getErrorMessage(e)); // معالجة الأخطاء العامة
    }
  }
}
