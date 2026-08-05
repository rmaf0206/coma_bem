abstract class Usuario {
  int _idUsuario;
  String _nomeUsuario;
  String _email;
  String _senha;

  Usuario(this._idUsuario, this._nomeUsuario, this._email, this._senha);

  int get idUsuario => _idUsuario;
  String get nomeUsuario => _nomeUsuario;
  String get email => _email;
  String get senha => _senha;

  set nomeUsuario(String nome) {
    _nomeUsuario = nome;
  }

  set email (String email){
    _email = email;
  }
  set senha (String senha){
    _senha = senha;
  
  if (senha.length >= 6) {
  print('Sua senha foi salva com sucesso.');
  } else {
  print('Não foi possivel salvar sua senha');
  }
  }

  void exibirMenu();
  void gerenciarConta();
}