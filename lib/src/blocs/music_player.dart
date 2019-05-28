import 'package:flute_music_player/flute_music_player.dart';
import 'package:music_app/src/models/playerstate.dart';
import 'package:rxdart/rxdart.dart';

class MusicPlayerBloc {
  BehaviorSubject<List<Song>> _songs$;
  BehaviorSubject<MapEntry<PlayerState, Song>> _playerState$;
  BehaviorSubject<List<Song>> _playlist$;
  BehaviorSubject<Duration> _position$;
  BehaviorSubject<bool> _isAudioSeeking$;
  MusicFinder _audioPlayer;
  Song _defaultSong;

  BehaviorSubject<List<Song>> get songs$ => _songs$;
  BehaviorSubject<MapEntry<PlayerState, Song>> get playerState$ =>
      _playerState$;
  BehaviorSubject<List<Song>> get playlist$ => _playlist$;
  BehaviorSubject<Duration> get position$ => _position$;

  MusicPlayerBloc() {
    _defaultSong = Song(
      null,
      " ",
      " ",
      " ",
      null,
      null,
      null,
      null,
    );
    _isAudioSeeking$ = BehaviorSubject<bool>.seeded(false);
    _songs$ = BehaviorSubject<List<Song>>();
    _position$ = BehaviorSubject<Duration>();
    _playlist$ = BehaviorSubject<List<Song>>();
    _playerState$ = BehaviorSubject<MapEntry<PlayerState, Song>>.seeded(
      MapEntry(
        PlayerState.stopped,
        _defaultSong,
      ),
    );
    _initAudioPlayer();
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
  }

  void updatePlayerState(PlayerState state, Song song) {
    _playerState$.add(MapEntry(state, song));
  }

  void updatePosition(Duration duration) {
    _position$.add(duration);
  }

  void updatePlaylist(List<Song> playlist) {
    _playlist$.add(playlist);
  }

  void playNextSong() {
    if (_playerState$.value.key == PlayerState.stopped) {
      return;
    }
    final Song _currentSong = _playerState$.value.value;
    final List<Song> _playlist = playlist$.value;
    int _index = _playlist.indexOf(_currentSong);
    if (_index == _playlist.length - 1) {
      _index = 0;
    } else {
      _index++;
    }
    stopMusic();
    playMusic(_playlist[_index]);
  }

  void playPreviousSong() {
    if (_playerState$.value.key == PlayerState.stopped) {
      return;
    }
    final Song _currentSong = _playerState$.value.value;
    final List<Song> _playlist = playlist$.value;
    int _index = _playlist.indexOf(_currentSong);
    if (_index == 0) {
      _index = _playlist.length - 1;
    } else {
      _index--;
    }
    stopMusic();
    playMusic(_playlist[_index]);
  }

  void audioSeek(double seconds) {
    _audioPlayer.seek(seconds);
  }

  void invertSeekingState() {
    final _value = _isAudioSeeking$.value;
    _isAudioSeeking$.add(!_value);
  }

  void _initAudioPlayer() {
    _audioPlayer = MusicFinder();
    _audioPlayer.setPositionHandler(
      (Duration duration) {
        final bool _isAudioSeeking = _isAudioSeeking$.value;
        if (!_isAudioSeeking) {
          updatePosition(duration);
        }
      },
    );
    _audioPlayer.setCompletionHandler(() {
      playNextSong();
    });
  }

  void dispose() {
    _isAudioSeeking$.close();
    _songs$.close();
    _playerState$.close();
    _playlist$.close();
    _position$.close();
    _audioPlayer.stop();
  }
}
