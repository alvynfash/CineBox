import 'package:json_annotation/json_annotation.dart';

// part 'movie.g.dart';

@JsonSerializable()
class Movie {
    double voteAverage;
    // int voteCount;
    // int id;
    bool video;
    String title;
    // double popularity;
    String posterPath;
    String originalTitle;
    // List<int> genreIds;
    String backdropPath;
    bool adult;
    String overview;
    String releaseDate;

    Movie({
        this.voteAverage,
        // this.voteCount,
        // this.id,
        this.video,
        this.title,
        // this.popularity,
        this.posterPath,
        this.originalTitle,
        // this.genreIds,
        this.backdropPath,
        this.adult,
        this.overview,
        this.releaseDate,
    });

    factory Movie.fromJson(Map<String, dynamic> json) => Movie(
      voteAverage: json['vote_average'] as double,
      video: json['video'] as bool,
      title: json['title'] as String,
      posterPath: json['poster_path'] as String,
      originalTitle: json['original_title'] as String,
      backdropPath: json['backdrop_path'] as String,
      adult: json['adult'] as bool,
      overview: json['overview'] as String,
      releaseDate: json['release_date'] as String);

    Map<String, dynamic> toJson() => <String, dynamic>{
      'vote_average': voteAverage,
      'video': video,
      'title': title,
      'poster_path': posterPath,
      'original_title': originalTitle,
      'backdrop_path': backdropPath,
      'adult': adult,
      'overview': overview,
      'release_date': releaseDate
    };
 }