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
  HttpHelper httphelper = HttpHelper();
  List<Conselho> listas = [];
  late ClassificacaoDialog dialog;

  @override
  initState() {
    httphelper = new HttpHelper();
    dbhelper = new DbHelper();
    dialog = ClassificacaoDialog();
    super.initState();
  }

  Future initialize() async {
    listas = await httphelper.getConselho();
    //  conselhos = await dbhelper.getConselhos(1);
    setState(() {
      listas = listas;
    });
  }

  @override
  Widget build(BuildContext context) {
    String conselhoRecuperado = '';

    dbhelper.testDb();
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
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => dialog.buildDialog(
                          context, Classificacao(id: 0, descricao: ''), true),
                    );
                  },
                  child: Text("Novo Conselho!")),
            )
          ],
        ),
      ),
    );
  }
}

class ClassificacaoDialog {
  late var txtDescricao = TextEditingController();
  late var txtPrioridade = TextEditingController();

  Widget buildDialog(
      BuildContext context, Classificacao classificacao, bool isNew) {
    DbHelper dbhelper = DbHelper();
    HttpHelper httphelper = HttpHelper();
    List<Conselho> conselho = [];

    Future geraConselho() async {
      conselho = await httphelper.getConselho();
    }

    if (!isNew) {
      txtDescricao = TextEditingController(text: classificacao.descricao);
    }
    geraConselho();
    return AlertDialog(
      title: Text((isNew) ? "Nova Classificacao" : "Alterar Classificacao"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text(conselho[0].conselho),
            Row(children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: ElevatedButton(
                  onPressed: () {
                    classificacao.descricao = txtDescricao.text;
                    dbhelper.insertClassificacao(classificacao);
                    Navigator.pop(context);
                  },
                  child: Text("Salvar Conselho"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2),
                child: ElevatedButton(
                  onPressed: () {
                    classificacao.descricao = txtDescricao.text;
                    dbhelper.insertClassificacao(classificacao);
                    Navigator.pop(context);
                  },
                  child: Text("Cancelar"),
                ),
              ),
            ])
          ],
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
    );
  }
}
