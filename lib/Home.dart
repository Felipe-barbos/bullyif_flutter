import 'package:bully_flutter/Mensagem.dart';
import 'package:bully_flutter/model/Usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();

    Navigator.pushReplacementNamed(context, "/login");
  }

  var _imagem;
  var _iduseron;
  bool _flyingImage = false;
  var _urlImage;

  var nomeUsuario, matriculaUsuario;

  Future _recuperarImagem(var origemImage) async {
    var imagemSelecionada;
    switch (origemImage) {
      case "camera":
        imagemSelecionada = await ImagePicker().getImage(
          source: ImageSource.camera,
        );
        break;
      case "galeria":
        imagemSelecionada = await ImagePicker().getImage(
          source: ImageSource.gallery,
        );
        break;
    }

    setState(() {
      _imagem = imagemSelecionada;
      if (_imagem != null) {
        _flyingImage = true;
        _uploadImage();
      }
    });
  }

  Future _uploadImage() async {
    var file = File(_imagem.path);
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference pastaRaiz = storage.ref();
    Reference archive = pastaRaiz.child("perfil").child(_iduseron + "png");

    //upload da imagem
    UploadTask task = archive.putFile(file);

    //controlando o progresso do upload.
    task.snapshotEvents.listen((TaskSnapshot storageEvent) {
      if (storageEvent.state == TaskState.running) {
        setState(() {
          _flyingImage = true;
        });
      } else if (storageEvent.state == TaskState.success) {
        setState(() {
          _flyingImage = false;
        });
      }
    });

    //recuperar url da imagem
    task.then((TaskSnapshot snapshot) {
      _recuperarUrlImagem(snapshot);
    });
  }

  Future _recuperarUrlImagem(TaskSnapshot snapshot) async {
    var url = await snapshot.ref.getDownloadURL();
    _atualizarUrlImagemFirestore(url);
    setState(() {
      _urlImage = url;
    });
  }

  _atualizarUrlImagemFirestore(var url) {
    FirebaseFirestore db = FirebaseFirestore.instance;

    Map<String, dynamic> dadosAtualizar = {"urlImagem": url};

    db.collection("usuarios").doc(_iduseron).update(dadosAtualizar);
  }

  _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? useron = await auth.currentUser;
    _iduseron = useron?.uid;

    //recuperar o nome e a url
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot =
        await db.collection("usuarios").doc(_iduseron).get();

    dynamic dadosUsuario = snapshot.data();
    Usuario usuario = new Usuario();

    setState(() {
      nomeUsuario = dadosUsuario["nome"];
      matriculaUsuario = dadosUsuario["matricula"];
    });

    if (dadosUsuario["urlImagem"] != null) {
      setState(() {
        _urlImage = dadosUsuario["urlImagem"];
      });
    } else {
      _urlImage =
          "https://firebasestorage.googleapis.com/v0/b/bullyiflutter.appspot.com/o/perfil%2Fusuario.png?alt=media&token=11f37352-1b46-4031-9b5d-7ab8286081c4";
    }
  }

  Future _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    User? usuarioLogado = await auth.currentUser;
    if (usuarioLogado == null) {
      Navigator.pushReplacementNamed(context, "/login");
    } else {}
  }

  @override
  void initState() {
    super.initState();
    _verificarUsuarioLogado();
    _recuperarDadosUsuario();
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
            Row(
              children: [
                Padding(padding: EdgeInsets.fromLTRB(25, 30, 15, 0)),
                Container(
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: kElevationToShadow[3],
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          _urlImage != null ? NetworkImage(_urlImage) : null,
                      child: Row(
                        children: [
                          Padding(padding: EdgeInsets.all(10)),
                          GestureDetector(
                            onTap: () {
                              _recuperarImagem("camera");
                            },
                            child: Icon(
                              Icons.camera_alt,
                              size: 30,
                              color: Colors.grey,
                            )
                            ,
                          ),
                          GestureDetector(
                            onTap: () {
                              _recuperarImagem("galeria");
                            },
                            child: Icon(
                              Icons.photo,
                              size: 30,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      children: [
                        //imprimindo o nome do usuário
                        if (nomeUsuario != null)
                          Text(
                            nomeUsuario,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                        else
                          Text(
                            "Usuário",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        //imprimindo a matricula do usuário
                        if (matriculaUsuario != null)
                          Text(
                            matriculaUsuario,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                        else
                          Text(
                            "000000000000",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                      ],
                    )),
                    Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 30)),
                    IconButton(
                  onPressed: _deslogarUsuario,
                  icon: Icon(
                    Icons.power_settings_new,
                    size: 30,
                    color: Colors.white,
                  ))
              ],
            ),
            Padding(padding: EdgeInsets.fromLTRB(35, 15, 20, 0),
            child: Row(children: [
                   SizedBox(
                    width: 120,
                    height: 65,
                    child: RaisedButton(
                      child: Center(
                        child: Column(
                          children: [
                            Image.asset(
                              "images/denuncia.png",
                              width: 45,
                              height: 45,
                            ),
                            Text(
                              "DENÚNCIA",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      elevation: 7.0,
                      color: Color(0xff4fa167),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35)),
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, "/listaDenuncia");
                      },
                    ),
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(20, 0, 30, 0)),
                 SizedBox(
                    width: 120,
                    height: 65,
                    child: RaisedButton(
                      child: Center(
                        child: Column(
                          children: [
                            Image.asset(
                              "images/chat.png",
                              width: 45,
                              height: 45,
                            ),
                            Text(
                              "CHAT",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      elevation: 7.0,
                      color: Color(0xff4fa167),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35)
                          
                          ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, "/mensagem");
                      },
                    ),
                  ),
                
            ]),)
          ],
        ) //Image.asset("images/logocadastro.png")

            ),
        backgroundColor: Color(0xff9ecfc0),
        toolbarHeight: 220,
        toolbarOpacity: 0.5,
        automaticallyImplyLeading: false,
        
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0xffdfdfdf)),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
