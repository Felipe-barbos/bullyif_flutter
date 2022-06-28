import 'package:bully_flutter/model/Denuncia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ListaDenuncia extends StatefulWidget {
  const ListaDenuncia({Key? key}) : super(key: key);

  @override
  State<ListaDenuncia> createState() => _ListaDenunciaState();
}

class _ListaDenunciaState extends State<ListaDenuncia> {
  var _idUsuarioLogado;
  var _emailUsuarioLogado;
  var _imagemUsuarioPadrao =
      "https://firebasestorage.googleapis.com/v0/b/bullyiflutter.appspot.com/o/perfil%2Fusuario.png?alt=media&token=11f37352-1b46-4031-9b5d-7ab8286081c4";

  //RECUPERANDO TODAS AS DENÚNCIAS DO BANCO DE DADOS

  Future<List<Denuncia>> _recuperarDenuncia() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot = await db.collection("denuncias").get();

    List<Denuncia> listaDenuncias = [];

    for (DocumentSnapshot item in querySnapshot.docs) {
      Map dadosmap = {};
      var dados = item.data();
      dadosmap = dados as Map;

      if (dados["identificadorUsuario"] == _idUsuarioLogado) continue;

      Denuncia denuncia = Denuncia();
      denuncia.idDenuncia = item.id;
      denuncia.identificacaoUsuario = dados["identificacaoUsuario"];
      denuncia.urlImagemUsuario = dados["urlImagemUsuario"];
      denuncia.identificacaoVitima = dados["identificacaoVitima"];
      denuncia.identificacaoAgressor = dados["identificacaoAgressor"];
      denuncia.localOcorrido = dados["localOcorrido"];
      denuncia.statusDenuncia = dados["statusDenuncia"];
      denuncia.tipAgressao = dados["tipoAgressao"];
      denuncia.dataOcorrido = dados["dataOcorrido"];
      denuncia.horarioOcorrido = dados["horarioOcorrido"];
      denuncia.descricao = dados["descricao"];

      listaDenuncias.add(denuncia);
    }
    return listaDenuncias;
  }

  _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser;

    _idUsuarioLogado = usuarioLogado?.uid;
    _emailUsuarioLogado = usuarioLogado?.email;
  }

  @override
  void initState() {
    _recuperarDenuncia();
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
                Navigator.pushReplacementNamed(context, "/home");
              },
              icon: Icon(
                Icons.arrow_back,
                size: 25,
              ),
            )),
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0xffdfdfdf)),
        padding: EdgeInsets.all(12),
        child: FutureBuilder<List<Denuncia>>(
            future: _recuperarDenuncia(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child: Column(
                      children: [
                        Text("Carregando Denuncias"),
                        CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 5.0,
                        )
                      ],
                    ),
                  );
                  break;
                case ConnectionState.active:
                case ConnectionState.done:
                  return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (_, indice) {
                        List<Denuncia> listaItens = snapshot.data!;
                        Denuncia denuncia = listaItens[indice];
                        return denuncia.identificacaoUsuario != _idUsuarioLogado
                            ? Text("")
                            : Padding(
                                padding: EdgeInsets.all(4),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: kElevationToShadow[2],
                                    ),
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.pushNamed(context, "/denunciaEfetuada",
                                        arguments: denuncia);
                                      },
                                      iconColor: Colors.white,
                                      leading: Container(
                                        child: CircleAvatar(
                                          maxRadius: 25,
                                          backgroundColor: Colors.white,
                                          backgroundImage:
                                              denuncia.urlImagemUsuario != null
                                                  ? NetworkImage(
                                                      denuncia.urlImagemUsuario)
                                                  : NetworkImage(
                                                    _imagemUsuarioPadrao
                                                  ),
                                        ),
                                      ),
                                      title: Text(
                                        denuncia.tipAgressao,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      subtitle: Text(
                                        denuncia.localOcorrido,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black,
                                            fontSize: 14),
                                      ),
                                      trailing: FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: Row(children: [
                                          Column(
                                            children: [
                                              Text(denuncia.idDenuncia),
                                            ],
                                          )
                                        ]),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                      });
                  break;
              }
              return Container();
            }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff4fa167),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pushReplacementNamed(context, "/efetuarDenuncia");
        },
      ),
    );
  }
}
