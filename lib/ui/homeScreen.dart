import 'package:cinebox/stores/home/home_store.dart';
import 'package:cinebox/ui/rankDisplayWidget.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_backdrop/flutter_backdrop.dart';
import "package:pull_to_refresh/pull_to_refresh.dart";
import 'package:flutter_mobx/flutter_mobx.dart';

class HomeScreen extends StatefulWidget {
  final HomeStore homestore = HomeStore();
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int pageCount = 1;
  AnimationController animController;
  RefreshController smController;
  Backdrop scaffold;

  HomeStore homestore;
  @override
  initState() {
    animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
      value: 1.0,
    );

    smController = RefreshController();
    homestore = widget.homestore;
    homestore.initialise();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    scaffold = Backdrop(
      appBarAnimatedLeadingMenuIcon: AnimatedIcons.close_menu,
      appBarTitle: Text('CineBox'),
      appBarActions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        )
      ],
      backLayer: _buildFilterOptions(context),
      // toggleFrontLayer: _toggleFrontLayer,
      frontLayer: Container(
        color: Colors.black,
        child: _buildPage(context),
      ),
      // frontHeader: null,
      frontHeaderHeight: 0,
      titleVisibleOnPanelClosed: false,
      // shape: null
    );

    return scaffold;
  }

  Widget _buildFilterOptions(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 40, 0, 40),
        child: ListView.builder(
          itemCount: homestore.movieOptions.length,
          itemBuilder: (_, index) {
            var option = homestore.movieOptions[index];
            return GestureDetector(
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      option.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(
                    left: 90,
                    right: 90,
                  ),
                  child: Container(
                    height: 3,
                    color: option == homestore.selectedMovieOption
                        ? Colors.white
                        : Colors.transparent,
                  ),
                ),
              ),
              onTap: () {
                homestore.getMovies(option);
                setState(() {
                  scaffold.close();
                });
              },
            );
          },
        ),
      ),
    );
  }

  Widget _getWelcomeBlock(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 100.0,
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 2.5),
            child: Text(
              'Get started',
              style: Theme.of(context).primaryTextTheme.headline,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 2.5, 10.0, 10.0),
            child: Text(
              'Welcome! Use this app to watch movies & TV shows.',
              style: Theme.of(context).primaryTextTheme.subhead,
            ),
          ),
        ),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _getRecommendedHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
      child: Text(
        homestore.selectedMovieOption.title,
        style: Theme.of(context).primaryTextTheme.title,
      ),
    );
  }

  Widget _getRecommendedList(BuildContext context) {
    return homestore.movies.length == 0
        ? Padding(
            padding: const EdgeInsets.all(100),
            child: SpinKitThreeBounce(
              color: Theme.of(context).primaryColor,
              size: 40,
            ),
          )
        : ListView.separated(
            itemCount: homestore.movies.length,
            itemBuilder: (context, index) => GestureDetector(
                  child: Card(
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    color: Colors.transparent,
                    child: Container(
                      height: 320.0,
                      child: Stack(
                        children: <Widget>[
                          _getDetailsBg(context),
                          _getMovieImage(context, index),
                          _getThumbbnail(context, index),
                          _getMovieDetails(context, index)
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => SimpleDialog(
                              title: Center(child: const Text('About')),
                              contentPadding: EdgeInsets.all(15),
                              children: <Widget>[
                                Text(
                                  homestore.movies[index].overview.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 19,
                                      fontStyle: FontStyle.italic),
                                )
                              ],
                            ));
                  },
                ),
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            separatorBuilder: (context, index) => Divider(height: 1),
            // ),
          );
  }

  Widget _getDetailsBg(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 33, 33, 33),
      margin: const EdgeInsets.fromLTRB(0, 180, 0, 0),
    );
  }

  Widget _getThumbbnail(BuildContext context, int index) {
    var selectedMovie = homestore.movies[index];

    return Container(
      width: 85,
      margin: const EdgeInsets.fromLTRB(5, 160, 0, 5),
      child: selectedMovie.posterPath != null
          ? FadeInImage.memoryNetwork(
              height: 155,
              fit: BoxFit.fitHeight,
              placeholder: kTransparentImage,
              image:
                  'https://image.tmdb.org/t/p/w154${selectedMovie.posterPath}',
            )
          : null,
    );
  }

  Widget _getMovieDetails(BuildContext context, int index) {
    var selectedMovie = homestore.movies[index];
    return Container(
      margin: const EdgeInsets.fromLTRB(100, 170, 10, 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FlatButton(
            color: Theme.of(context).primaryColor,
            child: Text(
              'ADD TO WISHLIST',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {},
          ),
          RankDisplayWidget(selectedMovie.voteAverage),
          Text(
            selectedMovie.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _getMovieImage(BuildContext context, int index) {
    var selectedMovie = homestore.movies[index];

    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            color: Colors.black.withOpacity(0.9),
            height: 200,
            child: Center(
              child: SpinKitCubeGrid(
                color: Colors.red,
                size: 40,
              ),
            ),
          ),
          Container(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: selectedMovie.backdropPath != null
                  ? 'https://image.tmdb.org/t/p/w780${selectedMovie.backdropPath}'
                  : 'https://www.movieinsider.com/images/none_175px.jpg',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(BuildContext context) {
    return Observer(
      builder: (_) => SmartRefresher(
            controller: smController,
            enablePullDown: false,
            enablePullUp: false,
            onRefresh: (f) {
              // homestore.getMovies(homestore.selectedMovieOption);
            },
            child: ListView(
              children: <Widget>[
                _getWelcomeBlock(context),
                _getRecommendedHeader(context),
                _getRecommendedList(context),
              ],
            ),
          ),
    );
  }
}
