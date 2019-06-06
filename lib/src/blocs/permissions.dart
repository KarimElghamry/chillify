import 'package:rxdart/rxdart.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsBloc {
  BehaviorSubject<PermissionStatus> _storagePermissionStatus$;

  BehaviorSubject<PermissionStatus> get storagePermissionStatus$ =>
      _storagePermissionStatus$;

  PermissionsBloc() {
    _storagePermissionStatus$ = BehaviorSubject<PermissionStatus>();
    requestStoragePermission();
  }

  Future<void> requestStoragePermission() async {
    Map<PermissionGroup, PermissionStatus> _permission =
        await PermissionHandler().requestPermissions(
      [
        PermissionGroup.storage,
      ],
    );
    final PermissionStatus _state = _permission.values.toList()[0];

    _storagePermissionStatus$.add(_state);
  }

  void dispose() {
    _storagePermissionStatus$.close();
  }
}
