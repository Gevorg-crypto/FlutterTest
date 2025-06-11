// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FavoritesStore on _FavoritesStore, Store {
  late final _$allCharactersAtom = Atom(
    name: '_FavoritesStore.allCharacters',
    context: context,
  );

  @override
  ObservableList<Character> get allCharacters {
    _$allCharactersAtom.reportRead();
    return super.allCharacters;
  }

  @override
  set allCharacters(ObservableList<Character> value) {
    _$allCharactersAtom.reportWrite(value, super.allCharacters, () {
      super.allCharacters = value;
    });
  }

  late final _$favoriteCharactersAtom = Atom(
    name: '_FavoritesStore.favoriteCharacters',
    context: context,
  );

  @override
  ObservableList<Character> get favoriteCharacters {
    _$favoriteCharactersAtom.reportRead();
    return super.favoriteCharacters;
  }

  @override
  set favoriteCharacters(ObservableList<Character> value) {
    _$favoriteCharactersAtom.reportWrite(value, super.favoriteCharacters, () {
      super.favoriteCharacters = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_FavoritesStore.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$sortOptionAtom = Atom(
    name: '_FavoritesStore.sortOption',
    context: context,
  );

  @override
  SortOption get sortOption {
    _$sortOptionAtom.reportRead();
    return super.sortOption;
  }

  @override
  set sortOption(SortOption value) {
    _$sortOptionAtom.reportWrite(value, super.sortOption, () {
      super.sortOption = value;
    });
  }

  late final _$initAsyncAction = AsyncAction(
    '_FavoritesStore.init',
    context: context,
  );

  @override
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  late final _$_loadFavoritesFromCacheAsyncAction = AsyncAction(
    '_FavoritesStore._loadFavoritesFromCache',
    context: context,
  );

  @override
  Future<void> _loadFavoritesFromCache() {
    return _$_loadFavoritesFromCacheAsyncAction.run(
      () => super._loadFavoritesFromCache(),
    );
  }

  late final _$toggleFavoriteAsyncAction = AsyncAction(
    '_FavoritesStore.toggleFavorite',
    context: context,
  );

  @override
  Future<void> toggleFavorite(int characterId) {
    return _$toggleFavoriteAsyncAction.run(
      () => super.toggleFavorite(characterId),
    );
  }

  late final _$_FavoritesStoreActionController = ActionController(
    name: '_FavoritesStore',
    context: context,
  );

  @override
  void _sortFavorites() {
    final _$actionInfo = _$_FavoritesStoreActionController.startAction(
      name: '_FavoritesStore._sortFavorites',
    );
    try {
      return super._sortFavorites();
    } finally {
      _$_FavoritesStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSortOption(SortOption option) {
    final _$actionInfo = _$_FavoritesStoreActionController.startAction(
      name: '_FavoritesStore.setSortOption',
    );
    try {
      return super.setSortOption(option);
    } finally {
      _$_FavoritesStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _reloadFavorites() {
    final _$actionInfo = _$_FavoritesStoreActionController.startAction(
      name: '_FavoritesStore._reloadFavorites',
    );
    try {
      return super._reloadFavorites();
    } finally {
      _$_FavoritesStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
allCharacters: ${allCharacters},
favoriteCharacters: ${favoriteCharacters},
isLoading: ${isLoading},
sortOption: ${sortOption}
    ''';
  }
}
