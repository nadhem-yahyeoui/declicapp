import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class Produit {

 String id;
 String name;
 int quantity;
 Timestamp timestamp;
 String imageUrl;

bool bonus2;

bool bonus3;

String des;

String bonusId;
String bonusName;
int bonusQ;
String bonusImageUrl;


String bonus2Id;
String bonus2Name;
int bonus2Q;
String bonus2ImageUrl;

String bonus3Id;
String bonus3Name;
int bonus3Q;
String bonus3ImageUrl;

 Produit({
   this.des,
   this.imageUrl,
   this.name,
   this.bonus2,
   this.bonusId,
   this.bonusName,
   this.bonusImageUrl,
   this.bonusQ,
   this.id, 
   this.quantity, 
   @required this.bonus3,
   this.timestamp,
   });

Produit.with2Bonus({
   this.des,
   this.imageUrl,
   this.name,
   this.bonus2,
   this.bonusId,
   this.bonusName,
   this.bonusImageUrl,
   this.bonusQ,
   this.id, 
   this.quantity, 
   this.timestamp,
   this.bonus2Id,
   this.bonus2ImageUrl,
   this.bonus2Name,
   this.bonus2Q,
   @required this.bonus3
});

Produit.with3Bonus({
   this.des,
   this.imageUrl,
   this.name,
   this.bonus2,
   this.bonusId,
   this.bonusName,
   this.bonusImageUrl,
   this.bonusQ,
   this.id, 
   this.quantity, 
   this.timestamp,
   this.bonus2Id,
   this.bonus2ImageUrl,
   this.bonus2Name,
   this.bonus2Q,
   this.bonus3=true,
   @required this.bonus3Id,
   @required this.bonus3ImageUrl,
   @required this.bonus3Name,
   @required this.bonus3Q,
});

Map<String,dynamic> toMap(Produit produit){

    Map<String,dynamic> map = Map<String,dynamic>();

    map["id"]=produit.id;
    map["name"]=produit.name;
    map["date"]=produit.timestamp;
    map["image"]=produit.imageUrl;
    map["quan"]=produit.quantity;
    map["bonus"]=produit.bonus2;
    map["BID"]=produit.bonusId;
    map["BIURL"]=produit.bonusImageUrl;
    map["BN"]=produit.bonusName;
    map["BQ"]=produit.bonusQ;    
    map["des"]=produit.des;
    map["bonus2"]=produit.bonus3;

    return map;

}

Map<String,dynamic> to2Map(Produit produit){

    Map<String,dynamic> map = Map<String,dynamic>();
  
    map["id"]=produit.id;
    map["name"]=produit.name;
    map["date"]=produit.timestamp;
    map["image"]=produit.imageUrl;
    map["quan"]=produit.quantity;
    map["bonus"]=produit.bonus2;
    map["BID"]=produit.bonusId;
    map["BIURL"]=produit.bonusImageUrl;
    map["BN"]=produit.bonusName;
    map["BQ"]=produit.bonusQ;    
    map["des"]=produit.des;
    map["B2ID"]=produit.bonus2Id;
    map["B2IURL"]=produit.bonus2ImageUrl;
    map["B2N"]=produit.bonus2Name;
    map["B2Q"]=produit.bonus2Q;  
    map["bonus2"]=produit.bonus3;
      
    return map;

}

Map<String,dynamic> to3Map(Produit produit){

    Map<String,dynamic> map = Map<String,dynamic>();
  
    map["id"]=produit.id;
    map["name"]=produit.name;
    map["date"]=produit.timestamp;
    map["image"]=produit.imageUrl;
    map["quan"]=produit.quantity;
    map["bonus"]=produit.bonus2;
    map["BID"]=produit.bonusId;
    map["BIURL"]=produit.bonusImageUrl;
    map["BN"]=produit.bonusName;
    map["BQ"]=produit.bonusQ;    
    map["des"]=produit.des;
    map["B2ID"]=produit.bonus2Id;
    map["B2IURL"]=produit.bonus2ImageUrl;
    map["B2N"]=produit.bonus2Name;
    map["B2Q"]=produit.bonus2Q;  
    map["bonus2"]=produit.bonus3;
    map["B3ID"]=produit.bonus3Id;
    map["B3IURL"]=produit.bonus3ImageUrl;
    map["B3N"]=produit.bonus3Name;
    map["B3Q"]=produit.bonus3Q; 

    return map;

}

Produit.fromMap(Map<String,dynamic> map){
  
this.id=map["id"];
this.name=map["name"];
this.timestamp=map["date"];
this.imageUrl=map["image"];
this.quantity=map["quan"];
this.bonus2=map["bonus"];
this.bonusId=map["BID"];
this.bonusImageUrl=map["BIURL"];
this.bonusName=map["BN"];
this.bonusQ=map["BQ"];
this.des=map["des"]; 
this.bonus3=map["bonus2"];

}


Produit.from2Map(Map<String,dynamic> map){
  
this.id=map["id"];
this.name=map["name"];
this.timestamp=map["date"];
this.imageUrl=map["image"];
this.quantity=map["quan"];
this.bonus2=map["bonus"];
this.bonusId=map["BID"];

this.bonusImageUrl=map["BIURL"];
this.bonusName=map["BN"];
this.bonusQ=map["BQ"];
this.des=map["des"]; 
this.bonus2Id=map["B2ID"];
this.bonus2ImageUrl=map["B2IURL"];
this.bonus2Name=map["B2N"];
this.bonus2Q=map["B2Q"];
this.bonus3=map["bonus2"];


}

Produit.from3Map(Map<String,dynamic> map){
  
this.id=map["id"];
this.name=map["name"];
this.timestamp=map["date"];
this.imageUrl=map["image"];
this.quantity=map["quan"];
this.bonus2=map["bonus"];
this.bonusId=map["BID"];

this.bonusImageUrl=map["BIURL"];
this.bonusName=map["BN"];
this.bonusQ=map["BQ"];
this.des=map["des"]; 
this.bonus2Id=map["B2ID"];
this.bonus2ImageUrl=map["B2IURL"];
this.bonus2Name=map["B2N"];
this.bonus2Q=map["B2Q"];

this.bonus3=map["bonus2"];

this.bonus3Id=map["B3ID"];
this.bonus3ImageUrl=map["B3IURL"];
this.bonus3Name=map["B3N"];
this.bonus3Q=map["B3Q"];

}

}