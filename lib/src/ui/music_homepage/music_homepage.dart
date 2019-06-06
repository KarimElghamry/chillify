import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:music_app/src/blocs/global.dart';
import 'package:music_app/src/ui/all_songs/all_songs_screen.dart';
import 'package:music_app/src/ui/music_homepage/bottom_panel.dart';
import 'package:music_app/src/ui/now_playing/now_playing_screen.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MusicHomepage extends StatefulWidget {
  @override
  _MusicHomepageState createState() => _MusicHomepageState();
}

class _MusicHomepageState extends State<MusicHomepage> {
  PanelController _controller;

  @override
  void initState() {
    _controller = PanelController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _radius = 25.0;
    return WillPopScope(
      onWillPop: () {
        if (!_controller.isPanelClosed()) {
          _controller.close();
        } else {
          _showExitDialog();
        }
      },
      child: Scaffold(
        body: SlidingUpPanel(
          panel: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(_radius),
              topRight: Radius.circular(_radius),
            ),
            child: NowPlayingScreen(controller: _controller),
          ),
          controller: _controller,
          minHeight: 110,
          maxHeight: MediaQuery.of(context).size.height,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(_radius),
            topRight: Radius.circular(_radius),
          ),
          collapsed: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(_radius),
                topRight: Radius.circular(_radius),
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [
                  0.0,
                  0.7,
                ],
                colors: [
                  Color(0xFF47ACE1),
                  Color(0xFFDF5F9D),
                ],
              ),
            ),
            child: BottomPanel(controller: _controller),
          ),
          body: AllSongsScreen(),
        ),
      ),
    );
  }

  void _showExitDialog() {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Chillify",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          content: Text(
            "Are you sure you want to close the app?",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              textColor: Color(0xFFDF5F9D),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("NO"),
            ),
            FlatButton(
              textColor: Color(0xFFDF5F9D),
              onPressed: () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                _globalBloc.dispose();
              },
              child: Text("YES"),
            ),
          ],
        );
      },
    );
  }
}
