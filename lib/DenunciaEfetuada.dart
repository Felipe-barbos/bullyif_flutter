import 'package:bully_flutter/model/Denuncia.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';

class DenunciaEfetuada extends StatefulWidget {
  //Instânciando o objeto que irá receber o orguments do navigator
  Denuncia denuncia;
  DenunciaEfetuada(this.denuncia);

  @override
  State<DenunciaEfetuada> createState() => _DenunciaEfetuadaState();
}

class _DenunciaEfetuadaState extends State<DenunciaEfetuada> {
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: kElevationToShadow[3]),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
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
                                  color: Colors.black54),
                            ),
                            Container(
                              width: 320,
                              height: 70,
                              child: TextField(
                                keyboardType: TextInputType.text,
                                readOnly: true,
                                textInputAction: TextInputAction.next,
                                style: TextStyle(fontSize: 16),
                                decoration: InputDecoration(
                                    contentPadding:
                                         EdgeInsets.fromLTRB(32, 14, 32, 14),
                                    hintText: widget.denuncia.identificacaoVitima,
                                    hintStyle: TextStyle(  
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.italic,

                                    ),
                                    filled: true,
                                    fillColor: Color(0xffdfdfdf),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide( 
                                          color: Colors.black26,
                                          width: 2.0
                                        ))),
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
                                  color: Colors.black54),
                            ),
                            Container(
                              width: 320,
                              height: 70,
                              child: TextField(
                                keyboardType: TextInputType.text,
                                readOnly: true,
                                style: TextStyle(fontSize: 16),
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(32, 14, 32, 14),
                                    hintText: widget.denuncia.identificacaoAgressor,
                                    hintStyle: TextStyle(  
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.italic,

                                    ),
                                    filled: true,
                                    fillColor: Color(0xffdfdfdf),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide( 
                                          color: Colors.black26,
                                          width: 2.0
                                        ))),
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
                                  color: Colors.black54),
                            ),
                            Container(
                              width: 320,
                              height: 70,
                              child: TextField(
                                keyboardType: TextInputType.text,
                                readOnly: true,
                                style: TextStyle(fontSize: 16),
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(32, 14, 32, 14),
                                    hintText: widget.denuncia.localOcorrido,
                                    hintStyle: TextStyle(  
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.italic,

                                    ),
                                    filled: true,
                                    fillColor: Color(0xffdfdfdf),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide( 
                                          color: Colors.black26,
                                          width: 2.0
                                        ))),
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
                                      color: Colors.black54),
                                ),
                                Container(
                                    width: 140,
                                    height: 70,
                                    child: TextField(
                                      keyboardType: TextInputType.datetime,
                                      readOnly: true,
                                      style: TextStyle(fontSize: 16),
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.fromLTRB(
                                              13, 14, 13, 14),
                                          hintText: widget.denuncia.dataOcorrido,
                                          hintStyle: TextStyle(  
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.italic,

                                    ),
                                          filled: true,
                                          fillColor: Color(0xffdfdfdf),
                                         border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide( 
                                          color: Colors.black26,
                                          width: 2.0
                                        ))),
                                    ),
                                ),
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
                                      color: Colors.black54),
                                ),
                                Container(
                                    width: 140,
                                    height: 70,
                                    child: TextField(
                                      keyboardType: TextInputType.text,
                                      readOnly: true,
                                      style: TextStyle(fontSize: 16),
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.fromLTRB(
                                              13, 14, 13, 14),
                                          hintText: widget.denuncia.horarioOcorrido,
                                          hintStyle: TextStyle(  
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.italic,

                                    ),
                                          filled: true,
                                          fillColor: Color(0xffdfdfdf),
                                         border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide( 
                                          color: Colors.black26,
                                          width: 2.0
                                        ))),
                                    )
                                )
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
                                  color: Colors.black54),
                            ),
                            Container(
                              width: 320,
                              height: 70,
                              child: TextField(
                                keyboardType: TextInputType.text,
                                readOnly: true,
                                style: TextStyle(fontSize: 16),
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(32, 14, 32, 14),
                                    hintText: widget.denuncia.tipAgressao,
                                    hintStyle: TextStyle(  
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.italic,

                                    ),
                                    filled: true,
                                    fillColor: Color(0xffdfdfdf),
                                   border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide( 
                                          color: Colors.black26,
                                          width: 2.0
                                        ))),
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
                                  color: Colors.black54),
                            ),
                            Container(
                              width: 320,
                              height: 150,
                              child: TextField(
                                keyboardType: TextInputType.text,
                                readOnly: true,
                                style: TextStyle(fontSize: 16),
                                maxLength: 300,
                                maxLines: 5,
                                minLines: 1,
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(32, 14, 32, 14),
                                    hintText: widget.denuncia.descricao,
                                    hintStyle: TextStyle(  
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.italic,

                                    ),
                                    filled: true,
                                    fillColor: Color(0xffdfdfdf),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide( 
                                          color: Colors.black26,
                                          width: 2.0
                                        ))),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
