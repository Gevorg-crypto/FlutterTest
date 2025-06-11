import 'package:mobx/mobx.dart';
import '../models/character.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';
import '../services/favorites_service.dart';

part 'favorites_store.g.dart';

class FavoritesStore = _FavoritesStore with _$FavoritesStore;

enum SortOption { name, status, species }

abstract class _FavoritesStore with Store {
  final FavoritesService _favoritesService = FavoritesService();
  final ApiService _apiService = ApiService();
  final CacheService _cacheService = CacheService();

  @observable
  ObservableList<Character> allCharacters = ObservableList<Character>();

  @observable
  ObservableList<Character> favoriteCharacters = ObservableList<Character>();

  @observable
  bool isLoading = true;

  @observable
  SortOption sortOption = SortOption.name;

  @action
  Future<void> init() async {
    _favoritesService.init();
    await _loadFavoritesFromCache();
  }

  @action
  Future<void> _loadFavoritesFromCache() async {
    isLoading = true;
    final favIds = _favoritesService.getFavorites();
    final allChars = _cacheService.getAllCachedCharacters();
    allCharacters = ObservableList.of(allChars);
    favoriteCharacters = ObservableList.of(
      allChars.where((c) => favIds.contains(c.id)).toList(),
    );
    _sortFavorites();
    isLoading = false;
  }

  @action
  void _sortFavorites() {
    final list = favoriteCharacters.toList();
    list.sort((a, b) {
      switch (sortOption) {
        case SortOption.status:
          return a.status.compareTo(b.status);
        case SortOption.species:
          return a.species.compareTo(b.species);
        case SortOption.name:
        default:
          return a.name.compareTo(b.name);
      }
    });
    favoriteCharacters = ObservableList.of(list);
  }

  @action
  void setSortOption(SortOption option) {
    sortOption = option;
    _sortFavorites();
  }

  @action
  Future<void> toggleFavorite(int characterId) async {
    if (_favoritesService.isFavorite(characterId)) {
      await _favoritesService.removeFavorite(characterId);
    } else {
      await _favoritesService.addFavorite(characterId);
    }
    _reloadFavorites();
  }

  @action
  void _reloadFavorites() {
    final favIds = _favoritesService.getFavorites();
    favoriteCharacters = ObservableList.of(
      allCharacters.where((c) => favIds.contains(c.id)).toList(),
    );
    _sortFavorites();
  }
}
