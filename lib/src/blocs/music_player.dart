import 'package:flute_music_player/flute_music_player.dart';
import 'package:music_app/src/models/playerstate.dart';
import 'package:rxdart/rxdart.dart';

class MusicPlayerBloc {
  BehaviorSubject<List<Song>> _songs$;
  BehaviorSubject<MapEntry<PlayerState, Song>> _playerState$;
  BehaviorSubject<List<Song>> _playlist$;
  BehaviorSubject<Duration> _duration$;
  MusicFinder _audioPlayer;

  BehaviorSubject<List<Song>> get songs$ => _songs$;
  BehaviorSubject<MapEntry<PlayerState, Song>> get playerState$ =>
      _playerState$;
  BehaviorSubject<List<Song>> get playlist$ => _playlist$;
  BehaviorSubject<Duration> get duration$ => _duration$;

  MusicPlayerBloc() {
    _songs$ = BehaviorSubject<List<Song>>();
    _playerState$ = BehaviorSubject<MapEntry<PlayerState, Song>>.seeded(
      MapEntry(PlayerState.stopped, null),
    );
    _duration$ = BehaviorSubject<Duration>();
    _playlist$ = BehaviorSubject<List<Song>>();
    initAudioPlayer();
    fetchSongs();
  }

  void fetchSongs() async {
    await MusicFinder.allSongs().then(
      (data) {
        _songs$.add(data);
      },
    );
  }

  Future<void> playMusic(Song song) async {
    await _audioPlayer.play(song.uri);
    updatePlayerState(PlayerState.playing, song);
  }

  Future<void> pauseMusic(Song song) async {
    await _audioPlayer.pause();
    updatePlayerState(PlayerState.paused, song);
  }

  Future<void> stopMusic() async {
    await _audioPlayer.stop();
    updatePlayerState(PlayerState.stopped, null);
  }

  void updatePlayerState(PlayerState state, Song song) {
    _playerState$.add(MapEntry(state, song));
  }

  void updateDuration(Duration duration) {
    _duration$.add(duration);
  }

  void updatePlaylist(List<Song> playlist) {
    _playlist$.add(playlist);
  }

  void playNextSong() {
    final Song _currentSong = _playerState$.value.value;
    final List<Song> _playlist = playlist$.value;
    int _index = _playlist.indexOf(_currentSong);
    if (_index == _playlist.length - 1) {
      _index = 0;
    } else {
      _index++;
    }
    playMusic(_playlist[_index]);
  }

  void playPreviousSong() {
    final Song _currentSong = _playerState$.value.value;
    final List<Song> _playlist = playlist$.value;
    int _index = _playlist.indexOf(_currentSong);
    if (_index == 0) {
      _index = _playlist.length - 1;
    } else {
      _index--;
    }
    playMusic(_playlist[_index]);
  }

  void initAudioPlayer() {
    _audioPlayer = MusicFinder();
    _audioPlayer.setDurationHandler(
      (Duration duration) => updateDuration(duration),
    );
    _audioPlayer.setCompletionHandler(() {
      playNextSong();
    });
  }

  void dispose() {
    _songs$.close();
    _playerState$.close();
    _duration$.close();
    _playlist$.close();
    _audioPlayer.stop();
  }
}
