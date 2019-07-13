import 'package:flutter/material.dart';
import 'package:music_app/src/blocs/global.dart';
import 'package:music_app/src/common/empty_screen.dart';
import 'package:music_app/src/models/album.dart';
import 'package:music_app/src/ui/albums/album_tile.dart';
import 'package:music_app/src/ui/albums/specific_album_screen.dart';
import 'package:provider/provider.dart';

class AlbumsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    return Scaffold(
      body: StreamBuilder<List<Album>>(
        stream: _globalBloc.musicPlayerBloc.albums$,
        builder: (BuildContext context, AsyncSnapshot<List<Album>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final List<Album> _albums = snapshot.data;
          if (_albums.length == 0) {
            return EmptyScreen(
              text: "You do not have any albums on your device.",
            );
          }

          return GridView.builder(
            key: PageStorageKey<String>("Albums Screen"),
            padding: EdgeInsets.only(
                left: 16.0, right: 16.0, top: 16.0, bottom: 150),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
            ),
            physics: BouncingScrollPhysics(),
            itemCount: _albums.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Provider<Album>.value(
                              value: _albums[index],
                              child: SpecificAlbumScreen(),
                            ),
                      ));
                },
                child: AlbumTile(
                  album: _albums[index],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
