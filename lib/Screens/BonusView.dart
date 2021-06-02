import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:declic_ap/Widgets/BonusItemW.dart';
import 'package:declic_ap/Widgets/PcustomPaint.dart';
import 'package:declic_ap/models/bonus.dart';
import 'package:declic_ap/models/produit.dart';
import 'package:declic_ap/resources/firebase_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Widgets/Extension.dart';

class BonusView extends StatelessWidget {
  BonusView({
    Key key,
    this.bonus2 = false,
    this.produit,
    @required this.bonus3,
  }) : super(key: key);

  final bool bonus2;
  final bool bonus3;

  final Produit produit;
  final FireMethods fireMethods = FireMethods();

  Future<int> createDialog(BuildContext context, int maxL) {
    GlobalKey<FormState> globalKey = GlobalKey<FormState>();
    TextEditingController textEditingController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title:
                Text("Donner la quantité de cette vente pour chaque bonus ?"),
            content: Form(
              key: globalKey,
              child: TextFormField(
                controller: textEditingController,
                validator: (str) {
                  if (int.parse(str.trim()) < 1) {
                    return "Entrer un nombre superieur ou egale a 1";
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            elevation: 10,
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
                child: Text("Annuler"),
              ),
              MaterialButton(
                onPressed: () {
                  if (globalKey.currentState.validate()) {
                    Navigator.of(context)
                        .pop(int.parse(textEditingController.text));
                  }
                },
                child: Text(
                  "Continue",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Material(
      color: Color(0xff9FD1A2),
      child: Container(
        constraints: BoxConstraints(maxHeight: size.height * 0.85),
        child: SingleChildScrollView(
          child: Card(
            elevation: 3,
            margin: EdgeInsets.all(0),
            color: Colors.white.withOpacity(0.6),
            child: Container(
              width: size.width * .9,
              child: StreamBuilder(
                stream: fireMethods.getBonusStream(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    if (snapshot.data.docs.isNotEmpty) {
                      final List<QueryDocumentSnapshot> docsSnapshot =
                          snapshot.data.docs;

                      return Padding(
                        padding: EdgeInsets.all(size.width * 0.006),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: size.width * 0.006,
                          children: docsSnapshot.map((e) {
                            final Bonus bonus = Bonus.fromMap(e.data());
                            return SizedBox(
                              width:
                                  size.width > 1000 ? size.width * 0.441 : null,
                              child: Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: BonusItemW(
                                    bonus: bonus,
                                    onTap: () {
                                      if (produit != null) {
                                        if (bonus.id == produit.bonusId &&
                                            bonus2) {
                                          context.showToast(
                                              pdHorizontal: 30,
                                              pdVertical: 12,
                                              textSize: 18,
                                              bgColor:
                                                  Colors.red.withOpacity(0.7),
                                              msg:
                                                  "ce vente déja liee a ce bonus",
                                              position: VxToastPosition.top);
                                        } else if (bonus.id ==
                                                    produit.bonusId &&
                                                bonus3 ||
                                            bonus.id == produit.bonus2Id &&
                                                bonus3) {
                                          context.showToast(
                                              pdHorizontal: 30,
                                              pdVertical: 12,
                                              textSize: 18,
                                              bgColor:
                                                  Colors.red.withOpacity(0.7),
                                              msg:
                                                  "ce vente déja liee a ce bonus",
                                              position: VxToastPosition.top);
                                        } else {
                                          createDialog(context, null)
                                              .then((value) async {
                                            if (value != null) {
                                              if (bonus2) {
                                                fireMethods
                                                    .add2Bonus(Produit.with2Bonus(
                                                        bonus3: false,
                                                        name: produit.name,
                                                        bonus2: true,
                                                        bonus2Id: bonus.id,
                                                        bonus2ImageUrl:
                                                            bonus.imageUrl,
                                                        bonus2Name: bonus.name,
                                                        bonus2Q: value,
                                                        id: produit.id,
                                                        bonusId:
                                                            produit.bonusId,
                                                        bonusImageUrl: produit
                                                            .bonusImageUrl,
                                                        bonusName:
                                                            produit.bonusName,
                                                        timestamp:
                                                            produit.timestamp,
                                                        quantity:
                                                            produit.quantity,
                                                        imageUrl:
                                                            produit.imageUrl,
                                                        bonusQ: produit.bonusQ,
                                                        des: produit.des))
                                                    .then((value) {
                                                  Navigator.of(context)
                                                      .pop(value);
                                                });
                                              } else {
                                                fireMethods
                                                    .add3Bonus(Produit.with3Bonus(
                                                        bonus3: true,
                                                        name: produit.name,
                                                        bonus2: true,
                                                        bonus3Id: bonus.id,
                                                        bonus3ImageUrl:
                                                            bonus.imageUrl,
                                                        bonus3Name: bonus.name,
                                                        bonus3Q: value,
                                                        bonus2Id:
                                                            produit.bonus2Id,
                                                        bonus2ImageUrl: produit
                                                            .bonus2ImageUrl,
                                                        bonus2Name:
                                                            produit.bonus2Name,
                                                        bonus2Q:
                                                            produit.bonus2Q,
                                                        id: produit.id,
                                                        bonusId:
                                                            produit.bonusId,
                                                        bonusImageUrl: produit
                                                            .bonusImageUrl,
                                                        bonusName:
                                                            produit.bonusName,
                                                        timestamp:
                                                            produit.timestamp,
                                                        quantity:
                                                            produit.quantity,
                                                        imageUrl:
                                                            produit.imageUrl,
                                                        bonusQ: produit.bonusQ,
                                                        des: produit.des))
                                                    .then((value) {
                                                  Navigator.of(context)
                                                      .pop(value);
                                                });
                                              }
                                            }
                                          });
                                        }
                                      } else {
                                        createDialog(context, null)
                                            .then((value) async {
                                          if (value != null) {
                                            Navigator.of(context).pop(
                                              Bonus(
                                                id: bonus.id,
                                                imageUrl: bonus.imageUrl,
                                                name: bonus.name,
                                                quantity: value,
                                              ),
                                            );
                                          }
                                        });
                                      }
                                    },
                                  )),
                            );
                          }).toList(),
                        ),
                      );
                    }
                    return Center(
                      child: Text("PAS DE BONUS ENCORE.."),
                    );
                  }
                  return Center(
                    child: CupertinoActivityIndicator(
                      radius: 20,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
