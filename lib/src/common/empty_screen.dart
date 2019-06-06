import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class EmptyScreen extends StatelessWidget {
  final String _text;

  EmptyScreen({@required String text}) : _text = text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.sentiment_dissatisfied,
            size: 150,
            color: Color(0xFF4D6B9C),
          ),
          Divider(
            height: 18,
            color: Colors.transparent,
          ),
          Text(
            _text,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Color(0xFFADB9CD),
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
