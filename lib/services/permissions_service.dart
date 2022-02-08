import 'package:permission_handler/permission_handler.dart';

class PermissionsService {

  // final PermissionHandler permissionHandler = PermissionHandler();

  // requesting permission of what we want
  Future<bool> _requestPermission(Permission permission) async {
    // var result = await permissionHandler.requestPermissions([permission]);
    // if (result[permission] == PermissionStatus.granted) {
    //   return true;
    // }    
    // return false;

    var result = await permission.request();
    
    if(result.isGranted) {
      return true;
    }

    return false;

  }

  // asking particular permission
  Future<bool> requestStoragePermission({Function? onPermissionDenied}) async {
    var granted = await _requestPermission(Permission.storage);
    if (!granted) { // if permission is declined it shpuld ask again when it needs
      onPermissionDenied!();  // get called when the user declines permission 
    }
    return granted;
  }

  // dedicated functions for specific permissions
  Future<bool> hasContactsPermission() async {
    return hasPermission(Permission.storage);
  }

  // checking whether user already given the permission
  Future<bool> hasPermission(Permission permission) async {
    var permissionStatus = await permission.status;
    return permissionStatus == PermissionStatus.granted;
  }

  

}