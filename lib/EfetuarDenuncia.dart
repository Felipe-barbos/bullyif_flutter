import 'dart:math';

import 'package:bully_flutter/model/Denuncia.dart';
import 'package:bully_flutter/model/Usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EfetuarDenuncia extends StatefulWidget {
  const EfetuarDenuncia({Key? key}) : super(key: key);

  @override
  State<EfetuarDenuncia> createState() => _EfetuarDenunciaState();
}

class _EfetuarDenunciaState extends State<EfetuarDenuncia> {

  //Variáveis com identificação do usuário
  var _idUsuarioLogado;
  var _emailUsuarioLogado;
  var _urlImage;
  var _nomeUsuario;
  var _matricula;
  

  //CONTROLADORES
  TextEditingController _controllerIdentiVitima = TextEditingController();
  TextEditingController _controllerIdentiAgressor = TextEditingController();
  TextEditingController _controllerLocalOcorrido = TextEditingController();
  TextEditingController _controllerDataOcorrido = TextEditingController();
  TextEditingController _controllerHorario = TextEditingController();
  TextEditingController _controllerTipoAgressao = TextEditingController();
  TextEditingController _controllerDescricao = TextEditingController();

_validarCamposDenuncia(){
  // RECUPERAR DADOS DOS CAMPOS PREENCHIDOS NA TELA CADASTRO
  var identificadorVitima = _controllerIdentiVitima.text;
  var identificadorAgressor = _controllerIdentiAgressor.text;
  var localOcorrido = _controllerLocalOcorrido.text;
  var dataOcorrido = _controllerDataOcorrido.text;
  var horario = _controllerHorario.text;
  var tipoAgressao = _controllerTipoAgressao.text;
  var descricao = _controllerDescricao.text;

  if(identificadorVitima.isNotEmpty ){
    if(identificadorAgressor.isNotEmpty){
      if(tipoAgressao.isNotEmpty){
          int id;
        //INSTANCIANDO AS INFORMAÇÕES NO OBJETO DENUNCIA
         Denuncia denuncia = Denuncia();
         //criando uma ID para denuncia
         Random random = new Random();
         int idenuncia = random.nextInt(9999);
         denuncia.idDenuncia = idenuncia.toString();
         denuncia.identificacaoUsuario = _idUsuarioLogado;
         denuncia.identificacaoVitima = identificadorVitima;
         denuncia.identificacaoAgressor = identificadorAgressor;
         denuncia.statusDenuncia = "Não Resolvido";
         denuncia.localOcorrido = localOcorrido;
         denuncia.dataOcorrido = dataOcorrido;
         denuncia.horarioOcorrido = horario;
         denuncia.tipAgressao = tipoAgressao;
         denuncia.descricao = descricao;

         Fluttertoast.showToast(
      msg: _matricula,
      toastLength: Toast.LENGTH_LONG,
      fontSize: 16,
      backgroundColor: Colors.grey,
      textColor: Colors.white
      );

         

         _cadastrarDenuncia(denuncia);
      }
      else{
        Fluttertoast.showToast(
      msg: "Tipo de Agressão não mencionado!",
      toastLength: Toast.LENGTH_LONG,
      fontSize: 16,
      backgroundColor: Colors.grey,
      textColor: Colors.white
      );
      }

    }
    else{
      Fluttertoast.showToast(
      msg: "Identificação do Agressor não definida",
      toastLength: Toast.LENGTH_LONG,
      fontSize: 16,
      backgroundColor: Colors.grey,
      textColor: Colors.white
      );
    }
  }else{
    Fluttertoast.showToast(
      msg: "Identificação da Vítima não definida",
      toastLength: Toast.LENGTH_LONG,
      fontSize: 16,
      backgroundColor: Colors.grey,
      textColor: Colors.white
      );
  }
  

}
_cadastrarDenuncia (Denuncia denuncia){

  // SALVAR DADOS DA DENUNCIA NO BANCO DE DADOS
  FirebaseFirestore db = FirebaseFirestore.instance;
  db.collection("denuncias")
  .doc(denuncia.idDenuncia)
  .set(denuncia.toMap());
  
 

  /*
  +denuncias
    +IdUsuario que efetuou a denuncia
      + Id da denuncia efetuada
        + informações da denuncia

  */
  Fluttertoast.showToast(
      msg: "Denúncia Enviada com Sucesso!",
      toastLength: Toast.LENGTH_LONG,
      fontSize: 16,
      backgroundColor: Colors.grey,
      textColor: Colors.white
      );
  

}
_recuperarDadosUsuario() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser;
    
    setState(() {
      _idUsuarioLogado = usuarioLogado?.uid;
    _emailUsuarioLogado = usuarioLogado?.email;
    });
    

     //Recuperando dados do usuário logado no firebase
        FirebaseFirestore db = FirebaseFirestore.instance;
        DocumentSnapshot snapshot = await db.collection("usuarios").doc(_idUsuarioLogado).get();
        dynamic dadosUsuario = snapshot.data();

        setState(() {
          
           if(dadosUsuario["urlImagem"] != null ){
            setState(() {
              _urlImage = dadosUsuario["urlImagem"];
            });
           }
           else{
            _urlImage = 
            "https://firebasestorage.googleapis.com/v0/b/bullyiflutter.appspot.com/o/perfil%2Fusuario.png?alt=media&token=11f37352-1b46-4031-9b5d-7ab8286081c4";
           }
           _nomeUsuario = dadosUsuario["nome"];
           _matricula = dadosUsuario ["matricula"];
        });

        


  }

  @override
  void initState() {
    _recuperarDadosUsuario();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(80, 0, 80, 0),
                    child: Image.asset(
                      "images/denuncia.png",
                      width: 100,
                      height: 100,
                    ),
                  ),
                  Text(
                    "DENÚNCIAS",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )
                ],
              )
            ],
          ),
        ),
        backgroundColor: Color(0xff9ecfc0),
        toolbarHeight: 150,
        toolbarOpacity: 0.5,
        automaticallyImplyLeading: false,
        leading: Padding(
            padding: EdgeInsets.only(bottom: 60),
            child: IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/listaDenuncia");
              },
              icon: Icon(
                Icons.arrow_back,
                size: 25,
              ),
            )),
      ),
      body: Container(
          decoration: BoxDecoration(color: Color(0xffdfdfdf)),
          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Container(
            decoration: BoxDecoration(
                color: Color(0xffdfdfdf),
                borderRadius: BorderRadius.circular(10),
                boxShadow: kElevationToShadow[3]),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            Text(
                              "Identificação da Vítima:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54
                              ),
                            ),
                            Container(
                              width: 320,
                              height: 70,
                              child: TextField(
                                controller: _controllerIdentiVitima,
                                keyboardType: TextInputType.text,
                                style: TextStyle(fontSize: 16),
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(32, 14, 32, 14),
                                    hintText: "Identificação da Vítima",
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide.none)),
                              ),
                            ),
                          ],
                        )),
                    Padding(
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: [
                            Text(
                              "Identificação do Agressor:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54
                              ),
                            ),
                            Container(
                              width: 320,
                              height: 70,
                              child: TextField(
                                controller: _controllerIdentiAgressor,
                                keyboardType: TextInputType.text,
                                style: TextStyle(fontSize: 16),
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(32, 14, 32, 14),
                                    hintText: "Identificação da Agressor",
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide.none)),
                              ),
                            ),
                          ],
                        )),
                    Padding(
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: [
                            Text(
                              "Local do Ocorrido:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54
                              ),
                            ),
                            Container(
                              width: 320,
                              height: 70,
                              child: TextField(
                                controller: _controllerLocalOcorrido,
                                keyboardType: TextInputType.text,
                                style: TextStyle(fontSize: 16),
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(32, 14, 32, 14),
                                    hintText: "Local do Ocorrido",
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide.none)),
                              ),
                            ),
                          ],
                        )),
                    Row(
                      children: [
                        Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Column(
                              children: [
                                Text(
                                  "Data do Ocorrido:",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54
                                  ),
                                ),
                                Container(
                                    width: 140,
                                    height: 70,
                                    child: TextField(
                                      controller: _controllerDataOcorrido,
                                      keyboardType: TextInputType.datetime,
                                      style: TextStyle(fontSize: 16),
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.fromLTRB(
                                              13, 14, 13, 14),
                                          hintText: "Data do Ocorrido:",
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: BorderSide.none)),
                                    ))
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Column(
                              children: [
                                Text(
                                  "Horário:",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54
                                  ),
                                ),
                                Container(
                                    width: 140,
                                    height: 70,
                                    child: TextField(
                                      controller: _controllerHorario,
                                      keyboardType: TextInputType.text,
                                      style: TextStyle(fontSize: 16),
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.fromLTRB(
                                              13, 14, 13, 14),
                                          hintText: "Horário:",
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: BorderSide.none)),
                                    ))
                              ],
                            )),
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: [
                            Text(
                              " Tipo de Agressão:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54
                              ),
                            ),
                            Container(
                              width: 320,
                              height: 70,
                              child: TextField(
                                controller: _controllerTipoAgressao,
                                keyboardType: TextInputType.text,
                                style: TextStyle(fontSize: 16),
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(32, 14, 32, 14),
                                    hintText: "Tipo de Agressão",
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide.none)),
                              ),
                            ),
                          ],
                        )),
                    Padding(
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: [
                            Text(
                              "Descrição:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54
                              ),
                            ),
                            Container(
                              width: 320,
                              height: 150,
                              child: TextField(
                                controller: _controllerDescricao,
                                keyboardType: TextInputType.text,
                                style: TextStyle(fontSize: 16),
                                maxLength: 300,
                                maxLines: 5,
                                minLines: 1,
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(32, 14, 32, 14),
                                    hintText: "Descrição: ",
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide.none,
                                        )),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff4fa167),
        child: Icon(
          Icons.send,
          color: Colors.white,
        ),
        onPressed: () {
          _validarCamposDenuncia();
        },
      ),
    );
  }
}
