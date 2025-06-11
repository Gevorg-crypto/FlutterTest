import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../models/character.dart';
import '../services/api_service.dart';
import '../stores/favorites_store.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final FavoritesStore _store = FavoritesStore();

  @override
  void initState() {
    super.initState();
    _store.init();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (_store.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_store.favoriteCharacters.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('My Favorites')),
            body: const Center(child: Text('No favorites yet.')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('My Favorites'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: DropdownButton<SortOption>(
                  value: _store.sortOption,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                  dropdownColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[800]
                          : Colors.white,
                  underline: const SizedBox(),
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                  onChanged: (SortOption? newValue) {
                    if (newValue != null) {
                      _store.setSortOption(newValue);
                    }
                  },
                  items: const [
                    DropdownMenuItem(
                        value: SortOption.name, child: Text('Sort by Name')),
                    DropdownMenuItem(
                        value: SortOption.status,
                        child: Text('Sort by Status')),
                    DropdownMenuItem(
                        value: SortOption.species,
                        child: Text('Sort by Species')),
                  ],
                ),
              ),
            ],
          ),
          body: ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: _store.favoriteCharacters.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final character = _store.favoriteCharacters[index];
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  leading: FutureBuilder<Uint8List>(
                    future: ApiService().getImage(character.image),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
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
                  subtitle:
                      Text('${character.status} — ${character.species}'),
                  trailing: IconButton(
                    icon:
                        const Icon(Icons.star, color: Colors.amber, size: 40),
                    onPressed: () {
                      _store.toggleFavorite(character.id);
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
