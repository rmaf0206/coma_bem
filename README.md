Aplicativo Coma Bem

O Coma Bem é um aplicativo mobile desenvolvido para conectar pessoas que gostam de culinária a restaurantes locais. O projeto foi desenvolvido como parte da unidade curricular de Banco de Dados Mobile, com o objetivo de aplicar conhecimentos de banco de dados, programação orientada a objetos e desenvolvimento de aplicativos com Flutter.

O aplicativo foi desenvolvido utilizando Dart e Flutter, com banco de dados MySQL e MySQL Workbench para a criação e gerenciamento do banco. Também foram utilizados conceitos de Programação Orientada a Objetos (POO) e o padrão DAO (Data Access Object).

O banco de dados foi organizado seguindo as regras de normalização 1FN, 2FN e 3FN, buscando evitar informações repetidas e manter os dados organizados. As principais entidades utilizadas no sistema são Usuário, Cliente e Administrador.

Na programação, foram utilizados os principais conceitos de orientação a objetos. O encapsulamento é utilizado para proteger os atributos das classes, que são acessados por meio de getters e setters. A herança permite que as classes Cliente e Administrador utilizem características da classe Usuário. Também foi utilizado polimorfismo, principalmente no método exibirMenu(), que pode apresentar opções diferentes de acordo com o tipo de usuário.

O sistema também possui operações de cadastro, consulta, atualização e exclusão de usuários. Essas operações são realizadas por meio da camada de acesso aos dados, responsável pela comunicação com o banco de dados.

Para executar o projeto, é necessário clonar o repositório e abrir a pasta no Visual Studio Code. Também é necessário ter o Flutter instalado e configurado. Depois, basta executar o comando flutter pub get para instalar as dependências e, em seguida, executar o projeto com flutter run ou pressionando F5 no Visual Studio Code.

Desenvolvido por Ricardo Moura.
