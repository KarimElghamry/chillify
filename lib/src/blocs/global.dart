import 'package:music_app/src/blocs/music_player.dart';

class GlobalBloc {
  MusicPlayerBloc musicPlayerBloc;
  GlobalBloc() {
    musicPlayerBloc = MusicPlayerBloc();
  }

  void dispose() {
    musicPlayerBloc.dispose();
  }
}
