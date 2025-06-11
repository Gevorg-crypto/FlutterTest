import 'package:hive/hive.dart';

class FavoritesService {
  static const String boxName = 'favoritesBox';

  late Box _box;

  FavoritesService._privateConstructor();

  static final FavoritesService _instance = FavoritesService._privateConstructor();

  factory FavoritesService() {
    return _instance;
  }

  Future<void> init() async {
    _box = Hive.box(boxName);
  }

  List<int> getFavorites() {
    return _box.get('favorites', defaultValue: <int>[])!.cast<int>();
  }

  Future<void> addFavorite(int characterId) async {
    final favorites = getFavorites();
    if (!favorites.contains(characterId)) {
      favorites.add(characterId);
      await _box.put('favorites', favorites);
    }
  }

  Future<void> removeFavorite(int characterId) async {
    final favorites = getFavorites();
    if (favorites.contains(characterId)) {
      favorites.remove(characterId);
      await _box.put('favorites', favorites);
    }
  }

  bool isFavorite(int characterId) {
    final favorites = getFavorites();
    return favorites.contains(characterId);
  }
}
