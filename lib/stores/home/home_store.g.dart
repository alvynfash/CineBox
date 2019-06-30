// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars

mixin _$HomeStore on _HomeStore, Store {
  Computed<int> _$moviesCountComputed;

  @override
  int get moviesCount =>
      (_$moviesCountComputed ??= Computed<int>(() => super.moviesCount)).value;

  final _$selectedMovieOptionAtom =
      Atom(name: '_HomeStore.selectedMovieOption');

  @override
  MoveOption get selectedMovieOption {
    _$selectedMovieOptionAtom.reportObserved();
    return super.selectedMovieOption;
  }

  @override
  set selectedMovieOption(MoveOption value) {
    _$selectedMovieOptionAtom.context
        .checkIfStateModificationsAreAllowed(_$selectedMovieOptionAtom);
    super.selectedMovieOption = value;
    _$selectedMovieOptionAtom.reportChanged();
  }

  final _$moviesAtom = Atom(name: '_HomeStore.movies');

  @override
  ObservableList<Result> get movies {
    _$moviesAtom.reportObserved();
    return super.movies;
  }

  @override
  set movies(ObservableList<Result> value) {
    _$moviesAtom.context.checkIfStateModificationsAreAllowed(_$moviesAtom);
    super.movies = value;
    _$moviesAtom.reportChanged();
  }

  final _$initialiseAsyncAction = AsyncAction('initialise');

  @override
  Future<dynamic> initialise() {
    return _$initialiseAsyncAction.run(() => super.initialise());
  }

  final _$getMoviesAsyncAction = AsyncAction('getMovies');

  @override
  Future<dynamic> getMovies(MoveOption option) {
    return _$getMoviesAsyncAction.run(() => super.getMovies(option));
  }
}
