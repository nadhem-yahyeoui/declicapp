import 'package:declic_ap/Blocs/updateUserCubit.dart';
import 'package:declic_ap/Widgets/MycustomB.dart';
import 'package:declic_ap/Widgets/PcustomPaint.dart';
import 'package:declic_ap/const/const.dart';
import 'package:declic_ap/models/user.dart';
import 'package:declic_ap/resources/firebase_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateUserScreen extends StatelessWidget {
  final Us user;

  UpdateUserScreen({Key key, this.user}) : super(key: key);

  final FireMethods fireMethods = FireMethods();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    print("EDIT PROFILE BUILDED");

    return Material(
      color: Color(0xffFFFFFF),
      child: Container(
        constraints: BoxConstraints(
            minHeight: size.height * 0.85, maxHeight: size.height * 0.85),
        child: CustomPaint(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * .01, vertical: size.width * .01),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Card(
                      elevation: 3,
                      color: Colors.white.withOpacity(0.6),
                      child: BlocProvider(
                          create: (cntx) =>
                              UpdateUserCubit()..init(context, user),
                          child: BlocListener<UpdateUserCubit, bool>(
                            listener: (cntx, state) {
                              if (state) {
                                Navigator.of(context).pop(true);
                              }
                            },
                            child: UpdateUserForm(),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
          size: Size.infinite,
          painter: MyPCPainter(Color(0xff9FD1A2)),
        ),
      ),
    );
  }
}

Future<DateTime> pickDate(BuildContext context, DateTime dateTime) async {
  return await showDatePicker(
    lastDate: DateTime(DateTime.now().year + 10),
    firstDate: DateTime(DateTime.now().year - 10),
    context: context,
    initialDate: dateTime,
  );
}

class UpdateUserForm extends StatelessWidget {
  UpdateUserForm({Key key}) : super(key: key);

  final List<DropdownMenuItem<int>> roleItems = List.generate(
      MyConst.roles.length,
      (index) => DropdownMenuItem(
            child: Text(MyConst.roles[index].name),
            value: MyConst.roles[index].id,
          ));

  String isvalideCin(String string) {
    if (string.length != 8 || isnotNumeric(string))
      return "cin doit contenir 8 chiffres";
    return null;
  }

  String isValidNom(String string) {
    if (string.length < 5) {
      return "nom doit contenir 5 character au moins";
    }
    return null;
  }

  String isValidprenom(String string) {
    if (string.length < 5) {
      return "prenom doit contenir 5 character au moins";
    }
    return null;
  }

  bool isnotNumeric(String s) {
    try {
      int.parse(s);
      return false;
    } catch (e) {
      return true;
    }
  }

  String isvalidepass(String string) {
    if (string.length < 8)
      return "la longueur du mot de passe doit etre d'au moins 8";
    return null;
  }

  String isvalidMagasinName(String string) {
    if (string.length < 8) {
      return "nom de la magasin doit contenir 8 character au moins";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final UpdateUserCubit updateUserCubit =
        BlocProvider.of<UpdateUserCubit>(context, listen: false);

    return Form(
      key: updateUserCubit.globalKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.025),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            updateUserCubit.user.roleNum == 3
                ? TextFormField(
                    maxLength: 8,
                    validator: (string) => isvalideCin(string),
                    controller: updateUserCubit.textEditingControllerCin,
                    decoration: InputDecoration(
                        labelText: "Cin de l'Animatrice",
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                  )
                : SizedBox(),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              validator: (string) => isValidNom(string),
              controller: updateUserCubit.textEditingControllerNom,
              decoration: InputDecoration(
                  labelText: "Nom",
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5))),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              validator: (string) => isValidprenom(string),
              controller: updateUserCubit.textEditingControllerPrenom,
              decoration: InputDecoration(
                  labelText: "Prenom",
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5))),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              validator: (string) => isvalidepass(string),
              controller: updateUserCubit.textEditingControllerPassword,
              decoration: InputDecoration(
                  labelText: "Mot de passe",
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5))),
            ),
            updateUserCubit.user.roleNum == 3
                ? Column(
                    children: [
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        validator: (string) => isvalidMagasinName(string),
                        controller:
                            updateUserCubit.textEditingControllerMagasin,
                        decoration: InputDecoration(
                            labelText: "Nom de magasin",
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5))),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      ValueListenableBuilder(
                        valueListenable: updateUserCubit.pickedDate,
                        builder: (BuildContext context, DateTime value,
                            Widget child) {
                          return Container(
                            margin: EdgeInsets.only(top: 20),
                            child: ListTile(
                              title: Text(
                                  "Date : ${value.day}/${value.month}/${value.year}"),
                              trailing: Icon(Icons.keyboard_arrow_down),
                              onTap: () async {
                                pickDate(updateUserCubit.context, value)
                                    .then((value1) {
                                  updateUserCubit.pickedDate.value =
                                      value1 ?? value;
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  )
                : SizedBox(),
            SizedBox(
              height: 20,
            ),
            MyCustomB(
              radius: 20,
              onTap: () async => updateUserCubit.updateUser(),
              color: Colors.blue,
              hMargin: 10,
              text: "Sauvgarder",
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
