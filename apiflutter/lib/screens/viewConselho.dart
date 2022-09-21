import 'package:apiflutter/models/ClassificacaoModel.dart';
import 'package:apiflutter/models/ConselhoModel.dart';
import 'package:apiflutter/screens/viewConselho.dart';
import 'package:apiflutter/utils/dbhelper.dart';
import 'package:apiflutter/utils/httphelper.dart';
import 'package:flutter/material.dart';

class viewConselho extends StatefulWidget {
  @override
  State<viewConselho> createState() => _viewConselhoState();
}

class _viewConselhoState extends State<viewConselho> {
  List<Conselho> conselho = [];
  late HttpHelper httphelper;

  @override
  void initState() {
    httphelper = new HttpHelper();
    initialize();
    super.initState();
    // result = '';
  }

  Future recebeConselho() async {
    conselho = await httphelper.getConselho();

    setState(() async {
      conselho = conselho;
    });
  }

  Future initialize() async {
    conselho = await httphelper.getConselho();
    setState(() {
      conselho = conselho;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    recebeConselho();
    return Scaffold(
      appBar: AppBar(
        title: Text("Conselho"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: MediaQuery.of(context).size.height*0.9,
            width: MediaQuery.of(context).size.height*0.8,
            decoration: new BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(40.0),
                          topRight: const Radius.circular(40.0),
                          bottomLeft: const Radius.circular(40.0),
                          bottomRight: const Radius.circular(40.0),
                        )),
                        
            
            child: Column(
              children: [Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(conselho[0].conselho,
                  style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                 decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(40.0),
                        topRight: const Radius.circular(40.0),
                        bottomLeft: const Radius.circular(40.0),
                        bottomRight: const Radius.circular(40.0),
                      )),),
              )],
            ),
          ),
        ),
      ),
    );
  }
}
