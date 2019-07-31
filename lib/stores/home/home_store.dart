import 'package:dio/dio.dart';
// import 'package:flutter/rendering.dart';
import 'package:mobx/mobx.dart';
import 'package:verbal_expressions/verbal_expressions.dart';
import '../../models/movie_option.dart';
import '../../models/movie_result.dart';

part 'home_store.g.dart';

// // We expose this to be used throughout our project
class HomeStore = _HomeStore with _$HomeStore;

const String API_KEY = "api_key=1a43f1f22e3cf15ce2cfd8ca5af13e6f";
var dio = new Dio();

// Our store class
abstract class _HomeStore with Store {
  final String topRatedUrl =
      "https://api.themoviedb.org/3/movie/top_rated?page=1&language=en-US&$API_KEY";

  final String nowPlayingUrl =
      "https://api.themoviedb.org/3/movie/now_playing?page=1&language=en-US&$API_KEY";

  final String popularUrl =
      "https://api.themoviedb.org/3/movie/popular?page=1&language=en-US&$API_KEY";

  final String upcomingUrl =
      "https://api.themoviedb.org/3/movie/upcoming?page=1&language=en-US&$API_KEY";

  List<Result> emptyResult = new List<Result>();

  List<MoveOption> movieOptions = [
    MoveOption("What's Hot", MovieList.NowPlaying),
    MoveOption("Top Rated", MovieList.TopRated),
    MoveOption("Popular", MovieList.Popular),
    MoveOption("Upcoming", MovieList.Upcoming)
  ];

  @observable
  ObservableList<Map<MoveOption, List<Result>>> movieSections =
      ObservableList.of([]);

  @computed
  int get movieSectionsCount => movieSections.length;

  @action
  Future initialise() async {
    isBusy = true;

    await getMovies(movieOptions[0]);
    await getMovies(movieOptions[1]);
    await getMovies(movieOptions[2]);
    await getMovies(movieOptions[3]);

    // movieSections
    //   ..clear()
    //   // ..add({movieOptions[1]: nowPlayingMovies});
    //   // ..add({movieOptions[2]: emptyResult});
    //   // ..add({movieOptions[0]: emptyResult});
    //   ..add({movieOptions[3]: upcomingMovies});

    isBusy = false;
  }

  @action
  Future getMovies(MoveOption option) async {
    String urlToUse;
    List<Result> listToUse;

    switch (option.movieType) {
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

    var expression = VerbalExpression()
      ..find("?")
      ..beginCapture()
      ..anythingBut("&")
      ..endCapture();

    var newUrl = urlToUse.replaceAll(expression.toRegExp(), "?page=1");

    try {
      listToUse = [];
      var response = await dio.get(newUrl);
      if (response.statusCode != 200) {
        listToUse.clear();
        return;
      }

      listToUse.addAll((MovieResult.fromJson(response.data)?.results));
      movieSections
          .add({movieOptions.firstWhere((mo) => mo == option): listToUse});
    } catch (e) {
      listToUse.clear();
    }
  }

  @observable
  bool isBusy = false;
}
//
