import 'dart:ffi';
import 'package:bully_flutter/telas/AbaContatos.dart';
import 'package:bully_flutter/telas/AbaConversas.dart';
import 'package:flutter/material.dart';

import 'model/Usuario.dart';

class Mensagem extends StatefulWidget {
  const Mensagem({Key? key}) : super(key: key);

  @override
  _MensagemState createState() => _MensagemState();
}

class _MensagemState extends State<Mensagem>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initStat
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
                    padding: EdgeInsets.fromLTRB(75, 0, 80, 0),
                    child: Image.asset(
                      "images/chat.png",
                      width: 100,
                      height: 100,
                    ),
                  ),
                  Text(
                    "CHAT",
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
        toolbarHeight: 130,
        toolbarOpacity: 0.5,
        bottom: TabBar(
          indicatorWeight: 4,
          labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          labelColor: Colors.white,
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              text: "Conversas",
            ),
            Tab(
              text: "Contatos",
            )
          ],
        ),
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
      body: TabBarView(
        controller: _tabController,
        children: [AbaConversas(), AbaContatos()],
      ),
    );
  }
}
