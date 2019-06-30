class MoveOption {
  String title;
  MovieList movieType;

  MoveOption(this.title, this.movieType);
}

enum MovieList { TopRated, NowPlaying, Popular, Upcoming }
