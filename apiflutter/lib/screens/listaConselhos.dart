import 'package:apiflutter/models/ConselhoModel.dart';
import 'package:apiflutter/screens/viewConselho.dart';
import 'package:apiflutter/utils/dbhelper.dart';
import 'package:flutter/material.dart';
import '../utils/httphelper.dart';

class ListaConselhos extends StatefulWidget {
  @override
  State<ListaConselhos> createState() => _ListaConselhosState();
}

class _ListaConselhosState extends State<ListaConselhos> {
  late String result;
  late HttpHelper httphelper;
  late DbHelper dbhelper;

  String dataString = '';
  int conselhosCount = 0;
  List<Conselho> conselhos = [];

  Icon iconeSearchBar = Icon(Icons.search);
  Widget searchBar = Text('Conselhos');

  @override
  void initState() {
    httphelper = new HttpHelper();
    dbhelper = new DbHelper();
    carregaConselhos();
    initialize();
    super.initState();
    // result = '';
  }

  Future carregaConselhos() async {
    await dbhelper.openDb();

    conselhos = await dbhelper.getConselhos(1);
    //dataString = DateFormat("yyyy-MM-dd hh:mm:ss").format(conselhos[1].data);
    setState(() {
      conselhos = conselhos;
    });
  }

  Future initialize() async {
    // Aqui alimenta com o http conselhos = await httphelper.getConselho();
    conselhos = await httphelper.getConselho();
    setState(() {
      conselhosCount = conselhos.length;
      conselhos = conselhos;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //carregaConselhos();
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
                itemCount:
                    (this.conselhosCount == null) ? 0 : this.conselhosCount,
                itemBuilder: ((BuildContext context, int index) {
                  //       if (conselhos[index].posterPath != null) {
                  //image =
                  //  NetworkImage(defaultPathImage + filmes[index].posterPath);
                  //       } else {
                  //  image = NetworkImage(defaultPoster);
//                  }
                  return Dismissible(
                      key: Key(conselhos[index].id.toString()),
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.endToStart) {}
                        return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: const Text(
                                    'Deseja realmente remover este conselho?'),
                                actions: <Widget>[
                                  TextButton(
                                      child: const Text('Sim'),
                                      onPressed: () async {
                                        String status =
                                            (await dbhelper.removerConselho(
                                                conselhos[index])) as String;
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(status)));
                                        Navigator.of(context).pop(true);
                                      }),
                                  TextButton(
                                    child: const Text('Não'),
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                  ),
                                ],
                              );
                            });
                      },
                      child: Card(
                        color: Colors.white,
                        elevation: 2.0,
                        child: ListTile(
                          onTap: () {
                            dbhelper.insertConselho(conselhos[index]);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => viewConselho()));
                          },
                          title: Text(conselhos[index].conselho),
                          subtitle: Text('Comentario: '),
                          leading: CircleAvatar(),
                        ),
                      ));
                }))));
  }
}
