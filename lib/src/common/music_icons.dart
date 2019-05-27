import 'package:flutter/material.dart';

class PlayIcon extends StatelessWidget {
  final Color _color;

  PlayIcon({@required Color color}) : _color = color;

  @override
  Widget build(BuildContext context) {
    final double _radius = 55;
    return Container(
      width: _radius,
      height: _radius,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: _color,
        ),
        borderRadius: BorderRadius.circular(
          _radius,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.play_arrow,
          color: _color,
          size: 32.0,
        ),
      ),
    );
  }
}

class PauseIcon extends StatelessWidget {
  Color _color;

  PauseIcon({@required Color color}) : _color = color;

  @override
  Widget build(BuildContext context) {
    final double _radius = 55;
    return Container(
      width: _radius,
      height: _radius,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: _color,
        ),
        borderRadius: BorderRadius.circular(
          _radius,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.pause,
          color: _color,
          size: 32.0,
        ),
      ),
    );
  }
}

class ShowIcon extends StatelessWidget {
  Color _color;

  ShowIcon({@required Color color}) : _color = color;

  @override
  Widget build(BuildContext context) {
    final double _radius = 32;
    return Container(
      width: _radius,
      height: _radius,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: _color,
        ),
        borderRadius: BorderRadius.circular(
          _radius,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.keyboard_arrow_up,
          color: _color,
          size: 22.0,
        ),
      ),
    );
  }
}
