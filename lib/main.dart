import 'package:pokedex/details_page.dart';
import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/pokemon_model.dart';

void main() => runApp(Home());

String capitalize(String string) =>
    string.replaceFirst(string[0], string[0].toUpperCase());

const color = Color.fromRGBO(242, 0, 12, 100);

List viewPokemons = [];
List pokemons;
Map pokemon;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final search$ = TextEditingController();

  Future<Map> getPokemons(String url) async {
    http.Response pokemons = await http.get(url);
    return json.decode(pokemons.body);
  }

  int searchIndex(String url) {
    List temp = url.split("/");
    return int.parse(temp[temp.length-2]);

  }

  void filterText(String key) {
    List temp = [];
    if (key.isNotEmpty) {
      for (var pokemon in pokemons) {
        if (pokemon["name"].contains(key.trim().toLowerCase())) {
          temp.add(pokemon);
        }
      }
      setState(() {
        viewPokemons.clear();
        viewPokemons.addAll(temp);
      });
    } else
      setState(() {
        viewPokemons.clear();
      }); 
      }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Pokedex",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            backgroundColor: color,
            title: Text("Home")),
        body: Column(
          children: <Widget>[
            // faltou o controller aqui, não?
            // ele pega automaticamente o valor do textfield
            // ah, sim... vc está usando o onChanged, justo

            TextField(
              controller: search$,
              onChanged: filterText,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  hintText: "Enter the name of Pokémon"),
              textCapitalization: TextCapitalization.sentences,
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: FutureBuilder(
                future: getPokemons(
                    "https://pokeapi.co/api/v2/pokemon?offset=0&limit=200"),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    pokemons = snapshot.data["results"];
                    return Container(
                      padding: EdgeInsets.all(20),
                      child: ListView.builder(
                        itemCount: search$.text.isEmpty
                            ? pokemons.length
                            : viewPokemons.length,
                        itemBuilder: (context, index) {
                          PokemonModel pokemonModel = PokemonModel.fromJson(
                              search$.text.isEmpty
                                  ? pokemons[index]
                                  : viewPokemons[index]);
                          return Row(
                            children: <Widget>[
                              // aqui precisaremos revisar
                              CachedNetworkImage(
                                imageUrl:
                                    pokemonModel.photo,
                                placeholder: (context, url) {
                                  return CircularProgressIndicator(
                                    strokeWidth: 5,
                                    backgroundColor:
                                        color,
                                  );
                                },
                              ),
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          Details(pokemonModel)));
                                },
                                child: Text(
                                  // pq n funciona assim?
                                  // da certo tbm kkk
                                  capitalize(pokemonModel.name),

                                  style: TextStyle(
                                    fontSize: 28,
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    );
                  }

                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                      backgroundColor: color,
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

