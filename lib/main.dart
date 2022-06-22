
import 'package:bully_flutter/Home.dart';
import 'package:bully_flutter/Login.dart';
import 'package:bully_flutter/RouteGenerator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();
FirebaseFirestore bd = FirebaseFirestore.instance;


  runApp(MaterialApp(  
    
    home: Login(),
    theme: ThemeData(  
      primaryColor: Color(0xff9ecfc0),
      colorScheme: ColorScheme.light(primary: const Color(0xff9ecfc0)),
      accentColor: Color(0xff4fa167)
    ),

    initialRoute: "/",
  onGenerateRoute: RouteGenerator.generateRoute,
    debugShowCheckedModeBanner: false,
  ));
}