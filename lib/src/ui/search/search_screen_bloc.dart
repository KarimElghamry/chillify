import 'package:flute_music_player/flute_music_player.dart';
import 'package:rxdart/rxdart.dart';

class SearchScreenBloc {
  BehaviorSubject<List<Song>> _filteredSongs$;

  BehaviorSubject<List<Song>> get filteredSongs$ => _filteredSongs$;

  SearchScreenBloc() {
    _filteredSongs$ = BehaviorSubject<List<Song>>.seeded([]);
  }

  updateFilteredSongs(String filter, List<Song> songs) {}

  void dispose() {
    _filteredSongs$.close();
  }
}
