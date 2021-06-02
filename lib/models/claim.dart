import 'package:cloud_firestore/cloud_firestore.dart';

class Claim {

   String receiver;
   String sender;
   String des;
   Timestamp timestamp;
   String photoUrlR;
   String sendernom;
   String receivernom;
   String photoUrlS;
   String uid;

  Claim({
    this.receiver,this.timestamp,this.uid, this.des,this.photoUrlR,this.photoUrlS,this.receivernom,this.sendernom,this.sender});
  
  
  Map<String,dynamic> toMap(Claim claim){

 Map<String,dynamic>  map = Map<String,dynamic>();

 map["des"]=claim.des;
 map["sender"]=claim.sender;
 map["rec"]=claim.receiver;
 map["timestamp"]=claim.timestamp;
 map["photoR"]=claim.photoUrlR;
 map["photoS"]=claim.photoUrlS;
 map["nomS"]=claim.sendernom;
 map["nomR"]=claim.receivernom;
  map["uid"]=claim.uid;

 return map;

  }

Claim.fromMap(Map<String,dynamic> map){

this.sender=map["sender"];
  this.des = map["des"];
  this.timestamp = map["timestamp"];
  this.receiver = map["rec"];
  this.sendernom=map["nomS"];
  this.receivernom=map["nomR"];
  this.photoUrlR=map["photoR"];
  this.photoUrlS=map["photoS"];
  this.uid=map["uid"];
}
}