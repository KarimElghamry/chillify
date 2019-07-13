import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:music_app/src/blocs/global.dart';
import 'package:music_app/src/ui/albums/albums_screen.dart';
import 'package:music_app/src/ui/all_songs/all_songs_screen.dart';
import 'package:music_app/src/ui/favorites/favorites_screen.dart';
import 'package:music_app/src/ui/music_homepage/bottom_panel.dart';
import 'package:music_app/src/ui/now_playing/now_playing_screen.dart';
import 'package:music_app/src/ui/search/search_screen.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MusicHomepage extends StatefulWidget {
  @override
  _MusicHomepageState createState() => _MusicHomepageState();
}

class _MusicHomepageState extends State<MusicHomepage> {
  PanelController _panelController;

  @override
  void initState() {
    _panelController = PanelController();

    super.initState();
  }

  @override
  void dispose() {
    _panelController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _radius = 25.0;
    return WillPopScope(
      onWillPop: () {
        if (!_panelController.isPanelClosed()) {
          _panelController.close();
        } else {
          _showExitDialog();
        }
      },
      child: Scaffold(
        body: SlidingUpPanel(
          panel: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(_radius),
              topRight: Radius.circular(_radius),
            ),
            child: NowPlayingScreen(controller: _panelController),
          ),
          controller: _panelController,
          minHeight: 110,
          maxHeight: MediaQuery.of(context).size.height,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(_radius),
            topRight: Radius.circular(_radius),
          ),
          collapsed: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(_radius),
                topRight: Radius.circular(_radius),
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [
                  0.0,
                  0.7,
                ],
                colors: [
                  Color(0xFF47ACE1),
                  Color(0xFFDF5F9D),
                ],
              ),
            ),
            child: BottomPanel(controller: _panelController),
          ),
          body: DefaultTabController(
            length: 3,
            initialIndex: 0,
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text(
                  "Chillify",
                  style: TextStyle(
                    color: Color(0xFF274D85),
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                bottom: TabBar(
                  indicatorColor: Color(0xFFD9EAF1),
                  labelColor: Color(0xFF274D85),
                  unselectedLabelColor: Color(0xFF274D85).withOpacity(0.6),
                  tabs: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Songs",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Albums",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Favorites",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchScreen(),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.search,
                        color: Color(0xFF274D85),
                        size: 35,
                      ),
                    ),
                  )
                ],
                elevation: 0.0,
                backgroundColor: Colors.transparent,
              ),
              body: TabBarView(
                key: UniqueKey(),
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  AllSongsScreen(),
                  AlbumsScreen(),
                  FavoritesScreen(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showExitDialog() {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Chillify",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          content: Text(
            "Are you sure you want to close the app?",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              textColor: Color(0xFFDF5F9D),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("NO"),
            ),
            FlatButton(
              textColor: Color(0xFFDF5F9D),
              onPressed: () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                _globalBloc.dispose();
              },
              child: Text("YES"),
            ),
          ],
        );
      },
    );
  }
}
