import 'package:bully_flutter/model/Conversa.dart';
import 'package:bully_flutter/model/Usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AbaContatos extends StatefulWidget {
  const AbaContatos({Key? key}) : super(key: key);

  @override
  _AbaContatosState createState() => _AbaContatosState();
}

class _AbaContatosState extends State<AbaContatos> {
  var _idUsuarioLogado;
  var _emailUsuarioLogado;

  var _imagemUsuarioPadrao =
      "https://firebasestorage.googleapis.com/v0/b/bullyiflutter.appspot.com/o/perfil%2Fusuario.png?alt=media&token=11f37352-1b46-4031-9b5d-7ab8286081c4";

//recuperando todos os usuários cadastrados no banco de dados e retornando uma lista.
  Future<List<Usuario>> _recuperarContatos() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot = await db.collection("usuarios").get();

    List<Usuario> listaUsuarios = [];

    for (DocumentSnapshot item in querySnapshot.docs) {
      Map dadosmap = {};
      var dados = item.data();
      dadosmap = dados as Map;

      if (dados["email"] == _emailUsuarioLogado) continue;
      if (dados["urlImagem"] == null) {
        dados["urlImagem"] = _imagemUsuarioPadrao;
      }

      Usuario usuario = Usuario();
      usuario.idUsuario = item.id;
      usuario.email = dados["email"];
      usuario.nome = dados["nome"];
      usuario.matricula = dados["matricula"];
      usuario.urlImagem = dados["urlImagem"];

      listaUsuarios.add(usuario);
      listaUsuarios.sort(((a, b) => a.nome.toLowerCase().compareTo(b.nome.toLowerCase())));
    }

    return listaUsuarios;
  }

  _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser;

    _idUsuarioLogado = usuarioLogado?.uid;
    _emailUsuarioLogado = usuarioLogado?.email;
  }

  @override
  void initState() {
    _recuperarContatos();
    _recuperarDadosUsuario();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color(0xffdfdfdf)),
      padding: EdgeInsets.all(12),
      child: FutureBuilder<List<Usuario>>(
        future: _recuperarContatos(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  children: [
                    Text("Carregando Contatos"),
                    CircularProgressIndicator()
                  ],
                ),
              );
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (_, indice) {
                    List<Usuario> listaItens = snapshot.data!;
                    Usuario usuario = listaItens[indice];
                    return Padding(
                      padding: EdgeInsets.all(4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: kElevationToShadow[2],
                          ),
                          //color: Colors.white,
                          child: ListTile(
                            onTap: (){
                              Navigator.pushNamed(context, "/batepapo",
                              arguments: usuario);
                            },
                            iconColor: Colors.white,
                            leading: Container(
                                child: CircleAvatar(
                                    maxRadius: 25,
                                    backgroundColor: Colors.white,
                                    backgroundImage: usuario.urlImagem != null
                                        ? NetworkImage(usuario.urlImagem)
                                        : null)),
                            title: Text(
                              usuario.nome,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            subtitle: Text(
                              usuario.matricula,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                  fontSize: 14),
                            ),
                            trailing: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      Text("Estudante"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
              break;
          }
          return Container();
        },
      ),
    );
  }
}
