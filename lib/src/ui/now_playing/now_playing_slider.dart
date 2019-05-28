import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:music_app/src/blocs/global.dart';
import 'package:music_app/src/models/playerstate.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class NowPlayingSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);

    return StreamBuilder<MapEntry<Duration, MapEntry<PlayerState, Song>>>(
      stream: Observable.combineLatest2(_globalBloc.musicPlayerBloc.position$,
          _globalBloc.musicPlayerBloc.playerState$, (a, b) => MapEntry(a, b)),
      builder: (BuildContext context,
          AsyncSnapshot<MapEntry<Duration, MapEntry<PlayerState, Song>>>
              snapshot) {
        if (!snapshot.hasData) {
          return Slider(
            value: 0,
            onChanged: (double value) => null,
            activeColor: Colors.blue,
            inactiveColor: Color(0xFFCEE3EE),
          );
        }
        if (snapshot.data.value.key == PlayerState.stopped) {
          return Slider(
            value: 0,
            onChanged: (double value) => null,
            activeColor: Colors.blue,
            inactiveColor: Color(0xFFCEE3EE),
          );
        }
        final Duration _currentDuration = snapshot.data.key;
        final Song _currentSong = snapshot.data.value.value;
        final int _millseconds = _currentDuration.inMilliseconds;
        final int _songDurationInMilliseconds = _currentSong.duration;
        return Slider(
          min: 0,
          max: _songDurationInMilliseconds.toDouble(),
          value: _songDurationInMilliseconds > _millseconds
              ? _millseconds.toDouble()
              : _songDurationInMilliseconds.toDouble(),
          onChangeStart: (double value) =>
              _globalBloc.musicPlayerBloc.invertSeekingState(),
          onChanged: (double value) {
            final Duration _duration = Duration(
              milliseconds: value.toInt(),
            );
            _globalBloc.musicPlayerBloc.updatePosition(_duration);
          },
          onChangeEnd: (double value) {
            _globalBloc.musicPlayerBloc.invertSeekingState();
            _globalBloc.musicPlayerBloc.audioSeek(value / 1000);
          },
          activeColor: Colors.blue,
          inactiveColor: Color(0xFFCEE3EE),
        );
      },
    );
  }
}
