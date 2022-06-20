import 'package:bully_flutter/Cadastro.dart';
import 'package:bully_flutter/Home.dart';
import 'package:bully_flutter/model/Usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();

  String _mensagemErro = "";
 

  _validarCamposLogin() {
    //VALIDA OS DADOS DIGITADOS NA TELA DE LOGIN

    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

        if (email.isNotEmpty) {
          if (senha.isNotEmpty) {
            
              Usuario usuario = Usuario();
              usuario.email = email;
              usuario.senha = senha;

              _logarUsuario(usuario);
            
          } else {
            setState(() {
              _mensagemErro = "Senha precisa ter no minimo 6 caracteres!";
            });
          }
        } else {
          setState(() {
            _mensagemErro = "Preencha o E-mail!";
          });
        }
      
  }

  _logarUsuario(Usuario usuario){

    FirebaseAuth auth = FirebaseAuth.instance;

    auth.signInWithEmailAndPassword(
      email: usuario.email, 
      password: usuario.senha
      ).then((firebaseuer){
       Navigator.pushReplacementNamed(context, "/home");
      }).catchError((error){
        setState(() {
              _mensagemErro = "Erro ao logar!! Email e senha invalidos!";
            });
      });
  }

  Future _verificarUsuarioLogado() async{
     
    FirebaseAuth auth = FirebaseAuth.instance;

    //auth.signOut();

    User? usuarioLogado = await auth.currentUser;
    if(usuarioLogado != null){
        Navigator.pushReplacementNamed(context, "/home");
    }
    else{ 

    }
  }
@override
  void initState() {
    // TODO: implement initState
    _verificarUsuarioLogado();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xff9ecfc0)),
        padding: EdgeInsets.all(30),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 60),
                  child: Image.asset(
                    "images/logoif.png",
                    width: 200,
                    height: 200,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextField(
                      autofocus: true,
                      controller: _controllerEmail,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "E-mail",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none)),
                    )),
                TextField(
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  obscureText: true,
                  controller: _controllerSenha,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Senha",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none)),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                      child: Text(
                        "Entrar",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: Color(0xff4fa167),
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      shape: RoundedRectangleBorder(  
                        borderRadius: BorderRadius.circular(18)
                      ),
                      onPressed: () {
                        _validarCamposLogin();
                      }),
                ),
                Center(   
                  child: GestureDetector(  
                    child: Text(  
                      "Não tem conta? cadastre-se",
                      style: TextStyle(   
                        color: Colors.white
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                         MaterialPageRoute(
                           builder: (context) => Cadastro()));
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                child: Center(  
                  child: Text(
                  _mensagemErro,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  
}
