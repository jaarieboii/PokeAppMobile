import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pokemondex/pokemon.dart';
import 'package:pokemondex/pokemondetail.dart';
import 'package:pokemondex/custom_theme.dart';
import 'package:pokemondex/themes.dart';
import 'package:pokemondex/location.dart';



class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}


class HomePageState extends State<HomePage> {
  var url = "https://raw.githubusercontent.com/biuni/PokemonGo-Pokedex/master/pokedex.json";

  PokeInfo pokeInfo;

  PokeDetail pokeDetail;

  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    var res = await http.get(url);
    var decodedJson = jsonDecode(res.body);

    pokeInfo = PokeInfo.fromJson(decodedJson);
    print(pokeInfo.toJson());
    setState(() {});
  }
  void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
    CustomTheme.instanceOf(buildContext).changeTheme(key);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PokeDex"),
        backgroundColor: Colors.cyan,
      ),
      body: pokeInfo == null
          ? Center(
        child: CircularProgressIndicator(),
      )
          : GridView.count(
        crossAxisCount: 2,
        children: pokeInfo.pokemon
            .map((poke) =>
            Padding(
                padding: const EdgeInsets.all(2.0),
                child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PokeDetail(
                                    pokemon: poke,
                                  )));
                    },
                    child: Hero(
                      tag: poke.img,
                      child: Card(
                          elevation: 3.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                height: 100.0,
                                width: 100.0,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(poke.img))
                                ),
                              ),
                              Text(
                                poke.name,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                      ),))))
            ?.toList(),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
          ListTile(
            onTap: () {
              _changeTheme(context, MyThemeKeys.LIGHT);
            },
            title: Text("Light!"),
          ),
          ListTile(
            onTap: () {
              _changeTheme(context, MyThemeKeys.DARK);
            },
            title: Text("Dark!"),
          ),
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyLocation()));
              },
              title: Text("Location"),
            ),
        ],),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.cyan,
        child: Icon(Icons.refresh),
      ),
    );
  }
}


