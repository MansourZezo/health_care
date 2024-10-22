import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // حفظ بيانات المستخدم ولكن حفظ التوكن فقط إذا كان خيار تذكرني مفعل
  Future<void> saveUserData(
      String token, String name, String email, String role,
      {bool rememberMe = false}) async {
    final prefs = await SharedPreferences.getInstance();

    // تخزين البيانات العامة للمستخدم (بغض النظر عن خيار "تذكرني")
    await prefs.setString('name', name);
    await prefs.setString('email', email);
    await prefs.setString('role', role);

    // تخزين التوكن إذا تم اختيار "تذكرني"
    if (rememberMe) {
      await prefs.setString('token', token);
    } else {
      await prefs.remove('token'); // إزالة التوكن عند عدم تفعيل "تذكرني"
    }

    // ضبط المستخدم لأول مرة كـ false بعد تسجيل البيانات
    await setFirstTime(false);
  }

  // استرجاع التوكن
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // مسح بيانات المستخدم عند تسجيل الخروج
  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('name');
    await prefs.remove('email');
    await prefs.remove('role');
  }

  // التحقق مما إذا كان المستخدم يستخدم التطبيق لأول مرة
  Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isFirstTime') ?? true;
  }

  // تعيين ما إذا كان المستخدم يستخدم التطبيق لأول مرة
  Future<void> setFirstTime(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', value);
  }

  // حفظ حالة "تذكرني"
  Future<void> setRememberMe(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', value);
  }

  // استرجاع حالة "تذكرني"
  Future<bool?> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('rememberMe');
  }
}
