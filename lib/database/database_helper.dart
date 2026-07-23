import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instancia = DatabaseHelper._interno();
  static Database? _bancoDeDados;

  factory DatabaseHelper() => _instancia;

  DatabaseHelper._interno();

  Future<Database> get bancoDeDados async {
    if (_bancoDeDados != null) return _bancoDeDados!;
    _bancoDeDados = await _iniciarBanco();
    return _bancoDeDados!;
  }

  Future<Database> _iniciarBanco() async {
    String caminhoBanco = await getDatabasesPath();
    String caminhoCompleto = join(caminhoBanco, 'coma_bem.db');
    return await openDatabase(caminhoCompleto, version: 1, onCreate: _criarTabelas);
  }

  Future<void> _criarTabelas(Database db, int versao) async {
    await db.execute('''
      CREATE TABLE usuario (
        usu_id_usuario INTEGER PRIMARY KEY AUTOINCREMENT,
        usu_tx_email TEXT NOT NULL UNIQUE,
        usu_tx_senha TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE restaurante (
        res_id_restaurante INTEGER PRIMARY KEY AUTOINCREMENT,
        res_nm_restaurante TEXT NOT NULL,
        res_nu_latitude TEXT NOT NULL,
        res_nu_longitude TEXT NOT NULL,
        res_ds_tipo_culinaria TEXT NOT NULL
      )
      ''');

    await db.execute('''
      CREATE TABLE prato (
        pra_id_prato INTEGER PRIMARY KEY AUTOINCREMENT,
        pra_nm_prato TEXT NOT NULL,
        pra_im_foto NULL,
        pra_id_restaurante INT NOT NULL
      )
      ''');

    await db.execute('''
      CREATE TABLE avaliacao (
        avl_id_avaliacao INTEGER PRIMARY KEY AUTOINCREMENT,
        avl_nu_ranking INT NOT NULL,
        avl_tx_recomendacao TEXT NOT NULL,
        avl_id_prato INT NOT NULL,
        avl_id_usuario INT NOT NULL
      )
      ''');
  }

  Future<Map<String, dynamic>?> autenticarUsuario(String email, String senha) async {
    Database db = await bancoDeDados;
    List<Map<String, dynamic>> resultado = await db.query(
      'usuario',
      where: 'usu_tx_email = ? AND usu_tx_senha = ?',
      whereArgs: [email, senha],
    );
    if (resultado.isNotEmpty) return resultado.first;
    return null;
  }

  Future<int> inserirDados(String tabela, Map<String, dynamic> dados) async {
    Database db = await bancoDeDados;
    return await db.insert(tabela, dados);
  }

  Future<List<Map<String, dynamic>>> consultarDados(String tabela) async {
    Database db = await bancoDeDados;
    return await db.query(tabela);
  }

  Future<int> alternarDados(String tabela, Map<String, dynamic> novosDados, String colunaId, int id) async {
    Database db = await bancoDeDados;
    return await db.update(
      tabela,
      novosDados,
      where: '$colunaId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deletarDados(String tabela, String colunaId, int id) async {
    Database db = await bancoDeDados;
    return await db.delete(
      tabela,
      where: '$colunaId = ?',
      whereArgs: [id],
    );
  }
}