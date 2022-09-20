import 'dart:convert';
import 'dart:io';

import 'package:apiflutter/models/ConselhoModel.dart';
import 'package:http/http.dart' as http;

class HttpHelper {

  Future<List<Conselho>> getConselho() async {
    Uri uri = new Uri(
      scheme: 'https',
      host: 'api.adviceslip.com',
      path: 'advice',
    );
    
    http.Response response = await http.get(uri);

    if (response.statusCode == HttpStatus.ok) {
      final json = jsonDecode(response.body);
      final conselhosMap = json['slip'] as List;

      // *** esse endpoint retorna somente um conselho, por isso, não há necessidade de atribuir isso a uma lista
      // final conselhosMap = json['slip'] as List;
      // Map<dynamic ,List<Conselho>> conselhos =
      //     conselhosMap.map((data) => Conselho.fromJson(data)) as Map<dynamic, List<Conselho>>;

      Conselho conselho = Conselho.fromJson(json['slip']);
      List<Conselho> conselhos = [];
      conselhos
          .add(conselho); // aqui pego seu unico conselho, e adiciono na lista
      conselhos.forEach((adv) {
        print(adv.conselho);
      });


      return conselhos;
    } else {
      return [];
    }
  }
}
