import 'package:declic_ap/resources/firebase_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Widgets/Extension.dart';
import '../models/bonus.dart';

class AddBonusCubit extends Cubit<bool>{


  AddBonusCubit() : super(false);

  final FireMethods fireMethods = FireMethods();

   BuildContext context;

  final TextEditingController textEditingControllerName = TextEditingController();

  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  String photoUrl;

  bool canadd = true;
  
  void init(BuildContext cntx){
    context = cntx;
  }

  Future<void> addBonus()async{
    if (canadd&&globalKey.currentState.validate()){
          canadd=false;
      final Bonus bonus = 
       Bonus(
        imageUrl: photoUrl,
        name:textEditingControllerName.text ,
      );
      fireMethods.addBonusToDb(bonus).then(
        (value){
          if (value){
            Navigator.of(context).pop(true);
          }else{
            context.showToast(
                    pdHorizontal: 30,
                    pdVertical: 12,
                    textSize:18,
                    bgColor: Colors.red.withOpacity(0.7),
                    msg: "une erreur s'est produite lors de l'ajout de ce bonus,réessayez",
                    position: VxToastPosition.top
                );
            canadd=true;
          }
        } 
        );
    }
}

}