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
    print(uri);

    http.Response response = await http.get(uri);

    if (response.statusCode == HttpStatus.ok) {
      final json = jsonDecode(response.body);
      final conselhosMap = json['slip'] as List;

      Map<dynamic, List<Conselho>> conselhos =
          conselhosMap.map((data) => Conselho.fromJson(data))
              as Map<dynamic, List<Conselho>>;

      return conselhos;
    } else {
      return [];
    }
  }
}
