import 'package:apiflutter/models/ClassificacaoModel.dart';
import 'package:apiflutter/models/ConselhoModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  final int version = 1;
  Database? db;

  static final DbHelper _dbHelper = DbHelper._internal();

  DbHelper._internal();

  factory DbHelper() {
    return _dbHelper;
  }

  Future<Database?> openDb() async {
    if (db == null) {
      db = await openDatabase(
          join(await getDatabasesPath(), 'conselhos_milenares.db'),
          onCreate: (database, version) {
        database.execute('''
            CREATE TABLE conselho (
              id INTEGER PRIMARY KEY ,
              classificacao INTEGER,
              conselho TEXT,
              data DATE,
              comentario TEXT
            )
          ''');
        database.execute('''
            CREATE TABLE classificacao (
              id INTEGER PRIMARY KEY ,
              descricao TEXT
            )
          ''');
      }, version: version);

      return db;
    } else {
      return db;
    }
  }

  // método responsável por testar se a conexão com o banco de dados foi criada corretamente
  // verificar se podemos fazer a inserção com o inser e com o sql padrão
  Future testDb() async {
    db = await openDb();

    // db!.execute("INSERT INTO classificacao VALUES (0, 'Conselhos Bons')");

    /* 
      a cada execução do seu applicativo, o código acima tentava inserir um classificação com id 0, isso não é possivel
      pois, não pode-se repetir chave primaria no banco durante a inserção
      o autoincrement na criação da tabela ajuda a resolver isso, e também, o conflict algorithm, que vai atualizar as infos no banco ao invés
      de inseri-las novamente
    */
    //db!.delete('classificacao'); // pra evitar que o banco fique com lixo
    //db!.delete('conselho'); // pra evitar que o banco fique com lixo
    db!.insert('classificacao', {'id': 0, 'descricao': "Conselhos bons"},
        conflictAlgorithm: ConflictAlgorithm.replace);
  //  db!.insert('classificacao', {'id': 0, 'descricao': "Conselhos Ruins"},
  //    conflictAlgorithm: ConflictAlgorithm.replace);
    db!.insert(
        'conselho',
        {
          'id': null,
          'classificacao': 1,
          'texto': 'Dê um abraço na sua mãe',
          'data': '2000-10-10',
          'comentario': 'Pais e avós deveriam ser eternos'
        },
        conflictAlgorithm: ConflictAlgorithm.replace);

    List classificacao = await db!.rawQuery('SELECT * FROM classificacao');
    // List items = await db.
    List<Map<String, Object?>> conselho = await db!.query('conselho');

    print("Testando o Banco");
    print(classificacao.toString());
    print(conselho.first.toString());
  }

  Future<int> insertClassificacao(Classificacao classificacao) async {
    // conflictAlgorithm especifica como o banco deve tratar quando inserimos dados com id duplicados
    // Nesse caso, se a mesma lista for inserida várias vezes, ela substituirá os dados anterior
    int id = await this.db!.insert('classificacao', classificacao.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<int> insertConselho(
      int classificacao, String texto, DateTime data, String comentario) async {
    int id = await this.db!.insert(
        'conselho',
        {
          'id': null,
          'classificacao': classificacao,
          'texto': texto,
          'data': DateFormat('yyyy-MM-dd').format(data),
          'comentario': comentario
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
    List<Map<String, Object?>> conselho = await db!.query('conselho');
    conselho.forEach((cons) {
      print(cons.toString());
    });
    return id;
  }

  Future<List<Classificacao>> getClassificacoes() async {
    final List<Map<String, dynamic>> mapClassificacoes =
        await this.db!.rawQuery('SELECT * FROM classificacao');

    return List.generate(mapClassificacoes.length, (index) {
      return Classificacao(
          id: mapClassificacoes[index]['id'],
          descricao: mapClassificacoes[index]['descricao']);
    });
  }

  Future<List<Conselho>> getConselhos() async {
    final List<Map<String, dynamic>> mapConselhos =
        await this.db!.query('conselho');

    return List.generate(mapConselhos.length, (index) {
      print("entrou no generate");
      return Conselho(
          id: mapConselhos[index]['id'],
          classificacao: mapConselhos[index]['classificacao'],
          data: DateTime.parse(mapConselhos[index]
              ['data']), // faz o parse da sua data para um objeto DateTime
          comentario: mapConselhos[index]['comentario'],
          conselho: mapConselhos[index]['texto']);
    });
  }

  Future<int> deleteList(Conselho conselho) async {
    //arrumar para ele colocar branco onde houver essa classificaco
    //int result = await this.db!.delete('itens', where: 'id_lista = ?', whereArgs: [conselho.id]);
    int result = await this
        .db!
        .delete('conselho', where: 'id = ?', whereArgs: [conselho.id]);

    return result;
  }

  Future<int> deleteItem(Conselho conselho) async {
    int result = await this
        .db!
        .delete('conselho', where: 'id = ?', whereArgs: [conselho.id]);
    return result;
  }

  Future<int> removerClassificao(Classificacao classificacao) async {
    int result = await this.db!.delete('classificacao',
        where: 'id = ?', whereArgs: [classificacao.id]);
    result = await this.db!.delete('conselho',
        where: 'classificacao = ?', whereArgs: [classificacao.id]);
    return result;
  }

  Future<int> removerConselho(Conselho conselho) async {
    int result = await this
        .db!
        .delete('conselho', where: 'id = ?', whereArgs: [conselho.id]);
    return result;
  }
}
