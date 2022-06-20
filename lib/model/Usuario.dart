class Usuario {

  var _idUsuario;
  var _nome;
  var _matricula;
  var _email;
  var _senha;
  var _urlImagem;

    Usuario();

    Map<String, dynamic> toMap(){
      Map<String, dynamic> map = {
          "nome": this.nome,
          "matricula": this.matricula,
          "email": this.email
        
      };
      return map;
    }

    String get idUsuario => _idUsuario;
    
    set idUsuario (String value){
      _idUsuario = value;
    }

    String get urlImagem => _urlImagem;
    
    set urlImagem(String value){
      _urlImagem = value;
    }
    
  String get nome => _nome;

  set nome(String value){
    _nome = value;
  }

  String get email => _email;

  set email(String value){
    _email = value;
  }

  String get matricula => _matricula;

  set matricula(String value){
    _matricula = value;
  }

  String get senha => _senha;

  set senha(String value){
    _senha = value;
  }

}
