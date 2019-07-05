import 'package:pokemondex/custom_theme.dart';
import 'package:pokemondex/getPokemonData.dart';
import 'package:flutter/material.dart';
import 'package:pokemondex/themes.dart';


void main() {
  runApp(
    CustomTheme(
      initialThemeKey: MyThemeKeys.LIGHT,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex',
      theme: CustomTheme.of(context),
      home: HomePage(),
    );
  }
}