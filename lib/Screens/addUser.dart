import 'package:declic_ap/Blocs/addUserCubit.dart';
import 'package:declic_ap/Widgets/MycustomB.dart';
import 'package:declic_ap/Widgets/PcustomPaint.dart';
import 'package:declic_ap/Widgets/TopBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../const/const.dart';

class AddUser extends StatelessWidget {
  const AddUser({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xffFFFFFF),
      body: SingleChildScrollView(
          child: Container(
        constraints: BoxConstraints(minHeight: size.height),
        child: CustomPaint(
          child: Container(
            margin: EdgeInsets.only(
              top: kToolbarHeight - kToolbarHeight / 2,
              left: size.width * 0.025,
              right: size.width * 0.025,
            ),
            child: Column(
              children: [
                TopBar(
                  leading: IconButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.arrow_back_outlined)),
                  lWidget: Image.asset(
                    "assets/logo@1X.png",
                    width: size.height * 0.1,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.1,
                ),
                BlocProvider(
                    create: (cntx) => AddUserCubit()..init(context),
                    child: BlocListener<AddUserCubit, bool>(
                      listener: (cntx, state) {
                        if (state) {
                          Navigator.of(context).pop(true);
                        }
                      },
                      child: AddUserForm(),
                    )),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
          size: Size.infinite,
          painter: MyPCPainter(Color(0xffFF56C7)),
        ),
      )),
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

class AddUserForm extends StatelessWidget {
  AddUserForm({Key key}) : super(key: key);

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
    final AddUserCubit addUserCubit =
        BlocProvider.of<AddUserCubit>(context, listen: false);
    return Card(
        elevation: 10,
        color: Colors.white.withOpacity(0.6),
        child: Form(
          key: addUserCubit.globalKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.025),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  maxLength: 8,
                  validator: (string) => isvalideCin(string),
                  controller: addUserCubit.textEditingControllerCin,
                  decoration: InputDecoration(
                      hintText: "Cin",
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (string) => isValidNom(string),
                  controller: addUserCubit.textEditingControllerNom,
                  decoration: InputDecoration(
                      hintText: "Nom",
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
                  controller: addUserCubit.textEditingControllerPrenom,
                  decoration: InputDecoration(
                      hintText: "Prenom",
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
                  controller: addUserCubit.textEditingControllerPassword,
                  decoration: InputDecoration(
                      hintText: "Mot de passe",
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
                ValueListenableBuilder(
                  valueListenable: addUserCubit.selectedRole,
                  builder: (BuildContext context, int value, Widget child) {
                    return DropdownButton<int>(
                      items: roleItems,
                      value: value,
                      onChanged: (val) {
                        addUserCubit.selectedRole.value = val;
                      },
                    );
                  },
                ),
                ValueListenableBuilder(
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (string) => isvalidMagasinName(string),
                        controller: addUserCubit.textEditingControllerMagasin,
                        decoration: InputDecoration(
                            hintText: "Nom de magasin",
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5))),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        validator: (string) => isvalideCin(string),
                        controller: addUserCubit.textEditingControllerCin2,
                        maxLength: 8,
                        decoration: InputDecoration(
                            hintText: "Cin de l'Animatrice",
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5))),
                      ),
                    ],
                  ),
                  valueListenable: addUserCubit.selectedRole,
                  builder: (BuildContext context, int value, Widget child) {
                    return value == 3 ? child : SizedBox();
                  },
                ),
                ValueListenableBuilder(
                  child: ValueListenableBuilder(
                    valueListenable: addUserCubit.pickedDate,
                    builder:
                        (BuildContext context, DateTime value, Widget child) {
                      return Container(
                        margin: EdgeInsets.only(top: 20),
                        child: ListTile(
                          title: Text(
                              "Date : ${value.day}/${value.month}/${value.year}"),
                          trailing: Icon(Icons.keyboard_arrow_down),
                          onTap: () async {
                            pickDate(addUserCubit.context, value)
                                .then((value1) {
                              addUserCubit.pickedDate.value = value1 ?? value;
                            });
                          },
                        ),
                      );
                    },
                  ),
                  valueListenable: addUserCubit.selectedRole,
                  builder: (BuildContext context, int value, Widget child) {
                    return value == 3 ? child : Container();
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                MyCustomB(
                  radius: 20,
                  onTap: () async => addUserCubit.registerUser(),
                  color: Colors.blue,
                  hMargin: 10,
                  text: "Créer",
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ));
  }
}
