import 'package:permission_handler/permission_handler.dart';

void requestPermissions() async {
  await PermissionHandler().requestPermissions([
    PermissionGroup.storage,
  ]);
}
