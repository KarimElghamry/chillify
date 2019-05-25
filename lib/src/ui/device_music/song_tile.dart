import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:music_app/src/blocs/global.dart';
import 'package:music_app/src/models/playerstate.dart';
import 'package:provider/provider.dart';

class SongTile extends StatelessWidget {
  final Song _song;
  String _artists;
  SongTile({@required Song song}) : _song = song;

  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    _artists = _song.artist.split(";").reduce((String a, String b) {
      return a + " & " + b;
    });
    return Container(
      height: 90,
      width: double.infinity,
      color: Colors.transparent,
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 2,
            child: StreamBuilder<MapEntry<PlayerState, Song>>(
              stream: _globalBloc.musicPlayerBloc.playerState$,
              builder: (BuildContext context,
                  AsyncSnapshot<MapEntry<PlayerState, Song>> snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }

                final PlayerState _state = snapshot.data.key;
                final Song _currentSong = snapshot.data.value;

                final bool _isSelectedSong = _song == _currentSong;
                return Center(
                  child: _isSelectedSong && _state == PlayerState.playing
                      ? PauseIcon()
                      : PlayIcon(),
                );
              },
            ),
          ),
          Flexible(
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _song.title,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4D6B9C),
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _artists,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFAAB7CB),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Container(
              width: double.infinity,
              child: Text(
                _song.duration.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF94A6C5),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlayIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double _radius = 55;
    return Container(
      width: _radius,
      height: _radius,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: Color(0xFFA9B6C4),
        ),
        borderRadius: BorderRadius.circular(
          _radius,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.play_arrow,
          size: 32.0,
        ),
      ),
    );
  }
}

class PauseIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double _radius = 55;
    return Container(
      width: _radius,
      height: _radius,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: Color(0xFFA9B6C4),
        ),
        borderRadius: BorderRadius.circular(
          _radius,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.pause,
          size: 32.0,
        ),
      ),
    );
  }
}
