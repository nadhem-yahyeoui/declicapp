import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TransfertHistory{

  String senderD;
  String receiverD;
  Timestamp timestamp;
  String produitdes;
  
String bonus1Name;
int bonus1Q;

String bonus2Name;
int bonus2Q;

String bonus3Name;
int bonus3Q;

String produitName;
int produitQ;

TransfertHistory.buy({
  this.bonus2Name,
  this.bonus2Q,
  this.bonus1Name,
  this.timestamp,
  this.receiverD="Client",
  this.bonus1Q,
  this.senderD,
  this.produitQ,
  this.produitName,
  @required this.bonus3Name,
  @required this.bonus3Q
});


TransfertHistory(this.senderD, this.receiverD, this.timestamp, this.produitdes);


Map<String,dynamic>  toMap(TransfertHistory transfertHistory){

Map<String,dynamic>  map = Map<String,dynamic> ();

map["senderD"]=transfertHistory.senderD;
map["receiverD"]=transfertHistory.receiverD;
map["time"]=transfertHistory.timestamp;
map["produit"]=transfertHistory.produitdes;

return map;

}

Map<String,dynamic>  toBuyMap(TransfertHistory transfertHistory){

Map<String,dynamic>  map = Map<String,dynamic> ();

map["senderD"]=transfertHistory.senderD;
map["receiverD"]=transfertHistory.receiverD;
map["time"]=transfertHistory.timestamp;
map["bonus1Name"]=transfertHistory.bonus1Name;
map["bonus2Name"]=transfertHistory.bonus2Name;
map["bonus3Name"]=transfertHistory.bonus3Name;
map["bonus1Q"]=transfertHistory.bonus1Q;
map["bonus2Q"]=transfertHistory.bonus2Q;
map["bonus3Q"]=transfertHistory.bonus3Q;
map["produitName"]=transfertHistory.produitName;
map["produitQ"]=transfertHistory.produitQ;


return map;

}

TransfertHistory.fromMap(Map<String,dynamic> map){

this.senderD=map["senderD"];
this.receiverD=map["receiverD"];
this.timestamp=map["time"];
this.produitdes=map["produit"];


}


TransfertHistory.fromBuymap(Map<String,dynamic> map){

this.senderD=map["senderD"];
this.receiverD=map["receiverD"];
this.bonus1Name=map["bonus1Name"];
this.bonus2Name=map["bonus2Name"];
this.bonus1Q=map["bonus1Q"];
this.bonus3Q=map["bonus3Q"];
this.bonus3Name=map["bonus3Name"];
this.bonus2Q=map["bonus2Q"];
this.produitName=map["produitName"];
this.produitQ=map["produitQ"];
this.timestamp=map["time"];

}

}