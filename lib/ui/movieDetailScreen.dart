import 'package:cinebox/models/movie_result.dart';
import 'package:cinebox/ui/rankDisplayWidget.dart';
import 'package:flutter/material.dart';
import 'package:rubber/rubber.dart';
import 'package:transparent_image/transparent_image.dart';

class MovieDetailScreen extends StatefulWidget {
  final Result movie;

  MovieDetailScreen({@required this.movie});

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen>
    with SingleTickerProviderStateMixin {
  RubberAnimationController _controller;

  @override
  void initState() {
    _controller = RubberAnimationController(
      vsync: this,
      lowerBoundValue: AnimationControllerValue(pixel: 210),
      halfBoundValue: AnimationControllerValue(pixel: 500),
      // upperBoundValue: AnimationControllerValue(pixel: 00),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: RubberBottomSheet(
        dragFriction: 0.5,
        menuLayer: Container(
          height: 300,
          color: Colors.transparent,
        ),
        lowerLayer: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * .8,
                  child: Hero(
                    tag: widget.movie.hashCode,
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      fit: BoxFit.fitHeight,
                      image: widget.movie.backdropPath != null
                          ? 'https://image.tmdb.org/t/p/w342${widget.movie.posterPath}'
                          : 'https://www.movieinsider.com/images/none_175px.jpg',
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.black,
                  ),
                )
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Icon(
                      Icons.cancel,
                      size: 50,
                      color: Colors.black,
                    ),
                  ),
                  shape: CircleBorder(),
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        upperLayer: Container(
          // height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 60,
                  height: 3,
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: RankDisplayWidget(
                    widget.movie.voteAverage,
                    size: 25,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          'Bookmark',
                          style: TextStyle(
                            // fontSize: 19,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onPressed: () {},
                    ),
                    FlatButton(
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          'Buy Tickets',
                          style: TextStyle(
                            // fontSize: 19,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  widget.movie.overview.toString(),
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 19,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(25),
          ),
        ), // The bottomsheet content (Widget)
        animationController: _controller, // The one we created earlier
      ),
    );
  }
}
