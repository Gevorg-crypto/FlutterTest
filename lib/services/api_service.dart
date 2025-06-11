import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../models/character.dart';

class ApiService {
  // ...
  final String imagesBoxName = 'imagesBox'; // Новый box для изображений

  final String baseUrl = 'https://rickandmortyapi.com/api';
  String cacheKey(int page) => 'cachedCharacters_page_$page';
  final String boxName = 'favoritesBox';

  Future<List<Character>> fetchCharacters({int page = 1}) async {
    final box = Hive.box(boxName);
    final cacheKeyForPage = cacheKey(page);
    final cachedData = box.get(cacheKeyForPage);
    if (cachedData != null && cachedData is List && cachedData.isNotEmpty) {
      // Возвращаем из кэша
      return (cachedData as List)
          .map((item) => Character.fromMap(Map<String, dynamic>.from(item)))
          .toList();
    }
    // Если нет в кэше — делаем запрос
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/character?page=$page'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        final characters = results
            .map((json) => Character.fromJson(json))
            .toList();
        await _saveToCache(characters, page);
        return characters;
      } else {
        throw Exception('Failed to load characters');
      }
    } catch (e) {
      print('Error fetching from API: $e');
      // Если ошибка — пробуем вернуть из кэша (на всякий случай)
      final cachedData = box.get(cacheKeyForPage);
      if (cachedData != null && cachedData is List && cachedData.isNotEmpty) {
        print('Loaded characters from cache');
        return (cachedData as List)
            .map((item) => Character.fromMap(Map<String, dynamic>.from(item)))
            .toList();
      }
      rethrow;
    }
  }

  Future<void> _saveToCache(List<Character> characters, int page) async {
    final box = Hive.box(boxName);
    final mappedList = characters.map((c) => c.toMap()).toList();
    await box.put(cacheKey(page), mappedList);
  }

  Future<List<Character>> _loadFromCache() async {
    final box = Hive.box(boxName);
    final cachedList = box.get(cacheKey, defaultValue: <Map>[]);

    if (cachedList == null || cachedList.isEmpty) {
      return [];
    }

    return (cachedList as List)
        .map((item) => Character.fromMap(Map<String, dynamic>.from(item)))
        .toList();
  }

  /// Получить изображение по url: сначала из кеша, если нет — скачать и закешировать
  Future<Uint8List> getImage(String url) async {
    final box = Hive.box(imagesBoxName);
    final cachedImage = box.get(url);
    if (cachedImage != null) {
      // Возвращаем из кеша
      if (cachedImage is Uint8List) {
        return cachedImage;
      } else if (cachedImage is List<int>) {
        return Uint8List.fromList(cachedImage);
      }
    }
    // Скачиваем изображение
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      await saveImageToCache(url, bytes);
      return bytes;
    } else {
      throw Exception('Failed to load image');
    }
  }

  /// Сохранить изображение в кеш
  Future<void> saveImageToCache(String url, Uint8List bytes) async {
    final box = Hive.box(imagesBoxName);
    await box.put(url, bytes.toList());
  }
}

