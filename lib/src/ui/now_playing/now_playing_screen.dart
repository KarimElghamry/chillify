import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:music_app/src/blocs/global.dart';
import 'package:music_app/src/common/music_icons.dart';
import 'package:music_app/src/models/playerstate.dart';
import 'package:music_app/src/ui/now_playing/album_art_container.dart';
import 'package:music_app/src/ui/now_playing/empty_album_art.dart';
import 'package:music_app/src/ui/now_playing/music_board_controls.dart';
import 'package:music_app/src/ui/now_playing/now_playing_slider.dart';
import 'package:music_app/src/ui/now_playing/preferences_board.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class NowPlayingScreen extends StatelessWidget {
  final PanelController _controller;

  NowPlayingScreen({@required PanelController controller})
      : _controller = controller;

  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    final double _radius = 25.0;
    final double _screenHeight = MediaQuery.of(context).size.height;
    final double _albumArtSize = _screenHeight / 2.1;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: _albumArtSize + 50,
            child: Stack(
              children: <Widget>[
                StreamBuilder<MapEntry<PlayerState, Song>>(
                  stream: _globalBloc.musicPlayerBloc.playerState$,
                  builder: (BuildContext context,
                      AsyncSnapshot<MapEntry<PlayerState, Song>> snapshot) {
                    if (!snapshot.hasData ||
                        snapshot.data.value.albumArt == null) {
                      return EmptyAlbumArtContainer(
                        radius: _radius,
                        albumArtSize: _albumArtSize,
                        iconSize: _albumArtSize / 2,
                      );
                    }

                    final Song _currentSong = snapshot.data.value;
                    return AlbumArtContainer(
                      radius: _radius,
                      albumArtSize: _albumArtSize,
                      currentSong: _currentSong,
                    );
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: MusicBoardControls(),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.transparent,
            height: _screenHeight / 15,
          ),
          PreferencesBoard(),
          Divider(
            color: Colors.transparent,
            height: _screenHeight / 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  flex: 12,
                  child: Container(
                    child: StreamBuilder<MapEntry<PlayerState, Song>>(
                      stream: _globalBloc.musicPlayerBloc.playerState$,
                      builder: (BuildContext context,
                          AsyncSnapshot<MapEntry<PlayerState, Song>> snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }
                        if (snapshot.data.key == PlayerState.stopped) {
                          return Container();
                        }
                        final Song _currentSong = snapshot.data.value;

                        final String _artists = _currentSong.artist
                            .split(";")
                            .reduce((String a, String b) {
                          return a + " & " + b;
                        });
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _currentSong.album.toUpperCase() +
                                  " • " +
                                  _artists.toUpperCase(),
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFADB9CD),
                                letterSpacing: 1,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Divider(
                              height: 5,
                              color: Colors.transparent,
                            ),
                            Text(
                              _currentSong.title,
                              style: TextStyle(
                                fontSize: 30,
                                color: Color(0xFF4D6B9C),
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () => _controller.close(),
                    child: HideIcon(
                      color: Color(0xFF90A4D4),
                    ),
                  ),
                )
              ],
            ),
          ),
          Divider(
            color: Colors.transparent,
            height: _screenHeight / 22,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: StreamBuilder<MapEntry<PlayerState, Song>>(
                        stream: _globalBloc.musicPlayerBloc.playerState$,
                        builder: (BuildContext context,
                            AsyncSnapshot<MapEntry<PlayerState, Song>>
                                snapshot) {
                          if (!snapshot.hasData) {
                            return Text(
                              "0:00",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFADB9CD),
                                letterSpacing: 1,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            );
                          }
                          final Song _currentSong = snapshot.data.value;
                          final PlayerState _state = snapshot.data.key;
                          if (_state == PlayerState.stopped) {
                            return Text(
                              "0:00",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFADB9CD),
                                letterSpacing: 1,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            );
                          }
                          return Text(
                            getDuration(_currentSong),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFADB9CD),
                              letterSpacing: 1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          );
                        }),
                  ),
                ),
                NowPlayingSlider(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getDuration(Song _song) {
    final double _temp = _song.duration / 1000;
    final int _minutes = (_temp / 60).floor();
    final int _seconds = (((_temp / 60) - _minutes) * 60).round();
    if (_seconds.toString().length != 1) {
      return _minutes.toString() + ":" + _seconds.toString();
    } else {
      return _minutes.toString() + ":0" + _seconds.toString();
    }
  }
}
