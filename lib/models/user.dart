import 'package:cloud_firestore/cloud_firestore.dart' as fire;
import 'package:flutter/material.dart';


class Us {

 Us({
   this.imageUrl,this.pos,this.cin2,this.oldpass,this.deleted,this.signed,this.cin, this.pass, this.roleNum, this.nom, this.prenom, this.timestamp, this.magasin
   });

 String cin;
 String cin2;
 String pass;
 int roleNum;
 String oldpass;
 String nom;
 String prenom;
 fire.Timestamp timestamp;
 String magasin;
 bool signed;
 String imageUrl;
 bool deleted;
 fire.GeoPoint pos;

Map<String,dynamic> toMap(Us user){
    Map<String,dynamic> map = Map<String,dynamic>();
    map["cin"]=user.cin;
    map["cin2"]=user.cin2;
    map["pass"]=user.pass;
    map["role"]=user.roleNum;
    map["nom"]=user.nom;
    map["oldpass"]=user.oldpass;
    map["prenom"]=user.prenom;
    map["date"]=user.timestamp;
    map["image"]=user.imageUrl;
    map["magasin"]=user.magasin;
    map["signed"]=user.signed;
    map["deleted"]=user.deleted;
    map["pos"]=user.pos;

    return map;
}

Us.fromMap(Map<String,dynamic> map){
  this.cin=map["cin"];
  this.pass=map["pass"];
  this.roleNum=map["role"];
  this.magasin=map["magasin"];
  this.nom=map["nom"];
  this.oldpass=map["oldpass"];
  this.prenom=map["prenom"];
  this.timestamp=map["date"];
  this.signed=map["signed"];
  this.imageUrl=map["image"];
  this.deleted=map["deleted"];
  this.cin2=map["cin2"];
  this.pos=map["pos"];
}


}