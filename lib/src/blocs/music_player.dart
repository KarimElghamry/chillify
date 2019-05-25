import 'package:flute_music_player/flute_music_player.dart';
import 'package:music_app/src/models/playerstate.dart';
import 'package:rxdart/rxdart.dart';

class MusicPlayerBloc {
  BehaviorSubject<List<Song>> _songs$;
  BehaviorSubject<MapEntry<PlayerState, Song>> _playerState$;
  BehaviorSubject<Duration> _duration$;
  MusicFinder _audioPlayer;

  BehaviorSubject<List<Song>> get songs$ => _songs$;
  BehaviorSubject<MapEntry<PlayerState, Song>> get playerState$ =>
      _playerState$;
  BehaviorSubject<Duration> get duration$ => _duration$;

  MusicPlayerBloc() {
    _songs$ = BehaviorSubject<List<Song>>();
    _playerState$ = BehaviorSubject<MapEntry<PlayerState, Song>>.seeded(
      MapEntry(PlayerState.stopped, null),
    );
    _duration$ = BehaviorSubject<Duration>();
    _audioPlayer = MusicFinder();
    _audioPlayer.setDurationHandler(
      (Duration duration) => updateDuration(duration),
    );
    fetchSongs();
  }

  void fetchSongs() async {
    await MusicFinder.allSongs().then(
      (data) {
        _songs$.add(data);
      },
    );
  }

  void playMusic(Song song) {
    _audioPlayer.play(song.uri);
    updatePlayerState(PlayerState.playing, song);
  }

  void pauseMusic(Song song) {
    _audioPlayer.pause();
    updatePlayerState(PlayerState.paused, song);
  }

  void stopMusic() {
    _audioPlayer.stop();
    updatePlayerState(PlayerState.stopped, null);
  }

  void updatePlayerState(PlayerState state, Song song) {
    _playerState$.add(MapEntry(state, song));
  }

  void updateDuration(Duration duration) {
    _duration$.add(duration);
  }

  void dispose() {
    _songs$.close();
    _playerState$.close();
    _duration$.close();
    _audioPlayer.stop();
  }
}
