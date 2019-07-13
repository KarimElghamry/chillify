import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:music_app/src/blocs/global.dart';
import 'package:music_app/src/common/empty_screen.dart';
import 'package:music_app/src/models/playerstate.dart';
import 'package:music_app/src/ui/all_songs/song_tile.dart';
import 'package:provider/provider.dart';

class AllSongsScreen extends StatelessWidget {
  AllSongsScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    return Scaffold(
      body: StreamBuilder<List<Song>>(
        stream: _globalBloc.musicPlayerBloc.songs$,
        builder: (BuildContext context, AsyncSnapshot<List<Song>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final List<Song> _songs = snapshot.data;
          if (_songs.length == 0) {
            return EmptyScreen(
              text: "You do not have any songs on your device.",
            );
          }
          return ListView.builder(
            key: PageStorageKey<String>("All Songs"),
            padding: const EdgeInsets.only(bottom: 150.0),
            physics: BouncingScrollPhysics(),
            itemCount: _songs.length,
            itemExtent: 100,
            itemBuilder: (BuildContext context, int index) {
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
                  return GestureDetector(
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
                          _globalBloc.musicPlayerBloc.playMusic(_songs[index]);
                          break;
                        default:
                          break;
                      }
                    },
                    child: SongTile(
                      song: _songs[index],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
