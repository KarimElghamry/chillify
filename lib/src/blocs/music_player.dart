import 'package:flute_music_player/flute_music_player.dart';
import 'package:music_app/src/models/playerstate.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class MusicPlayerBloc {
  BehaviorSubject<List<Song>> _songs$;
  BehaviorSubject<PlayerState> _playerState$;
  BehaviorSubject<Duration> _duration$;
  MusicFinder _audioPlayer;

  BehaviorSubject<List<Song>> get songs$ => _songs$;
  BehaviorSubject<PlayerState> get playerState$ => _playerState$;
  BehaviorSubject<Duration> get duration$ => _duration$;

  MusicPlayerBloc() {
    _songs$ = BehaviorSubject<List<Song>>();
    _playerState$ = BehaviorSubject<PlayerState>.seeded(PlayerState.stopped);
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

  void playMusic(String url) {
    _audioPlayer.play(url);
    updatePlayerState(PlayerState.playing);
  }

  void pauseMusic() {
    _audioPlayer.pause();
    updatePlayerState(PlayerState.paused);
  }

  void sauseMusic() {
    _audioPlayer.stop();
    updatePlayerState(PlayerState.stopped);
  }

  void updatePlayerState(PlayerState state) {
    _playerState$.add(state);
  }

  void updateDuration(Duration duration) {
    _duration$.add(duration);
  }

  void dispose() {
    _songs$.close();
    _playerState$.close();
    _audioPlayer.stop();
  }
}
