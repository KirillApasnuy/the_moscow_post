import 'package:flutter/material.dart';
import 'package:the_moscow_post/navigation_menus.dart';
import 'package:the_moscow_post/utils/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const NavigationMenu(),
    );
  }
}
