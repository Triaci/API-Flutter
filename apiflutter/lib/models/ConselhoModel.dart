class ConselhoModel {
  int id;
  int classificacao;
  String conselho;
  DateTime data;
  String comentario;

  ConselhoModel(
      {required this.id,
      required this.classificacao,
      required this.conselho,
      required this.data,
      required this.comentario});

  Map<String, dynamic> toMap() {
    return {
      'id': (id == 0) ? null : id, // definimos como 0, para que o sqlite incremente automaticamente
      'classificacao': classificacao,
      'conselho': conselho,
      'data' : data,
      'comentario': comentario
    };
  }    

}
