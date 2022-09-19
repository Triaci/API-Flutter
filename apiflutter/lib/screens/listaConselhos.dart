import 'package:apiflutter/models/ConselhoModel.dart';
import 'package:apiflutter/screens/viewConselho.dart';
import 'package:flutter/material.dart';

import '../utils/httphelper.dart';

class ListaConselhos extends StatefulWidget {
  @override
  State<ListaConselhos> createState() => _ListaConselhosState();
}

class _ListaConselhosState extends State<ListaConselhos> {
  late String result;
  late HttpHelper httphelper;

  int conselhosCount = 0;
  List<Conselho> conselhos = [];

  Icon iconeSearchBar = Icon(Icons.search);
  Widget searchBar = Text('Conselhos');

  @override
  void initState() {
    httphelper = new HttpHelper();
    initialize();
    super.initState();
    // result = '';
  }

  Future initialize() async {
    conselhos = await httphelper.getConselho();
    setState(() {
      conselhosCount = conselhos.length;
      conselhos = conselhos;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: searchBar,
          actions: [
            IconButton(
                icon: iconeSearchBar,
                onPressed: () {
                  setState(() {
                    if (this.iconeSearchBar.icon == Icons.search) {
                      this.iconeSearchBar = Icon(Icons.cancel);
                      this.searchBar = TextField(
                        autofocus: true,
                        textInputAction: TextInputAction.search,
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                        onSubmitted: (String titulo) {
                          //search(titulo);
                        },
                      );
                    } else {
                      this.setState(() {
                        this.iconeSearchBar = Icon(Icons.search);
                        this.searchBar = Text('Lista de Conselhos');
                      });
                    }
                  });
                }),
          ],
        ),
        body: Container(
            child: ListView.builder(
                itemCount: (this.conselhosCount == null) ? 0 : this.conselhosCount,
                itemBuilder: ((BuildContext context, int index) {
                  //       if (conselhos[index].posterPath != null) {
                  //image =
                  //  NetworkImage(defaultPathImage + filmes[index].posterPath);
                  //       } else {
                  //  image = NetworkImage(defaultPoster);
//                  }
                  print(index.toString() + "index do conselho");
                  return Card(
                    color: Colors.white,
                    elevation: 2.0,
                    child: ListTile(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => viewConselho()));
                      },
                      title: Text(conselhos[index].conselho),
                      subtitle:
                          Text('Comentario: ' + conselhos[index].comentario),
                      leading: CircleAvatar(),
                    ),
                  );
                }))));
  }
}
