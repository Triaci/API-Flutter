import 'package:apiflutter/models/ConselhoModel.dart';
import 'package:apiflutter/screens/viewConselho.dart';
import 'package:flutter/material.dart';

class ListaConselhos extends StatefulWidget {
  @override
  State<ListaConselhos> createState() => _ListaConselhosState();
}

class _ListaConselhosState extends State<ListaConselhos> {
  late String result;
  //late HttpHelper helper;

  int filmesCount = 0;
  List<ConselhoModel> conselhos = [];

  final String defaultPathImage = 'https://image.tmdb.org/t/p/w92/';
  final String defaultPoster =
      'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';

  Icon iconeSearchBar = Icon(Icons.search);
  Widget searchBar = Text('Conselhos');

  @override
  void initState() {
    //helper = new HttpHelper();
    initialize();
    super.initState();
    // result = '';
  }

  Future initialize() async {
    //conselhos = await helper.getLancamentos();
    setState(() {
      filmesCount = conselhos.length;
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
                itemCount: (this.filmesCount == null) ? 0 : this.filmesCount,
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
