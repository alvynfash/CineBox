import 'package:cinebox/models/movie_option.dart';
import 'package:cinebox/models/movie_result.dart';
import 'package:cinebox/stores/home/home_store.dart';
import 'package:cinebox/ui/rankDisplayWidget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_backdrop/flutter_backdrop.dart';
import "package:pull_to_refresh/pull_to_refresh.dart";
import 'package:flutter_mobx/flutter_mobx.dart';

import 'movieDetailScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int pageCount = 1;
  AnimationController animController;
  RefreshController smController;
  Backdrop scaffold;
  final HomeStore homestore = HomeStore();

  @override
  initState() {
    animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
      value: 1.0,
    );
    smController = RefreshController();
    homestore.initialise();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(
        builder: (_) => CustomScrollView(
          slivers: <Widget>[
            // SliverAppBar(
            //   title: Text('SliverAppBar'),
            //   backgroundColor: Colors.blue.withOpacity(.125),
            //   expandedHeight: 0,
            //   floating: true,
            //   // pinned: true,
            //   // flexibleSpace: FlexibleSpaceBar(
            //   //   background: Image.asset('assets/forest.jpg', fit: BoxFit.cover),
            //   // ),
            // ),

            // SliverFillRemaining(
            //   child: Container(
            //     color: Colors.blue.withOpacity(.15),
            //     child: _buildPage(context),
            //   ),
            // ),

            SliverFixedExtentList(
              itemExtent: MediaQuery.of(context).size.height,
              delegate: SliverChildListDelegate(
                [
                  ListView(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height,
                        child: homestore.isBusy
                            ? Center(
                                child: SpinKitThreeBounce(
                                  color: Theme.of(context).primaryColor,
                                  size: 40,
                                ),
                              )
                            : _getMovieLists(context),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  Widget _buildFilterOptions(BuildContext context) {
    // return Container(
    //   color: Theme.of(context).primaryColor,
    //   child: Padding(
    //     padding: const EdgeInsets.fromLTRB(0, 40, 0, 40),
    //     child: ListView.builder(
    //       itemCount: homestore.movieOptions.length,
    //       // shrinkWrap: true,
    //       itemBuilder: (_, index) {
    //         var option = homestore.movieOptions[index];
    //         return GestureDetector(
    //           child: ListTile(
    //             title: Row(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: <Widget>[
    //                 Text(
    //                   option.title,
    //                   textAlign: TextAlign.center,
    //                   style: TextStyle(
    //                     color: Colors.white,
    //                     fontSize: 25,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //             subtitle: Padding(
    //               padding: const EdgeInsets.only(
    //                 left: 90,
    //                 right: 90,
    //               ),
    //               child: Container(
    //                 height: 3,
    //                 color: option == homestore.selectedMovieOption
    //                     ? Colors.white
    //                     : Colors.transparent,
    //               ),
    //             ),
    //           ),
    //           onTap: () {
    //             homestore.getMovies(option);
    //             setState(() {
    //               scaffold.close();
    //             });
    //           },
    //         );
    //       },
    //     ),
    //   ),
    // );
  }

  Widget _getWelcomeBlock(BuildContext context) {
    return Dismissible(
      key: GlobalKey(debugLabel: "welcomeBlock"),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 24, 12, 8),
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
      ),
    );
  }

  Widget _getMovieLists(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 0, bottom: 8),
      child: ListView.separated(
        itemCount: homestore.movieSectionsCount,
        itemBuilder: (context, index) => MovieSection(
          homestore.movieSections[index],
        ),
        separatorBuilder: (context, index) => Container(
          height: 20,
        ),
      ),
    );
  }

  void showDetails(Result movie) {
    // Navigator.of(context).push(
    //     MaterialPageRoute(builder: (_) => MovieDetailScreen(movie: movie)));

    Navigator.of(context).push(
      PageRouteBuilder<MovieDetailScreen>(
        pageBuilder: (_, __, ___) => MovieDetailScreen(movie: movie),
        transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  Widget MovieSection(Map<MoveOption, List<Result>> option) {
    bool isNowPlaying = option.keys.first.movieType == MovieList.NowPlaying;
    return Container(
      height: isNowPlaying ? 320 : 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            option.keys.first.title,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Padding(
              padding: isNowPlaying
                  ? const EdgeInsets.only(top: 24)
                  : const EdgeInsets.only(top: 16),
              child: Container(
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: option.values.first.length,
                  itemBuilder: (context, index) => MovieCell(
                    option.values.first[index],
                    isNormal: !isNowPlaying,
                  ),
                  separatorBuilder: (context, index) => Container(
                    width: isNowPlaying ? 20 : 10,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget MovieCell(Result movie, {bool isNormal = true}) {
    return InkWell(
      onTap: () => showDetails(movie),
      child: Container(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: isNormal ? 160 : 250,
                width: isNormal ? 120 : 160,
                child: movie.posterPath != null
                    ? Hero(
                        tag: movie.hashCode,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: FadeInImage.memoryNetwork(
                            fit: BoxFit.fill,
                            placeholder: kTransparentImage,
                            image: isNormal
                                ? 'https://image.tmdb.org/t/p/w185${movie.posterPath}'
                                : 'https://image.tmdb.org/t/p/w342${movie.posterPath}',
                          ),
                        ),
                      )
                    : null,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.5),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              isNormal
                  ? Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: SizedBox(
                            width: isNormal ? 120 : 160,
                            child: Text(
                              movie.title,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.fade,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            ),
                          ),
                        ),
                        RankDisplayWidget(movie.voteAverage),
                      ],
                    )
                  : Container(),
            ]),
      ),
    );
  }

  Widget _getMovieImage(BuildContext context, int index) {
    // var selectedMovie = homestore.movies[index];

    // return Container(
    //   child: Stack(
    //     children: <Widget>[
    //       Container(
    //         color: Colors.black.withOpacity(0.9),
    //         height: 200,
    //         child: Center(
    //           child: SpinKitCubeGrid(
    //             color: Colors.red,
    //             size: 40,
    //           ),
    //         ),
    //       ),
    //       Container(
    //         child: FadeInImage.memoryNetwork(
    //           placeholder: kTransparentImage,
    //           image: selectedMovie.backdropPath != null
    //               ? 'https://image.tmdb.org/t/p/w780${selectedMovie.backdropPath}'
    //               : 'https://www.movieinsider.com/images/none_175px.jpg',
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
