import 'dart:ffi';

import 'package:apiflutter/main.dart';
import 'package:apiflutter/models/ClassificacaoModel.dart';
import 'package:apiflutter/models/ConselhoModel.dart';
import 'package:apiflutter/screens/viewConselho.dart';
import 'package:apiflutter/utils/dbhelper.dart';
import 'package:apiflutter/utils/httphelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class viewConselho extends StatefulWidget {
  @override
  State<viewConselho> createState() => _viewConselhoState();
}

class _viewConselhoState extends State<viewConselho> {
  List<Conselho> conselhos = [];
  String conselho = '';
  String data = '';
  List<Classificacao> classificacoes = [];
  List<String> idClass = [];
  late HttpHelper httphelper;
  late DbHelper dbHelper;
  late var comentario = TextEditingController();
  String dropDownValue = '';
  DateTime dataConselho = DateTime.now();

  @override
  void initState() {
    httphelper = new HttpHelper();
    dbHelper = new DbHelper();
    initialize();
    super.initState();
    // result = '';
  }

  void recebeConselho() async {
    conselhos = await httphelper.getConselho();
    classificacoes = await dbHelper.getClassificacoes();
    //conselho = conselhos.first.conselho;
    setState(() async {
      conselho = conselho;
    });
  }

  Future initialize() async {
    conselhos = await httphelper.getConselho();
    classificacoes = await dbHelper.getClassificacoes();
    dropDownValue = classificacoes.first.id.toString();
    conselho = conselhos.first.conselho;
    classificacoes.forEach((classi) {
      idClass.add(classi.id.toString());
    });
    print(idClass);
    setState(() {
      conselho = conselho;
      classificacoes = classificacoes;
      idClass = idClass;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    recebeConselho();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Conselho"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.height * 0.8,
              decoration: new BoxDecoration(
                  color: Colors.lightBlue[100],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                    bottomLeft: Radius.circular(40.0),
                    bottomRight: Radius.circular(40.0),
                  )),
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsetsDirectional.all(10),
                      child: ClipRRect(
                          child:
                              Image.asset('assets/images/sim.png', height: 270),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(400)))),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(conselho,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(40.0),
                            topRight: Radius.circular(40.0),
                            bottomLeft: Radius.circular(40.0),
                            bottomRight: Radius.circular(40.0),
                          )),
                    ),
                  ),
                  Center(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Classificação: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40))),
                          ),
                        ),
                        /*Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButton<String>(
                            value: dropDownValue,
                            onChanged: (String? value) {
                              setState(
                                () {
                                  dropDownValue = value!;
                                },
                              );
                            },
                            items: idClass
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text("teste")
                                   // classificacoes[int.parse(value)].descricao),
                              );
                            }).toList(),
                          ),
                        ),*/
                      ],
                    ),
                  ),
                  Text(
                    "Comentários...",
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 10, left: 10, right: 10, top: 5),
                    child: Container(
                      // ignore: sort_child_properties_last
                      child: TextField(
                        controller: comentario,
                      ),
                      decoration: new BoxDecoration(
                        color: Colors.amber[300],
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                      ),
                    ),
                  ),
                  Center(
                    child: Row(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0))),
                          ),
                          onPressed: () async {
                            DateTime? newData = await showDatePicker(
                                context: context,
                                initialDate: dataConselho,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2050));

                            if (newData == null) {
                              return;
                            } else {
                              setState(() {
                                dataConselho = newData;
                              });
                            }
                          },
                          child: const Text('Selecione a Data'),
                        ),
                      ),
                      Center(
                          child: Container(
                              decoration: new BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40)),
                                color: Colors.greenAccent.shade400,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  DateFormat("dd/MM/yyyy").format(dataConselho),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 15),
                                ),
                              )))
                    ]),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.red)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => AppConselhos()));
                            },
                            child: const Text("Descartar"),
                          ),
                        ),
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.green)),
                          onPressed: () async {
                            await dbHelper.insertConselho(
                                1, conselho, dataConselho, comentario.text);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => AppConselhos()));
                          },
                          child: const Text("Ser uma pessoa melhor"))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
