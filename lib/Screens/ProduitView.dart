import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:declic_ap/Utils/Utils.dart';
import 'package:declic_ap/Widgets/BonusItemW.dart';
import 'package:declic_ap/Widgets/PcustomPaint.dart';
import 'package:declic_ap/Widgets/ProduitItemW.dart';
import 'package:declic_ap/Widgets/TopBar.dart';
import 'package:declic_ap/models/Transfert.dart';
import 'package:declic_ap/models/bonus.dart';
import 'package:declic_ap/models/produit.dart';
import 'package:declic_ap/resources/firebase_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Widgets/Extension.dart';

class ProduitView extends StatelessWidget {
  final bool canEdit;
  final String cin;
  final int senderRole;
  final int receiverRole;
  final String senderName;
  final String receiverName;
  final String cin2;

  ProduitView(
      {Key key,
      this.canEdit = false,
      this.cin,
      this.cin2,
      this.senderName,
      this.receiverName,
      this.senderRole,
      this.receiverRole})
      : super(key: key);

  final FireMethods fireMethods = FireMethods();

  Future<bool> createDialog(BuildContext context, String id) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Voulez-vous vraiment supprimer ce bonus?      "),
            elevation: 10,
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
                child: Text("NON"),
              ),
              MaterialButton(
                onPressed: () {
                  fireMethods
                      .deleteBonus(id)
                      .then((value) => Navigator.of(context).pop(value));
                },
                child: Text(
                  "OUI",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              )
            ],
          );
        });
  }

  Future<bool> createDialogForTransfert(
      BuildContext context, int maxL, Function onConfirme) {
    GlobalKey<FormState> globalKey = GlobalKey<FormState>();
    TextEditingController textEditingController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title:
                Text("Donner la quantité qui tu veut transferer de ce bonus"),
            content: Form(
              key: globalKey,
              child: TextFormField(
                controller: textEditingController,
                validator: (str) {
                  final int value = int.parse(str);
                  if (value < 1 || value > maxL) {
                    return "Entrer un nombre entre 1 et ${maxL.toString()}";
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
                onPressed: () async =>
                    onConfirme(context, globalKey, textEditingController),
                child: Text(
                  "Envoyer",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              )
            ],
          );
        });
  }

  Future<bool> createDialogForAJout(BuildContext context, Function onConfirme) {
    GlobalKey<FormState> globalKey = GlobalKey<FormState>();
    TextEditingController textEditingController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Donner la quantité qui tu veut ajouter "),
            content: Form(
              key: globalKey,
              child: TextFormField(
                controller: textEditingController,
                validator: (str) {
                  final int value = int.parse(str);
                  if (value < 1) {
                    return "Entrer un nombre superieur a 1";
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
                onPressed: () async =>
                    onConfirme(context, globalKey, textEditingController),
                child: Text(
                  "Ajouter",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              )
            ],
          );
        });
  }

  createDialogForBonusView(
      BuildContext context, Bonus bonus, Bonus bonus2, Bonus bonus3) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: Container(
              child: bonus2 != null
                  ? Column(
                      children: [
                        BonusItemW(
                          bonus: bonus,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        BonusItemW(
                          bonus: bonus2,
                        ),
                        if (bonus3 != null)
                          BonusItemW(
                            bonus: bonus3,
                          ),
                      ],
                    )
                  : BonusItemW(
                      bonus: bonus,
                    ),
            ),
            scrollable: true,
            elevation: 10,
          );
        });
  }

  bool canSend = true;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    print("PRODUIT VIEW BUILDED");

    return Material(
      color: Color(0xffFFFFFF),
      child: Container(
        constraints: !canEdit
            ? BoxConstraints(maxHeight: size.height * 0.85)
            : BoxConstraints(
                minHeight: size.height,
                maxHeight: size.height,
              ),
        child: CustomPaint(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * .01,
                vertical: canEdit ? size.height * 0.05 : size.width * .01),
            child: Column(
              children: [
                if (canEdit)
                  Container(
                    child: TopBar(
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
                    padding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                Container(
                  width: size.width * .9,
                  constraints: !canEdit
                      ? BoxConstraints(maxHeight: size.height * 0.8)
                      : BoxConstraints(
                          minHeight: size.height * .8,
                          maxHeight: size.height * .8,
                        ),
                  child: Card(
                    margin: EdgeInsets.all(0),
                    elevation: 3,
                    color: Colors.grey.withOpacity(0.6),
                    child: StreamBuilder(
                      stream: fireMethods.getProducts(cin),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          if (snapshot.data.docs.isNotEmpty) {
                            final List<QueryDocumentSnapshot> docsSnapshot =
                                snapshot.data.docs;
                            return SingleChildScrollView(
                              padding: EdgeInsets.all(size.width * 0.006),
                              child: Wrap(
                                  spacing: size.width * 0.006,
                                  children: docsSnapshot.map((e) {
                                    final Produit produit = e.get("bonus")
                                        ? e.get("bonus2")
                                            ? Produit.from3Map(e.data())
                                            : Produit.from2Map(e.data())
                                        : Produit.fromMap(e.data());
                                    return SizedBox(
                                      width: size.width > 1000
                                          ? size.width * 0.441
                                          : null,
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: ProduitItemW(
                                          ondeleteTaped: () async {
                                            createDialog(context, produit.id)
                                                .then((value) async {
                                              if (value != null) {
                                                if (value) {
                                                  context.showToast(
                                                      pdHorizontal: 30,
                                                      pdVertical: 12,
                                                      textSize: 18,
                                                      bgColor: Colors.green
                                                          .withOpacity(0.7),
                                                      msg:
                                                          "Bonus supprimé avec sucess",
                                                      position:
                                                          VxToastPosition.top);
                                                } else {
                                                  context.showToast(
                                                      pdHorizontal: 30,
                                                      pdVertical: 12,
                                                      textSize: 18,
                                                      bgColor: Colors.red
                                                          .withOpacity(0.7),
                                                      msg: "ERREUR",
                                                      position:
                                                          VxToastPosition.top);
                                                }
                                              }
                                            });
                                          },
                                          onBonusTaped: () async {
                                            createDialogForBonusView(
                                              context,
                                              Bonus(
                                                imageUrl: produit.bonusImageUrl,
                                                name: produit.bonusName,
                                                quantity: produit.bonusQ,
                                              ),
                                              produit.bonus2
                                                  ? Bonus(
                                                      imageUrl: produit
                                                          .bonus2ImageUrl,
                                                      name: produit.bonus2Name,
                                                      quantity: produit.bonus2Q)
                                                  : null,
                                              produit.bonus3
                                                  ? Bonus(
                                                      imageUrl: produit
                                                          .bonus3ImageUrl,
                                                      name: produit.bonus3Name,
                                                      quantity: produit.bonus3Q)
                                                  : null,
                                            );
                                          },
                                          onWidgetTap: canEdit
                                              ? () => ""
                                              : () async {
                                                  if (produit.quantity == 0) {
                                                    context.showToast(
                                                        pdHorizontal: 30,
                                                        pdVertical: 12,
                                                        textSize: 18,
                                                        bgColor: Colors.red
                                                            .withOpacity(0.7),
                                                        msg:
                                                            "Stock est vide pour ce produit",
                                                        position:
                                                            VxToastPosition
                                                                .top);
                                                  } else
                                                    createDialogForTransfert(
                                                        context,
                                                        produit.quantity,
                                                        (BuildContext cntx,
                                                            GlobalKey<FormState>
                                                                globalKey,
                                                            TextEditingController
                                                                textEditingController) async {
                                                      if (globalKey.currentState
                                                              .validate() &&
                                                          canSend) {
                                                        canSend = false;

                                                        final Produit produittopass = produit
                                                                .bonus2
                                                            ? produit.bonus3
                                                                ? Produit.with3Bonus(
                                                                    bonus3Id: produit
                                                                        .bonus3Id,
                                                                    bonus3ImageUrl: produit
                                                                        .bonus3ImageUrl,
                                                                    bonus3Name: produit
                                                                        .bonus3Name,
                                                                    bonus3Q: produit
                                                                        .bonus3Q,
                                                                    bonus3:
                                                                        true,
                                                                    bonus2: produit
                                                                        .bonus2,
                                                                    bonusId: produit
                                                                        .bonusId,
                                                                    bonusImageUrl:
                                                                        produit
                                                                            .bonusImageUrl,
                                                                    bonusName: produit
                                                                        .bonusName,
                                                                    bonusQ: produit
                                                                        .bonusQ,
                                                                    timestamp:
                                                                        Timestamp
                                                                            .now(),
                                                                    des: produit
                                                                        .des,
                                                                    id: produit
                                                                        .id,
                                                                    imageUrl: produit
                                                                        .imageUrl,
                                                                    name: produit
                                                                        .name,
                                                                    bonus2Id: produit
                                                                        .bonus2Id,
                                                                    bonus2ImageUrl:
                                                                        produit
                                                                            .bonus2ImageUrl,
                                                                    bonus2Name: produit
                                                                        .bonus2Name,
                                                                    bonus2Q: produit
                                                                        .bonus2Q,
                                                                    quantity: int.parse(
                                                                        textEditingController
                                                                            .text))
                                                                : Produit.with3Bonus(
                                                                    bonus3: false,
                                                                    bonus2: produit.bonus2,
                                                                    bonusId: produit.bonusId,
                                                                    bonusImageUrl: produit.bonusImageUrl,
                                                                    bonusName: produit.bonusName,
                                                                    bonusQ: produit.bonusQ,
                                                                    timestamp: Timestamp.now(),
                                                                    des: produit.des,
                                                                    id: produit.id,
                                                                    imageUrl: produit.imageUrl,
                                                                    name: produit.name,
                                                                    bonus2Id: produit.bonus2Id,
                                                                    bonus2ImageUrl: produit.bonus2ImageUrl,
                                                                    bonus2Name: produit.bonus2Name,
                                                                    bonus2Q: produit.bonus2Q,
                                                                    quantity: int.parse(textEditingController.text))
                                                            : Produit.with3Bonus(bonus3: false, bonus2: produit.bonus2, bonusId: produit.bonusId, bonusImageUrl: produit.bonusImageUrl, bonusName: produit.bonusName, bonusQ: produit.bonusQ, timestamp: Timestamp.now(), des: produit.des, id: produit.id, imageUrl: produit.imageUrl, name: produit.name, quantity: int.parse(textEditingController.text));
                                                        fireMethods
                                                            .handleProduitTransfert(Transfert(
                                                                senderRole: Utils
                                                                    .getFonctionName(
                                                                        senderRole),
                                                                receiverRole: Utils
                                                                    .getFonctionName(
                                                                        receiverRole),
                                                                oldQ: produit
                                                                    .quantity,
                                                                produit:
                                                                    produittopass,
                                                                receiver: cin2,
                                                                sender: cin,
                                                                senderName:
                                                                    senderName,
                                                                receiverName:
                                                                    receiverName))
                                                            .then((value) {
                                                          if (!value) {
                                                            cntx.showToast(
                                                                pdHorizontal:
                                                                    30,
                                                                pdVertical: 12,
                                                                textSize: 18,
                                                                bgColor: Colors
                                                                    .red
                                                                    .withOpacity(
                                                                        0.7),
                                                                msg:
                                                                    "une erreur s'est produite lors de le transfert de ce produit,réessayez",
                                                                position:
                                                                    VxToastPosition
                                                                        .top);
                                                          } else {
                                                            Navigator.of(cntx)
                                                                .pop(true);
                                                          }
                                                        });
                                                      }
                                                    }).then((value) =>
                                                        Navigator.of(context)
                                                            .pop(value));
                                                },
                                          produit: produit,
                                          canEdit: canEdit,
                                          onEditTap: () async {
                                            createDialogForAJout(
                                              context,
                                              (BuildContext cntx,
                                                  GlobalKey<FormState>
                                                      globalKey,
                                                  TextEditingController
                                                      textEditingController) async {
                                                if (globalKey.currentState
                                                    .validate()) {
                                                  fireMethods
                                                      .updateProduitByAdmin(
                                                          produitId: produit.id,
                                                          newValToProduit: int.parse(
                                                                  textEditingController
                                                                      .text) +
                                                              produit.quantity)
                                                      .then((value) =>
                                                          Navigator.of(cntx)
                                                              .pop(value));
                                                }
                                              },
                                            ).then((value) {
                                              if (value != null) {
                                                if (value) {
                                                  context.showToast(
                                                      pdHorizontal: 30,
                                                      pdVertical: 12,
                                                      textSize: 18,
                                                      bgColor: Colors.green
                                                          .withOpacity(0.7),
                                                      msg:
                                                          "le mise a jour de produit terminé avec succes",
                                                      position:
                                                          VxToastPosition.top);
                                                } else {
                                                  context.showToast(
                                                      pdHorizontal: 30,
                                                      pdVertical: 12,
                                                      textSize: 18,
                                                      bgColor: Colors.red
                                                          .withOpacity(0.7),
                                                      msg:
                                                          "une erreur s'est produite lors de la mise a jour de ce produit,réessayez",
                                                      position:
                                                          VxToastPosition.top);
                                                }
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  }).toList()),
                            );
                            /*ListView.builder(
                    padding: EdgeInsets.all(10),
                    shrinkWrap: true,
                    itemCount: docsSnapshot.length,
                    itemBuilder: (cntx, index) {
                     
                    });*/
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
              ],
            ),
          ),
          size: Size.infinite,
          painter: MyPCPainter(Color(0xff9FD1A2)),
        ),
      ),
    );
  }
}
