import 'package:bully_flutter/model/Conversa.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:bully_flutter/model/Usuario.dart';
import 'package:bully_flutter/model/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BatePapo extends StatefulWidget {
  //Instânciando o objeto que irá receber o orguments do navigator
  Usuario contato;
  BatePapo(this.contato);

  @override
  State<BatePapo> createState() => _BatePapoState();
}

class _BatePapoState extends State<BatePapo> {
  var _imagem;
  bool _subindoImagem = false;
  TextEditingController _controllerMensagem = TextEditingController();
  var _iduseron;
  FirebaseFirestore db = FirebaseFirestore.instance;
  var _idUsuarioDestinatario;

  _enviarMensagem() {
    String textoMensagem = _controllerMensagem.text;
    if (textoMensagem.isNotEmpty) {
      Message mensagem = new Message();
      mensagem.idUsuario = _iduseron;
      mensagem.mensagem = textoMensagem;
      mensagem.urlImagem = "";
      mensagem.tipo = "texto";
      mensagem.time = DateTime.now().toUtc();

      //SALVANDO PARA O USUÁRIO REMETENTE
      _salvarMensagem(_iduseron, _idUsuarioDestinatario, mensagem);

      //SALVANDO PARA O USUÁRIO DESTINATARIO
      _salvarMensagem(_idUsuarioDestinatario, _iduseron, mensagem);

      //SALVAR CONVERSA
      _salvarConversa(mensagem);
    }
  }

  _salvarConversa(Message msg) {
    //Salvar Conversa para o remetente
    Conversa cRemetente = Conversa();
    cRemetente.idRemetente = _iduseron;
    cRemetente.idDestinatario = _idUsuarioDestinatario;
    cRemetente.mensagem = msg.mensagem;
    cRemetente.nome = widget.contato.nome;
    cRemetente.caminhoFoto = widget.contato.urlImagem;
    cRemetente.tipoMensagem = msg.tipo;
    cRemetente.salvar();

    //Salvar conversa para o destinatario
    Conversa cDestinatario = Conversa();
    cDestinatario.idRemetente = _idUsuarioDestinatario;
    cDestinatario.idDestinatario = _iduseron;
    cDestinatario.mensagem = msg.mensagem;
    cDestinatario.nome = widget.contato.nome;
    cDestinatario.caminhoFoto = widget.contato.urlImagem;
    cDestinatario.tipoMensagem = msg.tipo;
    cDestinatario.salvar();
  }

  _salvarMensagem(
      String idRemetente, String idDestinatario, Message msg) async {
    await db
        .collection("mensagens")
        .doc(idRemetente)
        .collection(idDestinatario)
        .add(msg.toMap());

    /*
    +mensagens
      +Felipe
        +usuário que irei enviar a mensagem.
          +identificadorFirebase
            +Mensagem

    */

    _controllerMensagem.clear();
  }

  Future _enviarFoto() async {
    var imagemSelecionada;

    imagemSelecionada =
        await ImagePicker().getImage(source: ImageSource.gallery);

    _subindoImagem = true;
    String nomeImagem = DateTime.now().microsecondsSinceEpoch.toString();
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference pastaRaiz = storage.ref();
    Reference archive =
        pastaRaiz.child("mensagens").child(_iduseron).child(nomeImagem + "png");

    //upload da imagem
    var file = File(imagemSelecionada.path);
    UploadTask task = archive.putFile(file);

    //controlando o progresso do upload
    task.snapshotEvents.listen((TaskSnapshot storageEvent) {
      if (storageEvent.state == TaskState.running) {
        setState(() {
          _subindoImagem = true;
        });
      } else if (storageEvent.state == TaskState.success) {
        setState(() {
          _subindoImagem = false;
        });
      }
    });

    //recuperar url da imagem
    task.then((TaskSnapshot snapshot) {
      _recuperarUrlImagem(snapshot);
    });
  }

//RECUPERANDO A URL DA IMAGEM E SALVANDO NO BANCO DE DADOS
  Future _recuperarUrlImagem(TaskSnapshot snapshot) async {
    var url = await snapshot.ref.getDownloadURL();
    Message mensagem = new Message();
    mensagem.idUsuario = _iduseron;
    mensagem.mensagem = "";
    mensagem.urlImagem = url;
    mensagem.tipo = "imagem";
    mensagem.time = DateTime.now().toUtc();

    //SALVANDO PARA O USUÁRIO REMETENTE
    _salvarMensagem(_iduseron, _idUsuarioDestinatario, mensagem);

    //SALVANDO PARA O USUÁRIO DESTINATARIO
    _salvarMensagem(_idUsuarioDestinatario, _iduseron, mensagem);
  }

  _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? useron = await auth.currentUser;
    setState(() {
      _iduseron = useron?.uid;
      _idUsuarioDestinatario = widget.contato.idUsuario;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperarDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    var caixaMensagem = Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Padding(
                padding: EdgeInsets.only(right: 6),
                child: TextField(
                  cursorColor: Colors.green,
                  autofocus: true,
                  controller: _controllerMensagem,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 8, 32, 8),
                      hintText: "Digite uma mensagem...",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: _subindoImagem
                          ? CircularProgressIndicator(
                              color: Colors.green,
                            )
                          : IconButton(
                              color: Colors.green,
                              icon: Icon(Icons.camera_alt),
                              onPressed: _enviarFoto,
                            )),
                )),
          ),
          FloatingActionButton(
            backgroundColor: Color(0xff4fa167),
            child: Icon(
              Icons.send,
              color: Colors.white,
            ),
            mini: true,
            onPressed: _enviarMensagem,
          ),
        ],
      ),
    );

    var stream = StreamBuilder(
      stream: db
          .collection("mensagens")
          .doc(_iduseron)
          .collection(_idUsuarioDestinatario)
          .orderBy('time',
              descending:
                  false) //OrderBy, server pra ordenar as mensagens a partir da data que elas foram adicionadas no firebase, usando a data/hora centralizada do BD.
          .snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: [
                  Text("Carregando mensagens"),
                  CircularProgressIndicator()
                ],
              ),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            QuerySnapshot querySnapshot = snapshot.data;

            if (snapshot.hasError) {
              return Expanded(
                child: Text("Erro ao carregar os dados!"),
              );
            } else {
              return Expanded(
                child: ListView.builder(
                    itemCount: querySnapshot.docs.length,
                    itemBuilder: (context, indice) {
                      //recuperar mensagem
                      List<DocumentSnapshot> mensagens =
                          querySnapshot.docs.toList();
                      DocumentSnapshot item = mensagens[indice];
                      double larguraContainer =
                          MediaQuery.of(context).size.width * 0.75;
                      //Define cores e alinhamentos
                      Alignment alinhamento = Alignment.centerRight;
                      var cor = Color(0xff6bd186);
                      if (_iduseron != item["idUsuario"]) {
                        alinhamento = Alignment.centerLeft;
                        cor = Color(0xff9ecfc0);
                      }
                      return Align(
                        alignment: alinhamento,
                        child: Padding(
                          padding: EdgeInsets.all(6),
                          child: Container(
                            width: larguraContainer,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: cor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: item["tipo"] == "texto"
                                ? Text(
                                    item["mensagem"],
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  )
                                : Image.network(item["urlImagem"]),
                          ),
                        ),
                      );
                    }),
              );
            }
            break;
        }
        return Container();
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(right: 52),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(widget.contato.urlImagem),
                ),
              ),
              Padding(padding: EdgeInsets.fromLTRB(0, 8, 80, 0)),
              Center(
                child: Text(widget.contato.nome,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
            ],
          ),
        ),
        backgroundColor: Color(0xff9ecfc0),
        toolbarHeight: 130,
        toolbarOpacity: 0.5,
        automaticallyImplyLeading: false,
        leading: Padding(
            padding: EdgeInsets.only(bottom: 60),
            child: IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/mensagem");
              },
              icon: Icon(
                Icons.arrow_back,
                size: 25,
              ),
            )),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: Color(0xffdfdfdf),
        child: SafeArea(
            child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              //listview
              stream,
              caixaMensagem

              //lotofmessage
            ],
          ),
        )),
      ),
    );
  }
}
