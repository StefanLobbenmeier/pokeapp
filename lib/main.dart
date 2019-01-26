import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:pokeapp/pokemon.dart';
import 'package:pokeapp/pokemondetail.dart';

void main() => runApp(MaterialApp(
      title: "Poke App",
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    ));

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  var url =
      "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";

  PokeHub pokeHub;

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  Future<PokeHub> fetchData() async {
    var res = await http.get(url);
    var json = jsonDecode(res.body);

    return pokeHub = PokeHub.fromJson(json);
  }

  GridView view;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Poke App"),
        backgroundColor: Colors.cyan,
      ),
      body: view == null
          ? FutureBuilder<PokeHub>(
              future: fetchData(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    return view = getGridView(snapshot.data);
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    return Center(child: Text("Fuck this"));
                }
              })
          : view,
      /* pokeHub == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : 
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.cyan,
        child: Icon(Icons.refresh),
      ),*/
    );
  }

  GridView getGridView(PokeHub pokehub) {
    return GridView.count(
      crossAxisCount: 2,
      children: pokeHub.pokemon
          .map((poke) => Padding(
                padding: const EdgeInsets.all(2.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => PokeDetail(pokemon: poke)));
                  },
                  child: Card(
                    elevation: 3.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Hero(
                          tag: poke.img,
                          child: CachedNetworkImage(
                            imageUrl: poke.img,
                          ),
                        ),
                        Hero(
                          tag: poke.name,
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              poke.name,
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }
}
