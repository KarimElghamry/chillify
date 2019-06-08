import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:music_app/src/models/album.dart';
import 'package:music_app/src/ui/now_playing/empty_album_art.dart';

class AlbumTile extends StatelessWidget {
  final Album _album;

  AlbumTile({@required Album album}) : _album = album;

  @override
  Widget build(BuildContext context) {
    final double _tileHeight = MediaQuery.of(context).size.height / 3;
    final double _radius = 10;

    return Stack(
      children: <Widget>[
        _album.art != null
            ? Container(
                height: _tileHeight,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(_album.art),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(_radius),
                ),
              )
            : EmptyAlbumArtContainer(
                albumArtSize: _tileHeight,
                iconSize: _tileHeight / 2,
                radius: _radius,
              ),
        Container(
          height: _tileHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_radius),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: [
                0.0,
                0.45,
              ],
              colors: [
                Colors.black.withOpacity(0.8),
                Colors.transparent,
              ],
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                flex: 9,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _album.name,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Divider(
                          height: 5,
                          color: Colors.transparent,
                        ),
                        Text(
                          parseArtists().toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8, top: 8.0),
                  child: Container(
                    height: 50.0,
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 24.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String parseArtists() {
    return _album.artist.split(";").reduce((String a, String b) {
      return a + " & " + b;
    });
  }
}
