import 'package:declic_ap/Screens/AdminDash.dart';
import 'package:declic_ap/Screens/LoginScreen.dart';
import 'package:declic_ap/resources/firebase_methods.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
void main() async{

FirebaseAuth.instance.userChanges().first.then((value){
  runApp(new MyApp(user: value,));
});
    
}

class MyApp extends StatelessWidget {

  final FireMethods fireMethods = FireMethods();

  final User user;

   MyApp({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Declic',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      home: user!=null? 
      DashBoard(afterL: false,)
      :LoginScreen(),
    );
  }
}



