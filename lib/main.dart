import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pokemondex/pokemon.dart';
import 'package:pokemondex/pokemondetail.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  Widget build(BuildContext context){
    return StreamBuilder(
        stream: bloc.darkThemeEnabled,
        initialData: false,
        builder: (context, snapshot) =>
            MaterialApp(
              title: "PokeDex",
              theme: snapshot.data ? ThemeData.dark() : ThemeData.light(),
              home: HomePage(snapshot.data),
            ));
  }
}

class PokeApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return HomePage();
  }
}


class HomePage extends State<PokeApp> {
  final bool darkThemeEnabled;
  HomePage(this.darkThemeEnabled);
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
  }
  setState(() {})

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
              title: Text("Night mode"),
              trailing: Switch(
                value: darkThemeEnabled,
                onChanged: bloc.changeTheme,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.cyan,
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class Bloc {
  final _themeController = StreamController<bool>();
  get changeTheme => _themeController.sink.add;
  get darkThemeEnabled => _themeController.stream;
}

final bloc = Bloc();

