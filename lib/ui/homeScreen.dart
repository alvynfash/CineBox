import 'dart:async';

import 'package:cinebox/models/movie.dart';
import 'package:cinebox/ui/rankDisplayWidget.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_backdrop/flutter_backdrop.dart';
// import 'package:backdrop/backdrop.dart';

const String ApiKey = "api_key=1a43f1f22e3cf15ce2cfd8ca5af13e6f";

final String topRatedUrl =
    "https://api.themoviedb.org/3/movie/top_rated?page=1&language=en-US&$ApiKey";

final String nowPlayingUrl =
    "https://api.themoviedb.org/3/movie/now_playing?page=1&language=en-US&$ApiKey";

final String popularUrl =
    "https://api.themoviedb.org/3/movie/popular?page=1&language=en-US&$ApiKey";

final String upcomingUrl =
    "https://api.themoviedb.org/3/movie/upcoming?page=1&language=en-US&$ApiKey";

enum MovieList { TopRated, NowPlaying, Popular, Upcoming }

class MoveOption {
  String title;
  MovieList movieType;

  MoveOption(this.title, this.movieType);
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  List<Movie> movies = new List<Movie>();
  List<MoveOption> options = new List<MoveOption>();
  MoveOption selectedMovieOption;
  AnimationController animController;
  Backdrop scaffold;

  @override
  initState() {
    animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
      value: 1.0,
    );

    options.add(MoveOption("TopRated", MovieList.TopRated));
    options.add(MoveOption("NowPlaying", MovieList.NowPlaying));
    options.add(MoveOption("Popular", MovieList.Popular));
    options.add(MoveOption("Upcoming", MovieList.Upcoming));

    getMovies(options.first.movieType);
    setState(() {
      super.initState();
    });
  }

  Future getMovies(MovieList movieType) async {
    String resultsKey = "results";
    String urlToUse;

    var dio = new Dio();
    var mylist = new List<Movie>();

    setState(() {
      selectedMovieOption = options.firstWhere((x) => x.movieType == movieType);
      movies = mylist;
    });

    switch (movieType) {
      case MovieList.TopRated:
        urlToUse = topRatedUrl;
        break;

      case MovieList.NowPlaying:
        urlToUse = nowPlayingUrl;
        break;

      case MovieList.Popular:
        urlToUse = popularUrl;
        break;

      case MovieList.Upcoming:
        urlToUse = upcomingUrl;
        break;
    }
    var response = await dio.get(urlToUse);
    if (response.statusCode == 200) {
      try {
        mylist.addAll(
          List.from(response.data[resultsKey]).map(
            (f) => Movie.fromJson(f),
          ),
        );

      } catch (e) {} finally {
        setState(() {
          movies = mylist;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // scaffold = BackdropScaffold(
    //     title: Text('CineBox'),
    //     // controller: animController,
    //     headerHeight: 350,
    //     actions: <Widget>[
    //       IconButton(
    //         icon: Icon(Icons.search),
    //         onPressed: () {},
    //       )
    //     ],
    //     body: Container(
    //       color: Colors.black,
    //       child: _buildPage(context),
    //     ),
    //     backpanel: _buildFilterOptions(context));

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
          itemCount: options.length,
          itemBuilder: (_, index) {
            var option = options[index];
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
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 10),
                    //   child: Icon(
                    //     Icons.check_circle,
                    //     color: option == selectedMovieOption
                    //         ? Colors.white
                    //         : Colors.transparent,
                    //   ),
                    // ),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(
                    left: 90,
                    right: 90,
                  ),
                  child: Container(
                    height: 3,
                    color: option == selectedMovieOption
                        ? Colors.white
                        : Colors.transparent,
                  ),
                ),
              ),
              onTap: () {
                setState(() {
                  scaffold.close();
                  getMovies(option.movieType);
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
        selectedMovieOption.title,
        style: Theme.of(context).primaryTextTheme.title,
      ),
    );
  }

  Widget _getRecommendedList(BuildContext context) {
    return movies.length == 0
        ? Padding(
            padding: const EdgeInsets.all(100),
            child: SpinKitThreeBounce(
              color: Theme.of(context).primaryColor,
              size: 40,
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(5.0),
            child: ListView.separated(
              itemCount: movies.length,
              itemBuilder: (context, index) => GestureDetector(
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
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
                                    movies[index].overview.toString(),
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
            ),
          );
  }

  Widget _getDetailsBg(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 33, 33, 33),
      margin: const EdgeInsets.fromLTRB(0, 180, 0, 0),
    );
  }

  Widget _getThumbbnail(BuildContext context, int index) {
    var selectedMovie = movies[index];

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
    var selectedMovie = movies[index];
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
    var selectedMovie = movies[index];

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
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _getWelcomeBlock(context),
                  _getRecommendedHeader(context),
                  _getRecommendedList(context),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
