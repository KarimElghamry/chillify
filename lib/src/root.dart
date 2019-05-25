import 'package:flutter/material.dart';
import 'package:music_app/src/blocs/global.dart';
import 'package:provider/provider.dart';

class ChillifyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<GlobalBloc>(
      builder: (BuildContext context) => GlobalBloc(),
      dispose: (BuildContext context, GlobalBloc value) => value.dispose(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(),
      ),
    );
  }
}
