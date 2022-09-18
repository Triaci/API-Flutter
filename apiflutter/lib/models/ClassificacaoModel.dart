class ClassificacaoModel {
  int id;
  String descricao;

  ClassificacaoModel(
      {required this.id,
      required this.descricao,
      });

  Map<String, dynamic> toMap() {
    return {
      'id': (id == 0) ? null : id, // definimos como 0, para que o sqlite incremente automaticamente
      'descricao': descricao
    };
  }    

}
