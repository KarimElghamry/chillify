import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:music_app/src/blocs/global.dart';
import 'package:music_app/src/common/music_icons.dart';
import 'package:music_app/src/models/playerstate.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class BottomPanel extends StatelessWidget {
  final PanelController _controller;

  BottomPanel({@required PanelController controller})
      : _controller = controller;

  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    return Container(
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.bottomCenter,
      child: StreamBuilder<MapEntry<PlayerState, Song>>(
        stream: _globalBloc.musicPlayerBloc.playerState$,
        builder: (BuildContext context,
            AsyncSnapshot<MapEntry<PlayerState, Song>> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          final PlayerState _state = snapshot.data.key;
          final Song _currentSong = snapshot.data.value;
          final String _artists = getArtists(_currentSong);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {
                          if (_currentSong.uri == null) {
                            return;
                          }
                          if (PlayerState.paused == _state) {
                            _globalBloc.musicPlayerBloc.playMusic(_currentSong);
                          } else {
                            _globalBloc.musicPlayerBloc
                                .pauseMusic(_currentSong);
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.centerLeft,
                          child: _state == PlayerState.playing
                              ? PauseIcon(
                                  color: Colors.white,
                                )
                              : PlayIcon(
                                  color: Colors.white,
                                ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 8,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                _currentSong.title,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Divider(
                                height: 10,
                                color: Colors.transparent,
                              ),
                              Text(
                                _artists.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  letterSpacing: 1,
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
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => _controller.open(),
                          child: ShowIcon(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      flex: 2,
                      child: Container(
                        width: double.infinity,
                      ),
                    ),
                    Flexible(
                      flex: 10,
                      child: StreamBuilder<Duration>(
                          stream: _globalBloc.musicPlayerBloc.position$,
                          builder: (BuildContext context,
                              AsyncSnapshot<Duration> snapshot) {
                            if (_state == PlayerState.stopped ||
                                !snapshot.hasData) {
                              return Slider(
                                value: 0,
                                onChanged: (double value) => null,
                                activeColor: Colors.transparent,
                                inactiveColor: Colors.transparent,
                              );
                            }
                            final Duration _currentDuration = snapshot.data;
                            final int _millseconds =
                                _currentDuration.inMilliseconds;
                            final int _songDurationInMilliseconds =
                                _currentSong.duration;
                            return Slider(
                              min: 0,
                              max: _songDurationInMilliseconds.toDouble(),
                              value: _songDurationInMilliseconds > _millseconds
                                  ? _millseconds.toDouble()
                                  : _songDurationInMilliseconds.toDouble(),
                              onChangeStart: (double value) => _globalBloc
                                  .musicPlayerBloc
                                  .invertSeekingState(),
                              onChanged: (double value) {
                                final Duration _duration = Duration(
                                  milliseconds: value.toInt(),
                                );
                                _globalBloc.musicPlayerBloc
                                    .updatePosition(_duration);
                              },
                              onChangeEnd: (double value) {
                                _globalBloc.musicPlayerBloc
                                    .invertSeekingState();
                                _globalBloc.musicPlayerBloc
                                    .audioSeek(value / 1000);
                              },
                              activeColor: Colors.white,
                              inactiveColor: Colors.white.withOpacity(0.5),
                            );
                          }),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String getArtists(Song song) {
    return song.artist.split(";").reduce((String a, String b) {
      return a + " & " + b;
    });
  }
}
