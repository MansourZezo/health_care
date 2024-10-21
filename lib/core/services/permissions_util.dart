import 'package:permission_handler/permission_handler.dart';

class PermissionsUtil {
  static Future<void> requestPermissions() async {
    await Permission.photos.request();
    await Permission.camera.request();
    await Permission.storage.request();
  }
}
