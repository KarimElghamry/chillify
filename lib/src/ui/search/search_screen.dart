import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:music_app/src/blocs/global.dart';
import 'package:music_app/src/models/playerstate.dart';
import 'package:music_app/src/ui/all_songs/song_tile.dart';
import 'package:music_app/src/ui/search/search_screen_bloc.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _textEditingController;
  SearchScreenBloc _searchScreenBloc;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _searchScreenBloc = SearchScreenBloc();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _searchScreenBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color(0xFF274D85),
              size: 35,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: StreamBuilder<List<Song>>(
            stream: _globalBloc.musicPlayerBloc.songs$,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              final List<Song> _songs = snapshot.data;
              return TextField(
                controller: _textEditingController,
                cursorColor: Color(0xFF274D85),
                decoration: InputDecoration(
                  disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFD9EAF1).withOpacity(0.7),
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFD9EAF1).withOpacity(0.7),
                    ),
                  ),
                ),
                style: TextStyle(
                  color: Color(0xFF274D85),
                  fontSize: 22.0,
                ),
                autofocus: true,
                onChanged: (String value) {
                  _searchScreenBloc.updateFilteredSongs(value, _songs);
                },
              );
            },
          ),
        ),
        body: StreamBuilder<List<Song>>(
          stream: _searchScreenBloc.filteredSongs$,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final List<Song> _filteredSongs = snapshot.data;

            if (_filteredSongs.length == 0) {
              return Center(
                child: Text(
                  "Enter proper keywords to start searching",
                  style: TextStyle(
                    fontSize: 22.0,
                    color: Color(0xFF274D85),
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }

            return ListView.builder(
              key: UniqueKey(),
              padding: const EdgeInsets.only(bottom: 30.0),
              physics: BouncingScrollPhysics(),
              itemCount: _filteredSongs.length,
              itemExtent: 100,
              itemBuilder: (BuildContext context, int index) {
                return StreamBuilder<MapEntry<PlayerState, Song>>(
                  stream: _globalBloc.musicPlayerBloc.playerState$,
                  builder: (BuildContext context,
                      AsyncSnapshot<MapEntry<PlayerState, Song>> snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    final PlayerState _state = snapshot.data.key;
                    final Song _currentSong = snapshot.data.value;
                    final bool _isSelectedSong =
                        _currentSong == _filteredSongs[index];
                    return GestureDetector(
                      onTap: () {
                        _globalBloc.musicPlayerBloc
                            .updatePlaylist(_filteredSongs);
                        switch (_state) {
                          case PlayerState.playing:
                            if (_isSelectedSong) {
                              _globalBloc.musicPlayerBloc
                                  .pauseMusic(_currentSong);
                            } else {
                              _globalBloc.musicPlayerBloc.stopMusic();
                              _globalBloc.musicPlayerBloc.playMusic(
                                _filteredSongs[index],
                              );
                            }
                            break;
                          case PlayerState.paused:
                            if (_isSelectedSong) {
                              _globalBloc.musicPlayerBloc
                                  .playMusic(_filteredSongs[index]);
                            } else {
                              _globalBloc.musicPlayerBloc.stopMusic();
                              _globalBloc.musicPlayerBloc.playMusic(
                                _filteredSongs[index],
                              );
                            }
                            break;
                          case PlayerState.stopped:
                            _globalBloc.musicPlayerBloc
                                .playMusic(_filteredSongs[index]);
                            break;
                          default:
                            break;
                        }
                      },
                      child: SongTile(
                        song: _filteredSongs[index],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
