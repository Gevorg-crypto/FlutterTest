import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../models/character.dart';
import '../services/api_service.dart';
import '../services/favorites_service.dart';
import '../widgets/animated_favorite_star.dart';

class CharactersPage extends StatefulWidget {
  const CharactersPage({super.key});

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  final FavoritesService _favoritesService = FavoritesService();
  final ApiService _apiService = ApiService();

  List<Character> characters = [];
  bool isLoading = true;
  bool _isLoadingMore = false;
  String? errorMessage;

  int _currentPage = 1;
  bool _hasMore = true;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _favoritesService.init();
    _loadCharacters();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoadingMore &&
          _hasMore) {
        _loadMoreCharacters();
      }
    });
  }

  Future<void> _loadCharacters() async {
    try {
      final fetchedCharacters = await _apiService.fetchCharacters(
        page: _currentPage,
      );
      setState(() {
        characters = fetchedCharacters;
        isLoading = false;
        _hasMore = fetchedCharacters.isNotEmpty;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading characters: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _loadMoreCharacters() async {
    setState(() {
      _isLoadingMore = true;
      _currentPage += 1;
    });

    try {
      final fetchedCharacters = await _apiService.fetchCharacters(
        page: _currentPage,
      );
      setState(() {
        characters.addAll(fetchedCharacters);
        _isLoadingMore = false;
        if (fetchedCharacters.isEmpty) {
          _hasMore = false;
        }
      });
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  void toggleFavorite(int characterId) async {
    if (_favoritesService.isFavorite(characterId)) {
      await _favoritesService.removeFavorite(characterId);
    } else {
      await _favoritesService.addFavorite(characterId);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(child: Text(errorMessage!));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Characters List')),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: characters.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == characters.length) {
            return const Padding(
              padding: EdgeInsets.all(8),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final character = characters[index];
          final isFavorite = _favoritesService.isFavorite(character.id);

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: FutureBuilder<Uint8List>(
                future: ApiService().getImage(character.image),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      width: 50,
                      height: 50,
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Icon(Icons.broken_image, size: 50);
                  } else if (snapshot.hasData) {
                    return Image.memory(
                      snapshot.data!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    );
                  } else {
                    return const Icon(Icons.image, size: 50);
                  }
                },
              ),
              title: Text(character.name),
              subtitle: Text('${character.status} — ${character.species}'),
              trailing: AnimatedFavoriteStar(
                isFavorite: isFavorite,
                onTap: () => toggleFavorite(character.id),
              ),
            ),
          );
        },
      ),
    );
  }
}
