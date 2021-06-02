import 'package:declic_ap/const/const.dart';
import 'package:declic_ap/models/FetchedUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Widgets/Extension.dart';
import '../enum/UserR.dart';
import '../models/claim.dart';
import '../models/user.dart';
import '../models/TransfertHistory.dart';
import '../models/produit.dart';
import '../models/bonus.dart';
import '../models/Transfert.dart';

class FireMethods {

    static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    static final FirebaseFirestore firestore = FirebaseFirestore.instance;
    static final CollectionReference _usersCollection = firestore.collection("Users");

// return Current User
User getCurrentUser(){
  return _firebaseAuth.currentUser;
}


void showtoast({BuildContext context,bool passOublie=false}){
   context.showToast(
                    pdHorizontal: 30,
                    pdVertical: 12,
                    textSize:18,
                    bgColor: Colors.red.withOpacity(0.7),
                    msg: passOublie? "mot de passe incorrecte !":"cin est invalide !",
                    position: VxToastPosition.top
                );
}
// sign in with email and pass 

Future<FetchedUser> signIn(BuildContext context,String uid,String pass)async{

  _firebaseAuth.setPersistence(Persistence.LOCAL);

  if (uid==MyConst.adminUid){
    if (pass!=MyConst.passUid){
      showtoast(context: context,passOublie: true);
      return null;
    }
     return await _firebaseAuth.signInWithEmailAndPassword(
        email: "0_$uid@gmail.com", 
        password: pass
        ).then((user){
          if (user!=null){
            return FetchedUser(UserR.ADMIN, null);
          }else{
            showtoast(context: context);
            return null;
          }
      }).onError((error, stackTrace){
        showtoast(context: context);
        return null;
      });
  }
          showtoast(context: context);
        return null;
}


Stream<DocumentSnapshot> getUserStreamFromUid(String uid){

    return _usersCollection.doc(uid).snapshots();

}

Future<Us> getUserFromUid(String uid)async{

try{
  return Us.fromMap((await _usersCollection.doc(uid).get()).data());
}catch(e){
  return null;
}


}

Future<bool> deleteBonus(String id)async{

return await _usersCollection.doc(MyConst.adminUid).collection("Produits").doc(id).delete().then((value) => true).onError((error, stackTrace) => false);

}


Future<void> deleteUserWithUid(String uid)async{
  return await _usersCollection.doc(uid).delete();
}

Future<String> getImagePFromUid(String uid)async{
  try{
    return (await _usersCollection.doc(uid).get()).get("image");
  }catch(e){
    return null;
  }
}

Future<bool> signOut()async{
  try{
    await _firebaseAuth.signOut();
    return true;
  }catch(e){
    return false;
  }
}

Future<bool> registerUser(BuildContext context,Us userToRegister)async{

  if (MyConst.adminUid==userToRegister.cin) {
    
    context.showToast(
                    pdHorizontal: 30,
                    pdVertical: 12,
                    textSize:18,
                    bgColor: Colors.red.withOpacity(0.7),
                    msg: "CIN DEJA EXISTE !",
                    position: VxToastPosition.top
                );

    return false;
    
    }
       try{
          if ((await _usersCollection.doc(userToRegister.cin).get()).exists){
            context.showToast(
                    pdHorizontal: 30,
                    pdVertical: 12,
                    textSize:18,
                    bgColor: Colors.red.withOpacity(0.7),
                    msg: "CIN DEJA EXISTE !",
                    position: VxToastPosition.top
                );
            return false;
            }
       await _usersCollection.doc(userToRegister.cin).set(userToRegister.toMap(userToRegister));               
       return true;
       }catch(e){
         context.showToast(
                    pdHorizontal: 30,
                    pdVertical: 12,
                    textSize:18,
                    bgColor: Colors.red.withOpacity(0.7),
                    msg: "une erreur s'est produite lors de l'enregistrement d'un nouveau compte,réessayez",
                    position: VxToastPosition.top
                );
         return false;
       }

}

Stream<QuerySnapshot> getMagasins(){
  return _usersCollection.where("role",isEqualTo: 3).where("deleted",isEqualTo: false).snapshots();
}


Stream<QuerySnapshot> getTransporteurs(){

  return _usersCollection.where("role",isEqualTo: 1).where("deleted",isEqualTo: false).snapshots();

}
Stream<QuerySnapshot> getSupers(){

  return _usersCollection.where("role",isEqualTo: 2).where("deleted",isEqualTo: false).snapshots();

}


Future<bool> addImageProfile(String uid,String link)async{
  try {
   await _usersCollection.doc(uid).update({"image":link});
  return true;
  }catch(e){
    return false;
  }
}


Future<bool> upDateNoAnimaProfile({String cin,String name,String prenom,String pass,String currentpass})async{

  try{

if (pass!=currentpass){
  
  await _usersCollection.doc(cin).update({
              "nom":name,
              "prenom":prenom,
              "pass":pass,
              "oldpass":currentpass
      });

}else{

  await _usersCollection.doc(cin).update({
              "nom":name,
              "prenom":prenom,
      });

} 
    return true;

  }catch(e){
    return false;
  }


}

Future<bool> upDateAnimaProfile({
  String cin,String cin2,String currentpass,String name,String prenom,String pass,String magasin,Timestamp timeStamp
  })async{

  try{
if (pass==currentpass){
     await _usersCollection.doc(cin).update({
      "nom":name,"prenom":prenom,"date":timeStamp,"magasin":magasin,"cin2":cin2
      });
}else{
      await _usersCollection.doc(cin).update({
      "nom":name,
      "prenom":prenom,
      "oldpass":currentpass,
      "pass":pass,"date":timeStamp,"magasin":magasin,"cin2":cin2
      });
}
 

    return true;

  }catch(e){
    return false;
  }


}

Future<bool> addReclamationToDB(Claim claim)async{

try{
  
  DocumentReference documentReference = _usersCollection.doc(claim.sender).collection("Claim").doc();

  claim.uid=documentReference.id;

  await documentReference.set(claim.toMap(claim));

  await _usersCollection.doc(claim.receiver).collection("Claim").doc(documentReference.id).set(claim.toMap(claim));
 
  return true;

}catch(e){

return false;

}

}

Stream<QuerySnapshot> getClaimStreamFrom(String uid){


  return _usersCollection.doc(uid).collection("Claim").orderBy("timestamp",descending: true).snapshots();


}


Stream<QuerySnapshot> getProducts(String cin){ 
  return _usersCollection.doc(cin).collection("Produits").snapshots();
}

Stream<QuerySnapshot> getProductswithno3bonus(String cin){ 
  return _usersCollection.doc(cin).collection("Produits").where("bonus2",isEqualTo: false).where("bonus",isEqualTo: true).snapshots();
}

Stream<QuerySnapshot> getProductswith1bonus(String cin){ 
  return _usersCollection.doc(cin).collection("Produits").where("bonus",isEqualTo: false).snapshots();
}

Stream<DocumentSnapshot> getProductStream(String cin,String productId){

return _usersCollection.doc(cin).collection("Produits").doc(productId).snapshots();

}

Future<bool> updateProduitByAdmin({String produitId,int newValToProduit})async{

try{

   await _usersCollection
  .doc(MyConst.adminUid)
  .collection("Produits")
  .doc(produitId)
  .update({"quan":newValToProduit});

  return true;

}catch(e){


  return false;


}




}

Future<bool> add2Bonus(Produit produit)async{

try{

await _usersCollection.doc(MyConst.adminUid).collection("Produits").doc(produit.id).set(produit.to2Map(produit));
return true;

}catch(e){

  return false;

}

}

Future<bool> add3Bonus(Produit produit)async{

try{

await _usersCollection.doc(MyConst.adminUid).collection("Produits").doc(produit.id).set(produit.to3Map(produit));
return true;

}catch(e){

  return false;

}

}

Future<bool>  addNewPToDB(Produit produit)async{

try{

final DocumentReference documentReference = _usersCollection.doc(MyConst.adminUid).collection("Produits").doc();

produit.id=documentReference.id;

await documentReference.set(produit.bonus2? produit.to2Map(produit):produit.toMap(produit));

return true;

}catch(e){

  return false;

}

}

Stream<QuerySnapshot> getBonusStream(){

return _usersCollection.doc(MyConst.adminUid).collection("Bonus").snapshots();

}

Future<bool> addBonusToDb(Bonus bonus)async{

try {
  DocumentReference documentReference= _usersCollection.doc(MyConst.adminUid).collection("Bonus").doc();
  bonus.id=documentReference.id;
  await documentReference.set(bonus.toMap(bonus));
  return true;
}catch(e){
  return false;
}

}

Future<bool> handleProduitTransfert(Transfert transfert)async{
 
 try{

   int produitQ;

  DocumentSnapshot documentSnapshot= await _usersCollection
  .doc(transfert.receiver)
  .collection("Produits")
  .doc(transfert.produit.id)
  .get();

await _usersCollection.
  doc(transfert.sender).
  collection("Produits").
  doc(transfert.produit.id).
  update({
    "quan":transfert.oldQ-transfert.produit.quantity,
    });

if (documentSnapshot.get("bonus")!=transfert.produit.bonus2||documentSnapshot.get("bonus2")!=transfert.produit.bonus3){

  final Produit produit = transfert.produit;
  
  produitQ = produit.quantity;

  produit.quantity=produit.quantity+documentSnapshot.get("quan");
  
  await _usersCollection
  .doc(transfert.receiver)
  .collection("Produits")
  .doc(transfert.produit.id)
  .update(
    produit.to3Map(produit)
    );

}else{
   await _usersCollection
  .doc(transfert.receiver)
  .collection("Produits")
  .doc(transfert.produit.id)
  .update(
    {
      "quan":documentSnapshot.get("quan")+transfert.produit.quantity,
  });
}

if (transfert.receiver!=MyConst.adminUid){
    final TransfertHistory transfertHistory = TransfertHistory(
      "${transfert.senderName} : ${transfert.senderRole} : ${transfert.sender}", 
      "${transfert.receiverName} : ${transfert.receiverRole} : ${transfert.receiver}", 
      transfert.produit.timestamp, 
      "${produitQ!=null?produitQ : transfert.produit.quantity} ${transfert.produit.name}"
      );
    await _usersCollection.doc(MyConst.adminUid).collection("History").doc().set(transfertHistory.toMap(transfertHistory));
}else{
  final TransfertHistory transfertHistory = TransfertHistory(
      "${transfert.senderName} : ${transfert.senderRole} : ${transfert.sender}", 
      "VOUS:ADMIN: ", 
      transfert.produit.timestamp, 
      "${produitQ!=null?produitQ : transfert.produit.quantity} ${transfert.produit.name}"
      );
    await _usersCollection.doc(MyConst.adminUid).collection("History").doc().set(transfertHistory.toMap(transfertHistory));

}
  return true;

 }catch(e){
   try{
     await _usersCollection
  .doc(transfert.receiver)
  .collection("Produits")
  .doc(transfert.produit.id)
  .set(transfert.produit.to3Map(transfert.produit));
  transfert.produit.bonus2? await _usersCollection.
  doc(transfert.sender).
  collection("Produits").
  doc(transfert.produit.id).
  update({
    "quan":transfert.oldQ-transfert.produit.quantity,
    }):
  await _usersCollection.
  doc(transfert.sender).
  collection("Produits").
  doc(transfert.produit.id).
  update({
    "quan":transfert.oldQ-transfert.produit.quantity,
    });
   if (transfert.receiver==MyConst.adminUid){
      final TransfertHistory transfertHistory = TransfertHistory(
      "${transfert.senderName} : ${transfert.senderRole} : ${transfert.sender}", 
      "VOUS:ADMIN: ", 
      transfert.produit.timestamp, 
     "${transfert.produit.quantity} ${transfert.produit.name}"
      );
    await _usersCollection.doc(MyConst.adminUid).collection("History").doc().set(transfertHistory.toMap(transfertHistory));
   }else{
      final TransfertHistory transfertHistory = TransfertHistory(
      "${transfert.senderName} : ${transfert.senderRole} : ${transfert.sender}", 
      "${transfert.receiverName} : ${transfert.receiverRole} : ${transfert.receiver}", 
      transfert.produit.timestamp, 
     "${transfert.produit.quantity} ${transfert.produit.name}"
      );
    await _usersCollection.doc(MyConst.adminUid).collection("History").doc().set(transfertHistory.toMap(transfertHistory));
   }

  return true;

   }catch(e){

     return false;

   }
 }
}

Future<bool> handleoublierpassword(String cin)async{


try{
    final Us us = await getUserFromUid(cin);
    if (us!=null){
      await addReclamationToDB(Claim(
        des: "OUBLIE PASSWORD",
        sender: cin,
        sendernom: "${us.nom} ${us.prenom}",
        timestamp: Timestamp.now(),
        receiver: MyConst.adminUid,
        photoUrlR: "https://www.pngfind.com/pngs/m/528-5286002_forum-admin-icon-png-nitzer-ebb-that-total.png",
        photoUrlS: us.imageUrl,
        receivernom: "ADMINISTRATEUR"
      )
      );
      return true;
    }
    return false;
}catch(e){
  return false;
}


}

Stream<QuerySnapshot> getHistory(){

return  _usersCollection.doc(MyConst.adminUid).collection("History").orderBy("time",descending: true).snapshots();

}

Future<bool> updateQAStock(int newQ,String id)async{

try{

await _usersCollection
.doc(MyConst.adminUid)
.collection("Produits")
.doc(id)
.update({"quan":newQ});
return true;

}catch(e){

  return false;

}
  
}



}