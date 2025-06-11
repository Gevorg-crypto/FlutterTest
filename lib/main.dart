import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'pages/main_page.dart';
import 'stores/theme_store.dart';

final themeStore = ThemeStore();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('favoritesBox');
  await Hive.openBox('imagesBox');
  await themeStore.loadTheme(); 
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: themeStore.themeMode,
        home: MainPage(),
      ),
    );
  }
}
