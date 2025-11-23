import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceIdManager {
  static const String _deviceIdKey = 'device_id';
  static DeviceIdManager? _instance;
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  String? _cachedDeviceId;

  DeviceIdManager._();

  static DeviceIdManager get instance {
    _instance ??= DeviceIdManager._();
    return _instance!;
  }

  Future<String> getDeviceId() async {
    if (_cachedDeviceId != null) {
      return _cachedDeviceId!;
    }

    final prefs = await SharedPreferences.getInstance();
    final storedDeviceId = prefs.getString(_deviceIdKey);

    if (storedDeviceId != null && storedDeviceId.isNotEmpty) {
      _cachedDeviceId = storedDeviceId;
      return storedDeviceId;
    }

    final deviceId = await _generateDeviceId();
    await _storeDeviceId(prefs, deviceId);
    _cachedDeviceId = deviceId;

    return deviceId;
  }

  Future<String> _generateDeviceId() async {
    try {
      if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ?? _generateFallbackId('ios');
      } else if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return androidInfo.id.isNotEmpty
            ? androidInfo.id
            : _generateFallbackId('android');
      } else {
        return _generateFallbackId('unknown');
      }
    } catch (e) {
      return _generateFallbackId('error');
    }
  }

  String _generateFallbackId(String prefix) {
    return '${prefix}_${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<void> _storeDeviceId(SharedPreferences prefs, String deviceId) async {
    await prefs.setString(_deviceIdKey, deviceId);
  }

  Future<void> clearDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_deviceIdKey);
    _cachedDeviceId = null;
  }

  Future<bool> hasDeviceId() async {
    if (_cachedDeviceId != null) return true;

    final prefs = await SharedPreferences.getInstance();
    final storedDeviceId = prefs.getString(_deviceIdKey);
    return storedDeviceId != null && storedDeviceId.isNotEmpty;
  }
}
