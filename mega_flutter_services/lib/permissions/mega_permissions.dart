import 'package:permission_handler/permission_handler.dart';

class MegaPermissions {
  static Future<Map<MegaPermissionsType, MegaPermissionStatus>> request(
      {List<MegaPermissionsType> permissions}) async {
    final status =
        await permissions.map((e) => e.convertedTo).toList().request();
    return status.map((key, value) => MapEntry(
        MegaPermissionsTypeExtension.convertedFrom(key),
        MegaPermissionStatusExtension.converted(value)));
  }

  static Future<MegaPermissionStatus> requestPermission(
      {MegaPermissionsType permission}) async {
    final status = await permission.convertedTo.request();
    return MegaPermissionStatusExtension.converted(status);
  }
}

enum MegaPermissionsType { camera, location, locationAlways, locationWhenInUse }

enum MegaPermissionStatus {
  undetermined,
  granted,
  denied,
  restricted,
  permanentlyDenied,
}

extension MegaPermissionsTypeExtension on MegaPermissionsType {
  Permission get convertedTo {
    switch (this) {
      case MegaPermissionsType.camera:
        return Permission.camera;
      default:
        return Permission.camera;
    }
  }

  static MegaPermissionsType convertedFrom(Permission permission) {
    switch (permission) {
      case Permission.camera:
        return MegaPermissionsType.camera;
      default:
        return MegaPermissionsType.camera;
    }
  }
}

extension MegaPermissionStatusExtension on MegaPermissionStatus {
  static MegaPermissionStatus converted(PermissionStatus permission) {
    switch (permission) {
      case PermissionStatus.undetermined:
        return MegaPermissionStatus.undetermined;
      case PermissionStatus.granted:
        return MegaPermissionStatus.granted;
      case PermissionStatus.denied:
        return MegaPermissionStatus.denied;
      case PermissionStatus.restricted:
        return MegaPermissionStatus.restricted;
      case PermissionStatus.permanentlyDenied:
        return MegaPermissionStatus.permanentlyDenied;
      default:
        return MegaPermissionStatus.undetermined;
    }
  }
}
