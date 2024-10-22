import 'package:dio/dio.dart';

class ErrorHandler {
  static String getErrorMessage(Object error) {
    if (error is DioException || error is Response) {
      if (error is DioException && error.response != null) {
        return _handleApiError(
            error.response?.statusCode, error.response?.data);
      } else if (error is Response) {
        return _handleApiError(error.statusCode, error.data);
      } else if (error is DioException && (error.type == DioExceptionType.connectionTimeout || error.type == DioExceptionType.receiveTimeout)) {
        return 'انتهت مهلة الاتصال بالخادم. تأكد من الاتصال بالشبكة.';
      } else {
        return 'فشل الاتصال بالخادم. تأكد من وجود اتصال بالإنترنت أو السيرفر.';
      }
    } else {
      return 'حدث خطأ غير متوقع: ${error.toString()}';
    }
  }

  static String _handleApiError(int? statusCode, dynamic data) {
    // إذا كانت بيانات الـ API تحتوي على رسالة خطأ، يتم إرجاعها مباشرة
    if (data != null && data is Map<String, dynamic> && data['message'] != null) {
      return data['message'];
    }

    switch (statusCode) {
      case 400:
        return _handleBadRequest(data); // استدعاء دالة خاصة لمعالجة 400
      case 401:
        return 'لم يتم التفويض. يرجى التحقق من تسجيل الدخول.';
      case 403:
        return 'ليس لديك الصلاحيات اللازمة للوصول إلى هذه الخدمة.';
      case 404:
        return 'المورد المطلوب غير موجود.';
      case 500:
        return 'حدث خطأ في الخادم. حاول مرة أخرى لاحقاً.';
      default:
        return 'حدث خطأ غير معروف. الرمز: $statusCode';
    }
  }

  static String _handleBadRequest(dynamic data) {
    if (data == null || data is! Map<String, dynamic> || data['message'] == null) {
      return 'حدث خطأ غير معروف في الطلب. يرجى المحاولة لاحقًا.';
    }

    String message = data['message'].toString();

    if (message.contains('Invalid email or phone number')) {
      return 'البريد الإلكتروني أو رقم الهاتف غير صحيح.';
    } else if (message.contains('Invalid password')) {
      return 'كلمة المرور غير صحيحة.';
    } else if (message.contains('Email is already registered')) {
      return 'البريد الإلكتروني مسجل بالفعل. يرجى استخدام بريد إلكتروني آخر.';
    } else if (message.contains('Phone number is already registered')) {
      return 'رقم الهاتف مسجل بالفعل. يرجى استخدام رقم هاتف آخر.';
    } else if (message.contains('Role is required')) {
      return 'يرجى تحديد نوع المستخدم.';
    } else {
      return message;
    }
  }
}
