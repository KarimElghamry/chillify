import 'package:flute_music_player/flute_music_player.dart';

class Album {
  int _id;
  String _name;
  String _art;
  String _artist;

  int get id => _id;
  String get name => _name;
  String get art => _art;
  String get artist => _artist;

  Album(this._id, this._name, this._art, this._artist);

  factory Album.fromSong(Song song) {
    return Album(song.albumId, song.album, song.albumArt, song.artist);
  }
}
