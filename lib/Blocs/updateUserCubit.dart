import 'package:declic_ap/resources/firebase_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Widgets/Extension.dart';
import '../models/user.dart';

class UpdateUserCubit extends Cubit<bool> {
  
  UpdateUserCubit() : super(false);

  final FireMethods fireMethods = FireMethods();
   BuildContext context;
  GlobalKey<FormState>  globalKey = GlobalKey<FormState>();
  TextEditingController textEditingControllerCin;
  TextEditingController textEditingControllerNom;
  TextEditingController textEditingControllerPrenom;
  TextEditingController textEditingControllerPassword;
  TextEditingController textEditingControllerMagasin;  
  Us user;
  bool canupdate = true;
  ValueNotifier<DateTime> pickedDate;
  void init(BuildContext cntx,Us us){
    context = cntx;
    user=us;
   
   textEditingControllerCin=TextEditingController(text: us.cin2);
   textEditingControllerNom=TextEditingController(text: us.nom);
   textEditingControllerPrenom=TextEditingController(text: us.prenom);
   textEditingControllerPassword=TextEditingController(text: us.pass);
   textEditingControllerMagasin=TextEditingController(text: us.magasin);  

    pickedDate = ValueNotifier(us.timestamp.toDate());
  }

  Future<void> updateUser()async{
    if (canupdate&&globalKey.currentState.validate()){

if (user.roleNum==3){
  fireMethods.upDateAnimaProfile(
    currentpass: user.pass,
          cin: user.cin,
          cin2: textEditingControllerCin.text,
          magasin: textEditingControllerMagasin.text,
          name: textEditingControllerNom.text,
          pass: textEditingControllerPassword.text,
          prenom: textEditingControllerPrenom.text,
          timeStamp: Timestamp.fromDate(pickedDate.value)
    ).then(
        (value){
          if (value){
            emit(value);
          }else{
            context.showToast(
                    pdHorizontal: 30,
                    pdVertical: 12,
                    textSize:18,
                    bgColor: Colors.red.withOpacity(0.7),
                    msg: "une erreur s'est produite lors de la mise a jour de ce compte,réessayez",
                    position: VxToastPosition.top
                );
            canupdate=true;
          }
        } 
        );
}else{
  fireMethods.upDateNoAnimaProfile(
          cin: user.cin,
          name: textEditingControllerNom.text,
          pass: textEditingControllerPassword.text,
          prenom: textEditingControllerPrenom.text,
          currentpass: user.pass
    ).then(
        (value){
          if (value){
            emit(value);
          }else{
            context.showToast(
                    pdHorizontal: 30,
                    pdVertical: 12,
                    textSize:18,
                    bgColor: Colors.red.withOpacity(0.7),
                    msg: "une erreur s'est produite lors de la mise a jour de ce compte,réessayez",
                    position: VxToastPosition.top
                );
            canupdate=true;
          }
        } 
        );
}
      
    }


  }




}