import 'package:declic_ap/models/FetchedUser.dart';
import 'package:declic_ap/resources/firebase_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Widgets/Extension.dart';


class SignInCubit extends Cubit<FetchedUser> {

  SignInCubit() : super(null);

  final TextEditingController cinTextController = TextEditingController();
  final TextEditingController passTextController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FireMethods fireMethods = FireMethods();
   BuildContext context;
   bool canSignIn = true;
   bool canhandlepass = true;
init(BuildContext cntx){
  context=cntx;
}

void handlePassOublier()async{
  if (canhandlepass){
    canhandlepass=false;
    fireMethods
  .handleoublierpassword(cinTextController.text)
  .then((value){
   if (value) {
     context.showToast(
                    pdHorizontal: 30,
                    pdVertical: 12,
                    textSize:18,
                    bgColor: Colors.green.withOpacity(0.7),
                    msg: "Nous avons envoyé un message a l'administrateur concernant l'oubli du mot de passe",
                    position: VxToastPosition.top
                );
      }else{
                  context.showToast(
                    pdHorizontal: 30,
                    pdVertical: 12,
                    textSize:18,
                    bgColor: Colors.red.withOpacity(0.7),
                    msg: "cin invalide",
                    position: VxToastPosition.top
                );
      }
  });
    canhandlepass=true;
  }

}

  Future<void> signIn()async{
    if (formKey.currentState.validate()&&canSignIn){
      canSignIn=false;
      fireMethods.signIn(context,cinTextController.text, passTextController.text).then(
        (fetchedUser){
          if (fetchedUser?.userR!=null){
            emit(fetchedUser);
          }else{
           /* context.showToast(
                    pdHorizontal: 30,
                    pdVertical: 12,
                    textSize:18,
                    bgColor: Colors.red.withOpacity(0.7),
                    msg: "une erreur s'est produite lors de connection",
                    position: VxToastPosition.top
                );*/
            canSignIn=true;
          }
        }
      );
    }else return;
  }


}