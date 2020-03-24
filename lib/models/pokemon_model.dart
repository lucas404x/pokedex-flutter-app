// To parse this JSON data, do
//
//     final pokemonModel = pokemonModelFromJson(jsonString);

import 'dart:convert';

int searchIndex(String url) {
  List temp = url.split("/");
  return int.parse(temp[temp.length - 2]);
}

PokemonModel pokemonModelFromJson(String str) =>
    PokemonModel.fromJson(json.decode(str));

String pokemonModelToJson(PokemonModel data) => json.encode(data.toJson());

class PokemonModel {
  final String name;
  final String url;
  final String photo;

  PokemonModel({this.name, this.url, this.photo});

  factory PokemonModel.fromJson(Map<String, dynamic> json) => PokemonModel(
      name: json["name"],
      url: json["url"],
      photo:
          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${searchIndex(json["url"])}.png");

  Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
        "photo": photo,
      };
}
