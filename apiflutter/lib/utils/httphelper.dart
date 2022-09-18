import 'dart:convert';
import 'dart:io';

import 'package:apiflutter/models/ConselhoModel.dart';
import 'package:http/http.dart' as http;

class HttpHelper {
  Future getConselho() async {
    Uri uri = new Uri(
      scheme: 'https',
      host: 'api.adviceslip.com',
      path: 'advice',
    );

    http.Response response = await http.get(uri);

    if (response.statusCode == HttpStatus.ok) {
      final json = jsonDecode(response.body);
      final conselhoAlt = json['advice'];

      // List<Filme> filmes =
      //     filmesMap.map((data) => Filme.fromJson(data)).toList();

      //  return filmes;
      print(conselhoAlt);
      return conselhoAlt;
    } else {
      print("retornou vazio");
      return '';
    }
  }
/*
  Future<List<ConselhoModel>> buscaFilme(String titulo) async {
    print(titulo);
    Uri uri = new Uri(
        scheme: 'https',
        host: dotenv.env['HOST'],
        path: '3/search/movie',
        queryParameters: {
          'api_key': dotenv.env['API_KEY'],
          'language': dotenv.env['LANGUAGE'],
          'query': titulo
        });

    http.Response response = await http.get(uri);

    if (response.statusCode == HttpStatus.ok) {
      final json = jsonDecode(response.body);
      final filmesMap = json['results'] as List;

      List<Filme> filmes =
          filmesMap.map((data) => Filme.fromJson(data)).toList();

      return filmes;
    } else {
      return [];
    }
  }

  Future<String> adicionarFavoritos(int id) async {
    Uri uri = new Uri(
        scheme: 'https',
        host: dotenv.env['HOST'],
        path: '3/list/8217279/add_item',
        queryParameters: {
          'api_key': dotenv.env['API_KEY'],
          'session_id': dotenv.env['SESSION_ID'],
          'language': dotenv.env['LANGUAGE'],
        });

    http.Response response = await http.post(uri,
        body: jsonEncode(<String, int>{
          'media_id': id.toInt(),
        }),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 201) {
      return "Item adicionado os Favoritos";
    } else {
      return "Houve erro ao adicionar os Favoritos";
    }
  }

  Future<String> removerFavoritos(int id) async {
    Uri uri = new Uri(
        scheme: 'https',
        host: dotenv.env['HOST'],
        path: '3/list/8217279/remove_item',
        queryParameters: {
          'api_key': dotenv.env['API_KEY'],
          'session_id': dotenv.env['SESSION_ID'],
          'language': dotenv.env['LANGUAGE'],
        });

    http.Response response = await http.post(uri,
        body: jsonEncode(<String, int>{
          'media_id': id.toInt(),
        }),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      return "Item removido dos Favoritos";
    } else {
      return "Houve erro ao remover dos Favoritos";
    }
  }

  Future<List<Filme>> getFavoritos() async {
    Uri uri = new Uri(
        scheme: 'https',
        host: dotenv.env['HOST'],
        path: '3/list/8217279',
        queryParameters: {
          'api_key': dotenv.env['API_KEY'],
          'language': dotenv.env['LANGUAGE']
        });

    http.Response response = await http.get(uri);

    if (response.statusCode == HttpStatus.ok) {
      final json = jsonDecode(response.body);
      final filmesMap = json['items'] as List;

      List<Filme> filmes =
          filmesMap.map((data) => Filme.fromJson(data)).toList();

      return filmes;
    } else {
      return [];
    }
  }
*/
}
