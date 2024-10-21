import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/services/permissions_util.dart';
import '../../../core/services/storage_service.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final StorageService _storageService;

  SplashCubit(this._storageService) : super(SplashInitial());

  // دالة لطلب الأذونات
  Future<void> requestPermissions() async {
    try {
      await PermissionsUtil.requestPermissions();
      emit(SplashPermissionsGranted());
    } catch (e) {
      emit(SplashPermissionsFailed("Failed to request permissions: $e"));
    }
  }

  // دالة للتحقق من حالة التطبيق
  Future<void> checkAppState() async {
    await Future.delayed(const Duration(seconds: 2));

    // التحقق مما إذا كان المستخدم يدخل لأول مرة أم لا
    final isFirstTime = await _storageService.isFirstTime();
    if (isFirstTime) {
      emit(SplashFirstTimeUser());
    } else {
      emit(SplashReturningUser());
    }
  }
}
