import 'package:hive/hive.dart';

class LocalProfileService {
  static final Box<String> _box = Hive.box<String>('profileBox');

  /// Save profile image path locally
  static Future<void> saveProfileImage(String userId, String imagePath) async {
    await _box.put(userId, imagePath);
  }

  /// Get saved profile image path
  static String? getProfileImage(String userId) {
    final path = _box.get(userId);
    if (path == null || path.isEmpty) return null;
    return path;
  }

  /// Remove profile image
  static Future<void> removeProfileImage(String userId) async {
    await _box.delete(userId);
  }

  /// Check if profile image exists
  static bool hasProfileImage(String userId) {
    return _box.containsKey(userId);
  }
}
