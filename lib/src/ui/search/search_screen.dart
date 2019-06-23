import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:music_app/src/blocs/global.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color(0xFF274D85),
              size: 35,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: StreamBuilder<List<Song>>(
            stream: _globalBloc.musicPlayerBloc.songs$,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              final List<Song> _songs = snapshot.data;
              return TextField(
                controller: _textEditingController,
                cursorColor: Color(0xFF274D85),
                decoration: InputDecoration(
                  disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFD9EAF1).withOpacity(0.7),
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFD9EAF1).withOpacity(0.7),
                    ),
                  ),
                ),
                style: TextStyle(
                  color: Color(0xFF274D85),
                  fontSize: 22.0,
                ),
                autofocus: true,
                onChanged: (String value) {
                  _textEditingController.text = value;
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
