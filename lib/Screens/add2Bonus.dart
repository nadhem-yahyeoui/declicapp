import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:declic_ap/Widgets/BonusItemW.dart';
import 'package:declic_ap/Widgets/PcustomPaint.dart';
import 'package:declic_ap/Widgets/ProduitItemW.dart';
import 'package:declic_ap/const/const.dart';
import 'package:declic_ap/models/bonus.dart';
import 'package:declic_ap/models/produit.dart';
import 'package:declic_ap/resources/firebase_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Widgets/Extension.dart';
import 'BonusView.dart';

class Add2Bonus extends StatelessWidget {
  Add2Bonus({
    Key key,
  }) : super(key: key);

  final FireMethods fireMethods = FireMethods();

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
                            bonus: bonus2,
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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Material(
      color: Color(0xffFFFFFF),
      child: Container(
        width: size.width * 0.9,
        constraints: BoxConstraints(maxHeight: size.height * 0.85),
        child: CustomPaint(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(5),
            child: Container(
              child: Column(
                children: [
                  Card(
                    elevation: 3,
                    color: Colors.white.withOpacity(0.6),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(size.width * 0.006),
                      child: StreamBuilder(
                        stream:
                            fireMethods.getProductswith1bonus(MyConst.adminUid),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            if (snapshot.data.docs.isNotEmpty) {
                              final List<QueryDocumentSnapshot> docsSnapshot =
                                  snapshot.data.docs;

                              return Wrap(
                                spacing: size.width * 0.006,
                                children: docsSnapshot.map((e) {
                                  final Produit product = e.get("bonus")
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
                                            onBonusTaped: () async {
                                              createDialogForBonusView(
                                                context,
                                                Bonus(
                                                    name: product.bonusName,
                                                    imageUrl:
                                                        product.bonusImageUrl,
                                                    quantity: product.bonusQ),
                                                product.bonus2
                                                    ? Bonus(
                                                        name:
                                                            product.bonus2Name,
                                                        imageUrl: product
                                                            .bonus2ImageUrl,
                                                        quantity:
                                                            product.bonus2Q)
                                                    : null,
                                                product.bonus3
                                                    ? Bonus(
                                                        name:
                                                            product.bonus3Name,
                                                        imageUrl: product
                                                            .bonus3ImageUrl,
                                                        quantity:
                                                            product.bonus3Q)
                                                    : null,
                                              );
                                            },
                                            produit: product,
                                            onWidgetTap: () {
                                              if (product.bonus2) {
                                                context.showToast(
                                                    pdHorizontal: 30,
                                                    pdVertical: 12,
                                                    textSize: 18,
                                                    bgColor: Colors.red
                                                        .withOpacity(0.7),
                                                    msg:
                                                        "a 2 types de vente déja",
                                                    position:
                                                        VxToastPosition.top);
                                              } else {
                                                showModalBottomSheet(
                                                        elevation: 10,
                                                        context: context,
                                                        builder: (context) =>
                                                            BonusView(
                                                              produit: product,
                                                              bonus2: true,
                                                            ),
                                                        isScrollControlled:
                                                            true)
                                                    .then((value) {
                                                  Navigator.of(context)
                                                      .pop(value);
                                                });
                                              }
                                            })),
                                  );
                                }).toList(),
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
