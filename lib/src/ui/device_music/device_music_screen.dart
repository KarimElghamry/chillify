import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/src/blocs/global.dart';
import 'package:music_app/src/models/playerstate.dart';
import 'package:provider/provider.dart';

class DeviceMusicScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: 1,
              color: Color(0xFFD9EAF1),
            ),
          ),
        ),
        title: Text(
          "Device Music",
          style: TextStyle(
            color: Color(0xFF274D85),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.search,
              size: 32,
              color: Color(0xFF274D85),
            ),
          )
        ],
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder<List<Song>>(
        stream: _globalBloc.musicPlayerBloc.songs$,
        builder: (BuildContext context, AsyncSnapshot<List<Song>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final List<Song> _songs = snapshot.data;

          return ListView.builder(
            itemCount: _songs.length,
            itemBuilder: (BuildContext context, int index) {
              final String _title = _songs[index].title;
              final String _uri = _songs[index].uri;
              return StreamBuilder<MapEntry<PlayerState, Song>>(
                  stream: _globalBloc.musicPlayerBloc.playerState$,
                  builder: (BuildContext context,
                      AsyncSnapshot<MapEntry<PlayerState, Song>> snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    final PlayerState _state = snapshot.data.key;
                    final Song _currentSong = snapshot.data.value;
                    final bool _isSelectedSong = _currentSong == _songs[index];
                    return ListTile(
                      onTap: () {
                        _globalBloc.musicPlayerBloc.updatePlaylist(_songs);
                        switch (_state) {
                          case PlayerState.playing:
                            if (_isSelectedSong) {
                              _globalBloc.musicPlayerBloc
                                  .pauseMusic(_currentSong);
                            } else {
                              _globalBloc.musicPlayerBloc.stopMusic();
                              _globalBloc.musicPlayerBloc.playMusic(
                                _songs[index],
                              );
                            }
                            break;
                          case PlayerState.paused:
                            if (_isSelectedSong) {
                              _globalBloc.musicPlayerBloc
                                  .playMusic(_songs[index]);
                            } else {
                              _globalBloc.musicPlayerBloc.stopMusic();
                              _globalBloc.musicPlayerBloc.playMusic(
                                _songs[index],
                              );
                            }
                            break;
                          case PlayerState.stopped:
                            _globalBloc.musicPlayerBloc
                                .playMusic(_songs[index]);
                            break;
                          default:
                            break;
                        }
                      },
                      leading: _isSelectedSong && _state == PlayerState.playing
                          ? Icon(
                              Icons.pause_circle_outline,
                              size: 40,
                            )
                          : Icon(
                              Icons.play_circle_outline,
                              size: 40,
                            ),
                      title: Text(
                        _title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  });
            },
          );
        },
      ),
    );
  }
}
