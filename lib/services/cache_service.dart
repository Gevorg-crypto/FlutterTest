import 'package:hive/hive.dart';
import 'dart:typed_data';
import '../models/character.dart';

class CacheService {
  static const String charactersBoxName = 'favoritesBox';
  static const String imagesBoxName = 'imagesBox';

  /// Получить всех персонажей из кеша (со всех страниц)
  List<Character> getAllCachedCharacters() {
    final box = Hive.box(charactersBoxName);
    final allCharactersList = <Character>[];
    for (var key in box.keys) {
      if (key.toString().startsWith('cachedCharacters_page_')) {
        final cachedList = box.get(key);
        if (cachedList != null && cachedList is List && cachedList.isNotEmpty) {
          allCharactersList.addAll(
            (cachedList)
                .map((item) => Character.fromMap(Map<String, dynamic>.from(item)))
                .toList(),
          );
        }
      }
    }
    return allCharactersList;
  }

  /// Получить персонажей из кеша по номеру страницы
  List<Character> getCachedCharactersByPage(int page) {
    final box = Hive.box(charactersBoxName);
    final key = 'cachedCharacters_page_$page';
    final cachedList = box.get(key);
    if (cachedList != null && cachedList is List && cachedList.isNotEmpty) {
      return (cachedList)
          .map((item) => Character.fromMap(Map<String, dynamic>.from(item)))
          .toList();
    }
    return [];
  }

  /// Получить изображение из кеша по url
  Uint8List? getCachedImage(String url) {
    final box = Hive.box(imagesBoxName);
    final cachedImage = box.get(url);
    if (cachedImage != null) {
      if (cachedImage is Uint8List) return cachedImage;
      if (cachedImage is List<int>) return Uint8List.fromList(cachedImage);
    }
    return null;
  }

  /// Сохранить изображение в кеш
  Future<void> saveImageToCache(String url, Uint8List bytes) async {
    final box = Hive.box(imagesBoxName);
    await box.put(url, bytes);
  }
}
