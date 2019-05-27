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
    return Material(
      type: MaterialType.transparency,
      child: Container(
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
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
                                _artists,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
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
              );
            }),
      ),
    );
  }

  String getArtists(Song song) {
    return song.artist.split(";").reduce((String a, String b) {
      return a + " & " + b;
    });
  }
}
