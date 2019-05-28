import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_app/src/blocs/global.dart';
import 'package:music_app/src/blocs/permissions.dart';
import 'package:music_app/src/ui/music_homepage/music_homepage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ChillifyApp extends StatelessWidget {
  PermissionsBloc _permissionsBloc = PermissionsBloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PermissionStatus>(
        stream: _permissionsBloc.storagePermissionStatus$,
        builder:
            (BuildContext context, AsyncSnapshot<PermissionStatus> snapshot) {
          if (!snapshot.hasData) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          final PermissionStatus _status = snapshot.data;
          if (_status == PermissionStatus.denied) {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          }
          return Provider<GlobalBloc>(
            builder: (BuildContext context) => GlobalBloc(),
            dispose: (BuildContext context, GlobalBloc value) =>
                value.dispose(),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: MusicHomepage(),
            ),
          );
        });
  }
}
