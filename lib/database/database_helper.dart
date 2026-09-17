import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instancia =
      DatabaseHelper._interno();

  static final DatabaseHelper instancia = _instancia;

  static Database? _bancoDeDados;

  factory DatabaseHelper() {
    return _instancia;
  }

  DatabaseHelper._interno();

  Future<Database> get bancoDeDados async {
    if (_bancoDeDados != null) {
      return _bancoDeDados!;
    }

    _bancoDeDados = await _iniciarBanco();

    return _bancoDeDados!;
  }

  Future<Database> _iniciarBanco() async {
    final caminhoBanco = await getDatabasesPath();

    final caminhoCompleto =
        join(caminhoBanco, 'coma_bem.db');

    return await openDatabase(
      caminhoCompleto,
      version: 1,
      onCreate: _criarTabelas,
    );
  }

  Future<void> _criarTabelas(
    Database db,
    int versao,
  ) async {
    await db.execute('''
      CREATE TABLE usuario (
        usu_id_usuario INTEGER PRIMARY KEY AUTOINCREMENT,
        usu_tx_nome TEXT NOT NULL,
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
        pra_im_foto TEXT,
        pra_id_restaurante INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE avaliacao (
        avl_id_avaliacao INTEGER PRIMARY KEY AUTOINCREMENT,
        avl_nu_ranking INTEGER NOT NULL,
        avl_tx_recomendacao TEXT NOT NULL,
        avl_id_prato INTEGER NOT NULL,
        avl_id_usuario INTEGER NOT NULL
      )
    ''');

    await db.insert(
      'usuario',
      {
        'usu_tx_nome': 'Administrador',
        'usu_tx_email': 'admin@comabem.com',
        'usu_tx_senha': 'senha123',
      },
    );
  }

  Future<Map<String, dynamic>?> autenticarUsuario(
    String email,
    String senha,
  ) async {
    final db = await bancoDeDados;

    final resultado = await db.query(
      'usuario',
      where:
          'usu_tx_email = ? AND usu_tx_senha = ?',
      whereArgs: [
        email.trim(),
        senha,
      ],
      limit: 1,
    );

    if (resultado.isNotEmpty) {
      return resultado.first;
    }

    return null;
  }

  Future<int> inserirDados(
    String tabela,
    Map<String, dynamic> dados,
  ) async {
    final db = await bancoDeDados;

    return await db.insert(
      tabela,
      dados,
    );
  }

  Future<List<Map<String, dynamic>>> consultarDados(
    String tabela,
  ) async {
    final db = await bancoDeDados;

    return await db.query(tabela);
  }

  Future<int> alternarDados(
    String tabela,
    Map<String, dynamic> novosDados,
    String colunaId,
    int id,
  ) async {
    final db = await bancoDeDados;

    return await db.update(
      tabela,
      novosDados,
      where: '$colunaId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deletarDados(
    String tabela,
    String colunaId,
    int id,
  ) async {
    final db = await bancoDeDados;

    return await db.delete(
      tabela,
      where: '$colunaId = ?',
      whereArgs: [id],
    );
  }

  Future<void> inserirRestaurante(
    Map<String, dynamic> dadosRestaurante,
  ) async {
    final db = await bancoDeDados;

    await db.insert(
      'restaurante',
      dadosRestaurante,
    );
  }

  Future<List<Map<String, dynamic>>>
      listarRestaurantesPorTipo(
    String tipo,
  ) async {
    final db = await bancoDeDados;

    return await db.query(
      'restaurante',
      where: 'res_ds_tipo_culinaria = ?',
      whereArgs: [tipo],
    );
  }

  Future<void> atualizarAvaliacao(
    int idAvaliacao,
    int novaNota,
    String novoTexto,
  ) async {
    final db = await bancoDeDados;

    await db.update(
      'avaliacao',
      {
        'avl_nu_ranking': novaNota,
        'avl_tx_recomendacao': novoTexto,
      },
      where: 'avl_id_avaliacao = ?',
      whereArgs: [idAvaliacao],
    );
  }

  Future<void> removerPrato(
    int idPrato,
  ) async {
    final db = await bancoDeDados;

    await db.delete(
      'prato',
      where: 'pra_id_prato = ?',
      whereArgs: [idPrato],
    );
  }

  Future<List<Map<String, dynamic>>>
      buscarRestaurantePorNome(
    String termoBusca,
  ) async {
    final db = await bancoDeDados;

    return await db.query(
      'restaurante',
      where: 'res_nm_restaurante LIKE ?',
      whereArgs: ['%$termoBusca%'],
    );
  }

  Future<List<Map<String, dynamic>>>
      listarPratosPorRestaurante(
    int idRestaurante,
  ) async {
    final db = await bancoDeDados;

    return await db.query(
      'prato',
      where: 'pra_id_restaurante = ?',
      whereArgs: [idRestaurante],
    );
  }
}