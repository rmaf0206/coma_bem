import 'usuario.dart';

class Administrador extends Usuario {
  Administrador(super.idUsuario, super.nomeUsuario, super.email, super.senha);

  @override
  void exibirMenu() {
    print('--- Menu do Administrador ---');
    print('1. Gerenciar Produtos');
    print('2. Ver Relatórios');
  }

  @override
  void gerenciarConta() {
    print('Gerenciando permissões do sistema');
  }
}