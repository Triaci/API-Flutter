import 'package:apiflutter/models/ClassificacaoModel.dart';
import 'package:apiflutter/models/ConselhoModel.dart';
import 'package:apiflutter/screens/listaClassificacoes.dart';
import 'package:apiflutter/screens/listaConselhos.dart';
import 'package:apiflutter/utils/httphelper.dart';
import 'package:flutter/material.dart';

import 'utils/dbhelper.dart';

void main() {
  runApp(AppConselhos());
}

class AppConselhos extends StatelessWidget {
  const AppConselhos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ConselhosMenu(),
    );
  }
}

class ConselhosMenu extends StatefulWidget {
  const ConselhosMenu({Key? key}) : super(key: key);

  @override
  State<ConselhosMenu> createState() => _ConselhosMenuState();
}

class _ConselhosMenuState extends State<ConselhosMenu> {
  
  DbHelper dbhelper = DbHelper();
  HttpHelper httpHelper = HttpHelper();
  List<ConselhoModel> listas = [];

  @override
  void initState() {
   
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print("passou");
    dbhelper.testDb();
    print("antes do http");
    httpHelper.getConselho();

    return Scaffold(
      appBar: AppBar(
        title: Text("Conselhos Milenares"),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsetsDirectional.all(10),
                child: Image.asset('assets/images/socrates.jpg', height: 350)),
            Padding(
              padding: EdgeInsetsDirectional.all(10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => ListaConselhos()));
                },
                child: Text('Conselhos'),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.all(10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => ListaClassificacoes()));
                },
                child: Text('Classificação'),
              ),
            ),
          ],
        ),
      ),
      
    );
  }
}


