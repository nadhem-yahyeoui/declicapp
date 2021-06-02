import 'package:declic_ap/Screens/LocationView.dart';
import 'package:declic_ap/Screens/UpdateProfileScreen.dart';
import 'package:declic_ap/const/const.dart';
import 'package:declic_ap/resources/firebase_methods.dart';
import 'package:declic_ap/Screens/ProduitView.dart';
import 'package:flutter/material.dart';
import 'ProfileW.dart';
import '../models/user.dart';
import '../Utils/Utils.dart';
import '../Widgets/Extension.dart';

class DashUserIW extends StatelessWidget {

   DashUserIW({Key key, this.user}) : super(key: key);

final Us user;

  final FireMethods fireMethods = FireMethods();

 Future<bool> createDialog(BuildContext context){

    return showDialog(context: context,builder: (context){
      return AlertDialog(
        title: Text("Voulez-vous vraiment supprimer cet utilisateur?      "),
        elevation: 10,
        actions: [
          MaterialButton(
            onPressed: (){
              Navigator.of(context).pop(false);
            },
            child: Text("NON"),
          ),
          MaterialButton(
            onPressed: (){
            Navigator.of(context).pop(true);
            },
            child: Text("OUI",style: TextStyle(
              color: Colors.red,
            ),),
          )
        ],
      );
    });
}

Future<bool> sendProduits(BuildContext context)async{
  return await showModalBottomSheet(
                        elevation: 10,
                        context: context, 
                        builder: (context)=>ProduitView(
                          receiverRole: user.roleNum,
                          senderName: "VOUS",
                          senderRole: 0,
                          receiverName: user.roleNum==3?"Magasin ${user.magasin}": "${user.nom} ${user.prenom}",
                          cin: MyConst.adminUid,
                          cin2: user.cin ,
                          canEdit: false,
                        ),
                        isScrollControlled: true
                        );
}

Future<bool> updateProfile(BuildContext context)async{
           return await showModalBottomSheet(
                        elevation: 10,
                        context: context, 
                        builder: (context)=>UpdateUserScreen(
                          user: user,
                        ),
                        isScrollControlled: true
          );
}

  @override
  Widget build(BuildContext context) {
    
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child:Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         ProfileW(imageUrl: user.imageUrl,radius: 30,),
          SizedBox(width: 10,),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("${user.nom} ${user.prenom}",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w700),),
              SizedBox(height: user.magasin.isNotEmpty? 5:0,),
              user.magasin.isNotEmpty? Text("Magasin ${user.magasin}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),):SizedBox(),
              SizedBox(
                height: 5,
              ),
              Text("${Utils.getCustomDatefromTimeStamp(user.timestamp)}",style: TextStyle(color: Colors.grey,fontSize: 16,fontWeight: FontWeight.w700)),
            ],
          )
          ),
          user.roleNum==1 || user.roleNum==2 ?
          IconButton(
            onPressed: ()async{
              sendProduits(context).then((value){
                if (value!=null){
                  if (value){
                    context.showToast(
                    pdHorizontal: 30,
                    pdVertical: 12,
                    textSize:18,
                    bgColor: Colors.green.withOpacity(0.7),
                    msg: "produits envoyés avec succés",
                    position: VxToastPosition.top
                );
                  }
                }
              });
            }, 
            icon: Icon(Icons.send_outlined,color: Colors.blue,)
            ):SizedBox(),
            PopupMenuButton(
              onSelected: (value){
                switch (value) {
                  case 0: updateProfile(context).then((value){
                if (value!=null){
                  if (value){
                    context.showToast(
                    pdHorizontal: 30,
                    pdVertical: 12,
                    textSize:18,
                    bgColor: Colors.green.withOpacity(0.7),
                    msg: "le mise a jour complete avec succés",
                    position: VxToastPosition.top
                );
                  }
                }
              });
                    break;
                    case 1:createDialog(context).then(
                (value)async{
                  if (value!=null){
                    if (value){
                      await FireMethods.firestore.collection("Users").doc(user.cin).update({"deleted":true});
                    }
                  }
                }
              );break;
                  default: Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (cntx)=>LocationView(
                    uid: user.cin,
                    firstP: user.pos,
                  )
              ));
                }
              },
              shape: RoundedRectangleBorder(),
              itemBuilder: (context){
              return [
                PopupMenuItem(
                  child: ListTile(title: Text("Edit Profile"),
                  leading: Icon(Icons.edit_outlined),),
                  value: 0,
                  ),
                PopupMenuItem(
                  child: ListTile(title: Text("Delete"),
                  leading: Icon(Icons.delete_outlined),),
                  value: 1,
                  ),
                PopupMenuItem(
                  child: ListTile(
                    title: Text("Location"),
                    leading: Icon(Icons.location_history_outlined),
                    ),
                    value: 2,
                    ),
              ].toList();
            }),
        ],
      )
    );
  }
}

