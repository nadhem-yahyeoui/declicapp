import '../models/bonus.dart';
import 'package:declic_ap/resources/firebase_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Widgets/Extension.dart';
import '../models/produit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProductCubit extends Cubit<bool>{


  AddProductCubit() : super(false);

  final FireMethods fireMethods = FireMethods();

   BuildContext context;

  final TextEditingController textEditingControllerName = TextEditingController();
  final TextEditingController textEditingControllerQ= TextEditingController();
  final TextEditingController textEditingControllerdes = TextEditingController();
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  String photoUrl;

  ValueNotifier<Bonus> bonus=ValueNotifier<Bonus>(null);

  bool canadd = true;
  
  void init(BuildContext cntx){
    context = cntx;
  }

  void setBonusto(Bonus newvalue){
    bonus.value=newvalue;
  }

  Future<void> addProduct()async{
    if (canadd&&globalKey.currentState.validate()){
          canadd=false;
      final Produit produit = 
       Produit(
        bonus2: false,
        bonus3: false,
        des: textEditingControllerdes.text,
        bonusId: bonus.value.id,
        bonusName: bonus.value.name,
        bonusImageUrl: bonus.value.imageUrl,
        bonusQ: bonus.value.quantity,
        imageUrl: photoUrl,
        name:textEditingControllerName.text ,
        quantity: int.parse(textEditingControllerQ.text),
        timestamp: Timestamp.now(),
      );
      fireMethods.addNewPToDB(produit).then(
        (value){
          if (value){
            Navigator.of(context).pop(true);
          }else{
            context.showToast(
                    pdHorizontal: 30,
                    pdVertical: 12,
                    textSize:18,
                    bgColor: Colors.red.withOpacity(0.7),
                    msg: "une erreur s'est produite lors de l'ajout de ce produit,réessayez",
                    position: VxToastPosition.top
                );
            canadd=true;
          }
        } 
        );
    }

}
}