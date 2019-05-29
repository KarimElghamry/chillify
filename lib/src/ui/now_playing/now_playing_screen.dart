import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:music_app/src/blocs/global.dart';
import 'package:music_app/src/common/music_icons.dart';
import 'package:music_app/src/models/playback.dart';
import 'package:music_app/src/models/playerstate.dart';
import 'package:music_app/src/ui/now_playing/album_art_container.dart';
import 'package:music_app/src/ui/now_playing/empty_album_art.dart';
import 'package:music_app/src/ui/now_playing/music_board_controls.dart';
import 'package:music_app/src/ui/now_playing/now_playing_slider.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class NowPlayingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    final double _radius = 25.0;
    final double _screenHeight = MediaQuery.of(context).size.height;
    final double _albumArtSize = _screenHeight / 1.9;
    return Column(
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            StreamBuilder<MapEntry<MapEntry<PlayerState, Song>, List<Song>>>(
              stream: Observable.combineLatest2(
                _globalBloc.musicPlayerBloc.playerState$,
                _globalBloc.musicPlayerBloc.favorites$,
                (a, b) => MapEntry(a, b),
              ),
              builder: (BuildContext context,
                  AsyncSnapshot<
                          MapEntry<MapEntry<PlayerState, Song>, List<Song>>>
                      snapshot) {
                if (!snapshot.hasData) {
                  return Icon(
                    Icons.favorite,
                    size: 35,
                    color: Color(0xFFC7D2E3),
                  );
                }
                final PlayerState _state = snapshot.data.key.key;
                if (_state == PlayerState.stopped) {
                  return Icon(
                    Icons.favorite,
                    size: 35,
                    color: Color(0xFFC7D2E3),
                  );
                }
                final Song _currentSong = snapshot.data.key.value;
                final List<Song> _favorites = snapshot.data.value;
                final bool _isFavorited = _favorites.contains(_currentSong);
                return IconButton(
                  onPressed: () {
                    if (_isFavorited) {
                      _globalBloc.musicPlayerBloc
                          .removeFromFavorites(_currentSong);
                    } else {
                      _globalBloc.musicPlayerBloc.addToFavorites(_currentSong);
                    }
                  },
                  icon: Icon(
                    Icons.favorite,
                    size: 35,
                    color:
                        !_isFavorited ? Color(0xFFC7D2E3) : Color(0xFF7B92CA),
                  ),
                );
              },
            ),
            StreamBuilder<List<Playback>>(
              stream: _globalBloc.musicPlayerBloc.playback$,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Playback>> snapshot) {
                if (!snapshot.hasData) {
                  return Icon(
                    Icons.loop,
                    size: 35,
                    color: Color(0xFFC7D2E3),
                  );
                }
                final List<Playback> _playbackList = snapshot.data;
                final bool _isSelected =
                    _playbackList.contains(Playback.repeatSong);
                return IconButton(
                  onPressed: () {
                    if (!_isSelected) {
                      _globalBloc.musicPlayerBloc
                          .updatePlayback(Playback.repeatSong);
                    } else {
                      _globalBloc.musicPlayerBloc
                          .removePlayback(Playback.repeatSong);
                    }
                  },
                  icon: Icon(
                    Icons.loop,
                    size: 35,
                    color: !_isSelected ? Color(0xFFC7D2E3) : Color(0xFF7B92CA),
                  ),
                );
              },
            ),
            StreamBuilder<List<Playback>>(
              stream: _globalBloc.musicPlayerBloc.playback$,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Playback>> snapshot) {
                if (!snapshot.hasData) {
                  return Icon(
                    Icons.loop,
                    size: 35,
                    color: Color(0xFFC7D2E3),
                  );
                }
                final List<Playback> _playbackList = snapshot.data;
                final bool _isSelected =
                    _playbackList.contains(Playback.shuffle);
                return IconButton(
                  onPressed: () {
                    if (!_isSelected) {
                      _globalBloc.musicPlayerBloc
                          .updatePlayback(Playback.shuffle);
                    } else {
                      _globalBloc.musicPlayerBloc
                          .removePlayback(Playback.shuffle);
                    }
                  },
                  icon: Icon(
                    Icons.shuffle,
                    size: 35,
                    color: !_isSelected ? Color(0xFFC7D2E3) : Color(0xFF7B92CA),
                  ),
                );
              },
            ),
          ],
        ),
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
                child: HideIcon(
                  color: Color(0xFF90A4D4),
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
                          AsyncSnapshot<MapEntry<PlayerState, Song>> snapshot) {
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
