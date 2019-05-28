import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:music_app/src/blocs/global.dart';
import 'package:music_app/src/models/playerstate.dart';
import 'package:music_app/src/ui/now_playing/album_art_container.dart';
import 'package:music_app/src/ui/now_playing/music_board_controls.dart';
import 'package:provider/provider.dart';

class NowPlayingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    final double _radius = 25.0;
    final double _albumArtSize = MediaQuery.of(context).size.height / 1.9;
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
                    return Container();
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
      ],
    );
  }
}
