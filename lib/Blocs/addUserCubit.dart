import 'package:declic_ap/resources/firebase_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class AddUserCubit extends Cubit<bool> {
  
  AddUserCubit() : super(false);



  final FireMethods fireMethods = FireMethods();
   BuildContext context;
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  final TextEditingController textEditingControllerCin = TextEditingController();
  final TextEditingController textEditingControllerNom = TextEditingController();
  final TextEditingController textEditingControllerPrenom = TextEditingController();
  final TextEditingController textEditingControllerPassword = TextEditingController();
  final TextEditingController textEditingControllerMagasin = TextEditingController();
  final TextEditingController textEditingControllerCin2 = TextEditingController();

  bool canregister = true;
  ValueNotifier<int> selectedRole = ValueNotifier<int>(1);
  final ValueNotifier<DateTime> pickedDate = ValueNotifier(DateTime.now());
  void init(BuildContext cntx){
    context = cntx;
  }

  Future<void> registerUser()async{
    if (canregister&&globalKey.currentState.validate()){
      final Us user = Us(
        pos: null,
        cin2: textEditingControllerCin2.text,
        cin: textEditingControllerCin.text,
        nom: textEditingControllerNom.text,
        prenom: textEditingControllerPrenom.text,
        pass: textEditingControllerPassword.text,
        magasin: textEditingControllerMagasin.text,
        timestamp: selectedRole.value==3? Timestamp.fromDate(pickedDate.value) : Timestamp.now(),
        signed: false,
        deleted: false,
        roleNum: selectedRole.value
      );

      fireMethods.registerUser(context,user).then(
        (value){
          if (value){
            emit(value);
          }else{
            canregister=true;
          }
        } 
        );
    }


  }




}