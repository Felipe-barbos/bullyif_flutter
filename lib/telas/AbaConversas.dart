import 'dart:async';
import 'dart:collection';
import 'dart:ffi';
import 'package:bully_flutter/model/Conversa.dart';
import 'package:bully_flutter/model/Usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AbaConversas extends StatefulWidget {
  const AbaConversas({Key? key}) : super(key: key);

  @override
  _AbaConversasState createState() => _AbaConversasState();
}

class _AbaConversasState extends State<AbaConversas> {
  List<Conversa> _listaConversas = [];

  final _controller = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore db = FirebaseFirestore.instance;
  var _idUsuarioLogado;

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
    Conversa conversa = Conversa();
    conversa.nome = "Ana clara";
    conversa.mensagem = "Olá, tudo bem?";
    conversa.caminhoFoto =
        "https://firebasestorage.googleapis.com/v0/b/bullyiflutter.appspot.com/o/perfil%2Fperfil1.jpg?alt=media&token=dc30a110-a2bd-4abd-a743-76a112188350";

    _listaConversas.add(conversa);
  }

  _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? idUsuarioLogado = await auth.currentUser;

    _idUsuarioLogado = idUsuarioLogado!.uid;

    _adicionarListenerConversas();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.close();
  }

  Stream<QuerySnapshot>? _adicionarListenerConversas() {
    final stream = db
        .collection("conversas")
        .doc(_idUsuarioLogado)
        .collection("ultima_conversa")
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _controller.stream,
      builder: (context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: [
                  Text("Carregando conversas"),
                  CircularProgressIndicator()
                ],
              ),
            );
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text("Erro ao carregar os dados!");
            } else {
              QuerySnapshot querySnapshot = snapshot.data! as QuerySnapshot;
              if (querySnapshot.docs.length == 0) {
                return Center(
                  child: Text(
                    "Você não tem nenhuma mensagem ainda :(",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                );
              }
              return Container(
                  decoration: BoxDecoration(color: Color(0xffdfdfdf)),
                  padding: EdgeInsets.all(12),
                  child: ListView.builder(
                      itemCount: querySnapshot.docs.length,
                      itemBuilder: (context, indice) {
                        //recuperando dados que serão exibidos na lista de conversas
                        List<DocumentSnapshot> conversas =
                            querySnapshot.docs.toList();
                        DocumentSnapshot item = conversas[indice];
                        String urlImagem = item["caminhoFoto"];
                        String tipoMensagem = item["tipoMensagem"];
                        String mensagem = item["mensagem"];
                        String nome = item["nome"];
                        String idDestinatario = item["idDestinatario"];

                        Usuario usuario = Usuario();
                        usuario.nome = nome;
                        usuario.urlImagem = urlImagem;
                        usuario.idUsuario = idDestinatario;
                        return Padding(
                            padding: EdgeInsets.all(4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: kElevationToShadow[2]),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.pushNamed(context, "/batepapo",
                                        arguments: usuario);
                                  },
                                  iconColor: Colors.white,
                                  leading: Container(
                                    child: CircleAvatar(
                                        maxRadius: 25,
                                        backgroundColor: Colors.white,
                                        backgroundImage: urlImagem != null
                                            ? NetworkImage(urlImagem)
                                            : NetworkImage(
                                                "https://firebasestorage.googleapis.com/v0/b/bullyiflutter.appspot.com/o/perfil%2Fusuario.png?alt=media&token=11f37352-1b46-4031-9b5d-7ab8286081c4")),
                                  ),
                                  title: Text(
                                    nome,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    tipoMensagem == "texto"
                                        ? mensagem
                                        : "IMAGEM",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                  ),
                                ),
                              ),
                            ));
                      }));
            }
        }
      },
    );
  }
}
