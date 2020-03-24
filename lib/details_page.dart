import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import "package:pokedex/main.dart";
import 'package:pokedex/models/pokemon_model.dart';

Future<Map> getPokemonData(String pokemonName) async {
  http.Response pokemonData =
      await http.get("https://pokeapi.co/api/v2/pokemon/$pokemonName/");

  return json.decode(pokemonData.body);
}

Map pokemonData;

class Details extends StatefulWidget {
  // primeira classe
  final PokemonModel pokemon;
  Details(this.pokemon);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  // segunda classe

  // Map pokemon;
  // _DetailsState(this.pokemon);
  // Para acessar aqui alguma variável lá de cima, é só chamar por "widget

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Pokedex - ${capitalize(widget.pokemon.name)}",
      home: Scaffold(
          appBar: AppBar(
              actions: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return Home();
                    }));
                  },
                  alignment: Alignment.center,
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                )
              ],
              backgroundColor: color,
              centerTitle: true,
              title: Text(capitalize(widget.pokemon.name))),
          body: FutureBuilder(
            future: getPokemonData(widget.pokemon.name),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                pokemonData = snapshot.data;

                return Container(
                  alignment: Alignment.center,
                  child: Column(children: <Widget>[
                    Container(
                      color: color,
                      child: Row(
                        children: <Widget>[
                          CachedNetworkImage(
                            fit: BoxFit.fill,
                            height: 150,
                            imageUrl: widget.pokemon.photo,
                            placeholder: (context, url) {
                              return CircularProgressIndicator(
                                strokeWidth: 5,
                                backgroundColor: color,
                              );
                            },
                          ),
                          Text(
                            "This is ${capitalize(widget.pokemon.name)}!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    Column(
                      children: showWeightAndheight(pokemonData),
                    ),
                    Text(
                      "  Moves  ",
                      style: TextStyle(
                          fontSize: 20,
                          backgroundColor: color,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                      child: GridView.count(

                        physics: NeverScrollableScrollPhysics(),
                        
                        padding: EdgeInsets.all(30),
                        crossAxisSpacing: 60,
                        mainAxisSpacing: 10,
                        
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        children: showMoves(pokemonData),
                      ),
                    ),)
                  ]),
                );
              }
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  backgroundColor: color,
                ),
              );
            },
          )),
    );
  }
}

List<Widget> showWeightAndheight(Map pokemonData) {
  List<Widget> data = [];

  data.add(Padding(
    padding: EdgeInsets.all(20),
    child: Row(
      children: <Widget>[
        Text(
          "  Weight: ${pokemonData["weight"]}  ",
          style: TextStyle(
              fontSize: 20,
              backgroundColor: color,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        Spacer(
          flex: 1,
        ),
        Text(
          "   Height: ${pokemonData["height"]}   ",
          style: TextStyle(
              fontSize: 20,
              backgroundColor: color,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        )
      ],
    ),
  ));

  return data;
}

List<Widget> showMoves(Map pokemonData) {
  List<Widget> data = [];

  for (var move in pokemonData["moves"]) {
    data.add(Text(capitalize(move["move"]["name"]), style: TextStyle(
      fontSize: 16,)));
  }

  return data;
}
