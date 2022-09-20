class Conselho {
  late int id;
  late int classificacao;
  late String conselho;
  late String data;
  late String comentario;

  Conselho( 
      { required this.id,
       required this.classificacao,
       required this.conselho,
       required this.data,
       required this.comentario});

  Conselho.fromJson(Map<dynamic, dynamic> json) {
    this.id = json['id'];
    this.conselho = json['advice'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': (id == 0) ? null : id, // definimos como 0, para que o sqlite incremente automaticamente
      'classificacao': classificacao,
      'conselho': conselho,
      'data' : data ,
      'comentario': comentario
    };
  }    

}
