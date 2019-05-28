import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:music_app/src/ui/all_songs/all_songs_screen.dart';
import 'package:music_app/src/ui/device_music/bottom_panel.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class DeviceMusicScreen extends StatefulWidget {
  @override
  _DeviceMusicScreenState createState() => _DeviceMusicScreenState();
}

class _DeviceMusicScreenState extends State<DeviceMusicScreen> {
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
    //TODO: add panel
    return SlidingUpPanel(
      panel: null,
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
              0.8,
            ],
            colors: [
              Color(0xFF4D90CD),
              Color(0xFFDF5F9D),
            ],
          ),
        ),
        child: BottomPanel(controller: _controller),
      ),
      body: AllSongsScreen(),
    );
  }
}
