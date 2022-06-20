import 'dart:ffi';

import 'package:bully_flutter/model/Usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Denuncia {
  var _identificacaoUsuario;
  var _idDenuncia;
  var _identificacaoVitima;
  var _identificacaoAgressor;
  var _localOcorrido;
  var _statusDenuncia;
  var _horarioOcorrido;
  var _dataOcorrido;
  var _tipoAgressao;
  var _descricao;


  Denuncia();

  Map<String, dynamic> toMap(){
      Map<String, dynamic> map = {
        
          "identificacaoUsuario": this.identificacaoUsuario,
          "idDenuncia": this.idDenuncia,
          "identificacaoVitima": this.identificacaoVitima,
          "identificacaoAgressor": this.identificacaoAgressor,
          "localOcorrido": this.localOcorrido,
          "dataOcorrido": this.dataOcorrido,
          "statusDenuncia": this.statusDenuncia,
          "horarioOcorrido": this.horarioOcorrido,
          "tipoAgressao": this.tipAgressao,
          "descricao": this.descricao,
          

        
      };
      return map;
    }

  String get dataOcorrido => _dataOcorrido;

  set dataOcorrido(String value) {
    _dataOcorrido = value;
  }

  String get identificacaoUsuario => _identificacaoUsuario;

  set identificacaoUsuario(String value) {
    _identificacaoUsuario = value;
  }

  String get idDenuncia => _idDenuncia;

  set idDenuncia(String value) {
    _idDenuncia = value;
  }

  String get identificacaoVitima => _identificacaoVitima;

  set identificacaoVitima(String value) {
    _identificacaoVitima = value;
  }

  String get identificacaoAgressor => _identificacaoAgressor;

  set identificacaoAgressor(String value) {
    _identificacaoAgressor = value;
  }

  String get localOcorrido => _localOcorrido;

  set localOcorrido(String value) {
    _localOcorrido = value;
  }

  String get statusDenuncia => _statusDenuncia;

  set statusDenuncia(String value) {
    _statusDenuncia = value;
  }

  String get horarioOcorrido => _horarioOcorrido;

  set horarioOcorrido(String value) {
    _horarioOcorrido = value;
  }

  String get tipAgressao => _tipoAgressao;

  set tipAgressao(String value) {
    _tipoAgressao = value;
  }

  String get descricao => _descricao;

  set descricao(String value) {
    _descricao = value;
  }

  
}
