import 'package:bully_flutter/BatePapo.dart';
import 'package:bully_flutter/Cadastro.dart';
import 'package:bully_flutter/DenunciaEfetuada.dart';
import 'package:bully_flutter/EfetuarDenuncia.dart';
import 'package:bully_flutter/Home.dart';
import 'package:bully_flutter/ListaDenuncia.dart';
import 'package:bully_flutter/Login.dart';
import 'package:bully_flutter/Mensagem.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
static  var args;

  static Route<dynamic>? generateRoute (RouteSettings settings){

     

      args = settings.arguments;

    switch(settings.name){
      case "/":
      return MaterialPageRoute(builder: (_) => Login());
      case "/login":
      return MaterialPageRoute(builder: (_) => Login());
      case "/cadastro":
      return MaterialPageRoute(builder: (_) => Cadastro());
      case "/home":
      return MaterialPageRoute(builder: (_) => Home()) ;
      case "/mensagem":
      return MaterialPageRoute(builder: (_) => Mensagem());
       case "/batepapo":
      return MaterialPageRoute(builder: (_) => BatePapo(args!));
      case "/listaDenuncia":
      return MaterialPageRoute(builder: (_) => ListaDenuncia());
      case "/efetuarDenuncia":
      return MaterialPageRoute(builder: (_) => EfetuarDenuncia());
      case "/denunciaEfetuada":
      return MaterialPageRoute(builder: (_) => DenunciaEfetuada(args!));
      default:
      _erroRota();
    }
  }

  static Route<dynamic>? _erroRota(){
    return MaterialPageRoute(builder: (_){
        return Scaffold(
          appBar: AppBar(
            title: Text("Tela não encontrada!"),
      
          ),
          body: Center(  
            child: Text("Tela não encontrada!"),
          ),
          
        );
    });
  }
}