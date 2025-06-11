import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:rick_and_morty/main.dart';

import 'characters_page.dart';
import 'favorites_page.dart';
import '../stores/theme_store.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [const CharactersPage(), const FavoritesPage()];

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: IconButton(
                icon: Icon(
                  themeStore.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
                ),
                onPressed: () => themeStore.toggleTheme(),
              ),
            ),
          ],
        ),
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'All'),
            BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
          ],
        ),
      ),
    );
  }
}
