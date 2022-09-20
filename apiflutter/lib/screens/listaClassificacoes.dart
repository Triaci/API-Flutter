import 'package:apiflutter/models/ClassificacaoModel.dart';
import 'package:apiflutter/models/ConselhoModel.dart';
import 'package:apiflutter/screens/viewConselho.dart';
import 'package:apiflutter/utils/dbhelper.dart';
import 'package:apiflutter/utils/httphelper.dart';
import 'package:flutter/material.dart';

class ListaClassificacoes extends StatefulWidget {
  @override
  State<ListaClassificacoes> createState() => _ListaClassificacoesState();
}

class _ListaClassificacoesState extends State<ListaClassificacoes> {
  late String result;
  late HttpHelper httphelper;
  late DbHelper dbhelper = DbHelper();
  late ClassificacaoDialog dialog;

  List<Classificacao> classificacoes = [];

  //final String defaultPathImage = 'https://image.tmdb.org/t/p/w92/';
  //final String defaultPoster =
  //  'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';

  Icon iconeSearchBar = Icon(Icons.search);
  Widget searchBar = Text('Classificacoes');
  int classcount = 0;
  @override
  void initState() {
    httphelper = new HttpHelper();
    dbhelper = new DbHelper();
    dialog = ClassificacaoDialog();
    initialize();
    super.initState();
    // result = '';
  }

  Future carregaLista() async {
    await dbhelper.openDb();

    classificacoes = await dbhelper.getClassificacoes();
    setState(() {
      classificacoes = classificacoes;
    });
  }

  Future initialize() async {
    //conselhos = await helper.getLancamentos();
    setState(() async {
      classificacoes = await dbhelper.getClassificacoes();
      classcount = classificacoes.length;
      classificacoes = classificacoes;
      ;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    carregaLista();
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
                      this.searchBar = Text('Lista de Classificacoes');
                    });
                  }
                });
              }),
        ],
      ),
      body: Container(
          child: ListView.builder(
              itemCount: (this.classcount == null) ? 0 : this.classcount,
              itemBuilder: ((BuildContext context, int index) {
                //       if (conselhos[index].posterPath != null) {
                //image =
                //  NetworkImage(defaultPathImage + filmes[index].posterPath);
                //       } else {
                //  image = NetworkImage(defaultPoster);
//                  }
                return Dismissible(
                  key: Key(classificacoes[index].id.toString()),
                  onDismissed: (direction) async {
                    //carregaLista();
                    if (direction == DismissDirection.endToStart) {
                      await dbhelper.removerClassificao(classificacoes[index]);
                    }
                    if (direction == DismissDirection.startToEnd) {
                      print("Start to End");
                    }
                  }
                  /*return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: const Text(
                                'Deseja realmente remover esta classificacao?'),
                            actions: <Widget>[
                              TextButton(
                                  child: const Text('Sim'),
                                  onPressed: () async {
                                    String status =
                                        (await dbhelper.removerClassificao(
                                            classificacoes[index])) as String;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(status)));
                                    Navigator.of(context).pop(true);
                                    carregaLista();
                                  }),
                              TextButton(
                                  child: const Text('Não'),
                                  onPressed: () {
                                    carregaLista();
                                    Navigator.of(context).pop(false);
                                  }),
                            ],
                          );
                        });
                  },*/
                  ,
                  child: Card(
                    color: Colors.white,
                    elevation: 2.0,
                    child: ListTile(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => viewConselho()));
                      },
                      title: Text(classificacoes[index].descricao),
                      // subtitle:
                      //   Text('Comentario: ' + conselhos[index].comentario),
                      //leading: CircleAvatar(),
                    ),
                  ),
                );
              }))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => dialog.buildDialog(
                context, Classificacao(id: 0, descricao: ''), true),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class ClassificacaoDialog {
  late var txtDescricao = TextEditingController();
  late var txtPrioridade = TextEditingController();

  Widget buildDialog(
      BuildContext context, Classificacao classificacao, bool isNew) {
    DbHelper helper = DbHelper();

    if (!isNew) {
      txtDescricao = TextEditingController(text: classificacao.descricao);
    }
    return AlertDialog(
      title: Text((isNew) ? "Nova Classificacao" : "Alterar Classificacao"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: txtDescricao,
              decoration: InputDecoration(
                  hintText: 'Descreva estes conselhos com uma palavra...'),
            ),
            ElevatedButton(
              onPressed: () {
                classificacao.descricao = txtDescricao.text;
                helper.insertClassificacao(classificacao);
                Navigator.pop(context);
              },
              child: Text("Salvar Classificacao"),
            )
          ],
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
    );
  }
}
