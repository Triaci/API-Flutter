import 'package:apiflutter/models/ClassificacaoModel.dart';
import 'package:apiflutter/models/ConselhoModel.dart';
import 'package:flutter/material.dart';
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
      db =
          await openDatabase(join(await getDatabasesPath(), 'conselhos_milenares.db'),
              onCreate: (database, version) {
        database.execute('''
            CREATE TABLE conselho (
              id INTEGER PRIMARY KEY,
              classificacao INTEGER,
              texto TEXT,
              data DATE,
              comentario TEXT
            )
          ''');
        database.execute('''
            CREATE TABLE classificacao (
              id INTEGER PRIMARY KEY,
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
    db!.execute("INSERT INTO classificacao VALUES (0 ,'Conselhos Bons')");
    db!.insert('conselho', {
      'id': 0,
      'classificacao': 0,
      'texto': 'teste do banco',
      'data' : '10/10/2000',
      'comentario': 'comentario qualquer'
    });

    List classificacao = await db!.rawQuery('SELECT * FROM classificacao');
    // List items = await db.
    List<Map<String, Object?>> conselho = await db!.query('conselho');

    print("Testando o Banco");
    print(classificacao.toString());
    print(conselho.first.toString());
  }

    Future<int> insertClassificacao(ClassificacaoModel classificacao) async {
    // conflictAlgorithm especifica como o banco deve tratar quando inserimos dados com id duplicados
    // Nesse caso, se a mesma lista for inserida várias vezes, ela substituirá os dados anterior
    int id = await this.db!.insert('classificacao', classificacao.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<int> insertConselho(ConselhoModel conselho) async {
    int id = await this.db!.insert(
          'conselho',
          conselho.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
    return id;
  }

  Future<List<ClassificacaoModel>> getClassificacoes() async {
    final List<Map<String, dynamic>> mapClassificacoes = await this.db!.query('classificacao');

    return List.generate(mapClassificacoes.length, (index) {
      return ClassificacaoModel(
        id: mapClassificacoes[index]['id'],
        descricao: mapClassificacoes[index]['descricao']
      );
    });
  }

  Future<List<ConselhoModel>> getConselhos(int classificacao) async {
    final List<Map<String, dynamic>> mapConselhos = await this
        .db!
        .query('itens', where: 'classificacao = ?', whereArgs: [classificacao]);

    return List.generate(mapConselhos.length, (index) {
      return ConselhoModel(
        id: mapConselhos[index]['id'],
        classificacao: mapConselhos[index]['classificacao'],
        data: mapConselhos[index]['data'],
        comentario: mapConselhos[index]['comentario'],
        conselho: mapConselhos[index]['conselho']
      );
    });
  }

  Future<int> deleteList(ConselhoModel conselho) async{
    //arrumar para ele colocar branco onde houver essa classificaco
    //int result = await this.db!.delete('itens', where: 'id_lista = ?', whereArgs: [conselho.id]);
    int result = await this.db!.delete('conselho',where: 'id = ?', whereArgs: [conselho.id]);

    return result;
  }

  Future<int> deleteItem(ConselhoModel conselho) async{
    int result = await this.db!.delete('conselho', where: 'id = ?', whereArgs: [conselho.id]);
    return result;
  }
}

