import 'package:declic_ap/resources/firebase_methods.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/claim.dart';
import 'ProfileW.dart';
import '../models/user.dart';
import '../Utils/Utils.dart';

class ClaimItemW extends StatelessWidget {

  ClaimItemW({Key key, this.claim, this.isME}) : super(key: key);

final Claim claim;

final bool isME;

final FireMethods fireMethods = FireMethods();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child: Row(
              children: [
                isME? claim.photoUrlR!=null?
                ProfileW(
                   imageUrl: claim.photoUrlR,
                ):StreamBuilder(
          stream: fireMethods.getUserStreamFromUid(claim?.receiver),
          initialData: null ,
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){

            if (snapshot.hasData&&snapshot.data!=null){
              if (snapshot.data.data()!=null){
                final Us user = Us.fromMap(snapshot.data.data());
              FireMethods.firestore.collection("Users").doc(claim.sender).collection("Claim").doc(claim.uid).update({"photoR":user.imageUrl});
              FireMethods.firestore.collection("Users").doc(claim.receiver).collection("Claim").doc(claim.uid).update({"photoR":user.imageUrl});
                return ProfileW(
          imageUrl: user.imageUrl,
        );
              }              
            }
          return ProfileW(
          imageUrl: null,
        ); 
          },
        ):claim.photoUrlS!=null? ProfileW(
                   imageUrl: claim.photoUrlS,
                ):StreamBuilder(
          stream: fireMethods.getUserStreamFromUid(claim.sender),
          initialData: null ,
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){

            if (snapshot.hasData&&snapshot.data!=null){
              final Us user = Us.fromMap(snapshot.data.data());

               FireMethods.firestore.collection("Users").doc(claim.sender).collection("Claim").doc(claim.uid).update({"photoS":user.imageUrl});
              FireMethods.firestore.collection("Users").doc(claim.receiver).collection("Claim").doc(claim.uid).update({"photoS":user.imageUrl});
            
            return ProfileW(
          imageUrl: user.imageUrl,
        );
            }
          return ProfileW(
          imageUrl: null,
        ); 
          },
        ),
                 SizedBox(
                  width: 5.0,
                  ),
                  Expanded(
                    child: Container(
                      //padding: EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(isME? claim.receivernom:claim.sendernom,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(Utils.getCustomDate2FromTimeS(claim.timestamp),style: TextStyle(color: Colors.black.withOpacity(0.7),fontWeight: FontWeight.w500),)
                      ],
                    ),
                  ),
              )
              ],
            )
          ),
           SizedBox(
            height: 5 ,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20,left: 30),
                decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.5)))
                      ),
                padding: EdgeInsets.all(10),
                child: Text(isME ? "Vous : ${claim.des}":claim.des,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
            ),
        ],
      )
    );
  }
  
}