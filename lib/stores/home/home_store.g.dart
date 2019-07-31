// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars

mixin _$HomeStore on _HomeStore, Store {
  Computed<int> _$movieSectionsCountComputed;

  @override
  int get movieSectionsCount => (_$movieSectionsCountComputed ??=
          Computed<int>(() => super.movieSectionsCount))
      .value;

  final _$movieSectionsAtom = Atom(name: '_HomeStore.movieSections');

  @override
  ObservableList<Map<MoveOption, List<Result>>> get movieSections {
    _$movieSectionsAtom.reportObserved();
    return super.movieSections;
  }

  @override
  set movieSections(ObservableList<Map<MoveOption, List<Result>>> value) {
    _$movieSectionsAtom.context
        .checkIfStateModificationsAreAllowed(_$movieSectionsAtom);
    super.movieSections = value;
    _$movieSectionsAtom.reportChanged();
  }

  final _$isBusyAtom = Atom(name: '_HomeStore.isBusy');

  @override
  bool get isBusy {
    _$isBusyAtom.reportObserved();
    return super.isBusy;
  }

  @override
  set isBusy(bool value) {
    _$isBusyAtom.context.checkIfStateModificationsAreAllowed(_$isBusyAtom);
    super.isBusy = value;
    _$isBusyAtom.reportChanged();
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
