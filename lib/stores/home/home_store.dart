import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:verbal_expressions/verbal_expressions.dart';
import '../../models/movie_option.dart';
import '../../models/movie_result.dart';

part 'home_store.g.dart';

// // We expose this to be used throughout our project
class HomeStore = _HomeStore with _$HomeStore;

const String API_KEY = "someKey";
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

  static ObservableList<Result> emptyResult = ObservableList.of([]);

  List<MoveOption> movieOptions = [
    MoveOption("TopRated", MovieList.TopRated),
    MoveOption("NowPlaying", MovieList.NowPlaying),
    MoveOption("Popular", MovieList.Popular),
    MoveOption("Upcoming", MovieList.Upcoming)
  ];

  @observable
  MoveOption selectedMovieOption;

  @observable
  ObservableList<Result> movies = emptyResult;

  @computed
  int get moviesCount => movies.length;

  @action
  Future initialise() async {
    return await getMovies(movieOptions.first);
  }

  @action
  Future getMovies(MoveOption option) async {
    if (selectedMovieOption != null &&
        selectedMovieOption.movieType == option.movieType) return;

    selectedMovieOption = option;
    String urlToUse;

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
      movies.clear();
      var response = await dio.get(newUrl);
      if (response.statusCode != 200) {
        movies.clear();
        return;
      }

      movies.addAll((MovieResult.fromJson(response.data)?.results));
    } catch (e) {
      movies.clear();
    }
  }
}
