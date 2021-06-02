import 'package:declic_ap/Screens/ProduitView.dart';
import 'package:declic_ap/Screens/ReclamationS.dart';
import 'package:declic_ap/Screens/addBonus.dart';
import 'package:declic_ap/Screens/DashUserView.dart';
import 'package:declic_ap/Screens/addProduct.dart';
import 'package:declic_ap/Screens/addUser.dart';
import 'package:declic_ap/Widgets/PcustomPaint.dart';
import 'package:declic_ap/Widgets/ProfileW.dart';
import 'package:declic_ap/Widgets/SlideLeftRoute.dart';
import 'package:declic_ap/const/const.dart';
import 'package:declic_ap/resources/firebase_methods.dart';
import 'package:flutter/material.dart';
import '../Widgets/Extension.dart';
import 'LoginScreen.dart';
import 'TransfertScreen.dart';
import 'add2Bonus.dart';
import 'add3Bonus.dart';

class DashBoard extends StatelessWidget {
  bool afterL;

  DashBoard({Key key, this.afterL}) : super(key: key);

  final FireMethods fireMethods = FireMethods();

  void backToLoginScreen(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (cntx) => LoginScreen()),
          (route) => false);
    });
  }

  Future<bool> createDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("voulez-vous vraiment vous déconnecter?      "),
            elevation: 10,
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text("Non"),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  "Oui",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              )
            ],
          );
        });
  }

  Future<int> createDialogForAddP(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Choisir un evenement  "),
            elevation: 10,
            scrollable: true,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextButton(
                  child: Text(
                      "Ajout d'une 1ere vente lier a une nouvelle gratuité"),
                  onPressed: () => Navigator.of(context).pop(1),
                ),
                TextButton(
                  child: Text("Ajout d'un 2eme vente a une excitante gratuité"),
                  onPressed: () => Navigator.of(context).pop(0),
                ),
                TextButton(
                  child: Text("Ajout d'un 3eme vente a une excitante gratuité"),
                  onPressed: () => Navigator.of(context).pop(3),
                ),
                TextButton(
                  child: Text("Declarer une nouvelle vente"),
                  onPressed: () => Navigator.of(context).pop(2),
                )
              ],
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
                child: Text("Annuler"),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final double _myWIDTH = MediaQuery.of(context).size.width;

    if (afterL)
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        context.showToast(
            pdHorizontal: 30,
            pdVertical: 12,
            textSize: 18,
            bgColor: Colors.green.withOpacity(0.7),
            msg: "Connexion réussie en tant qu'ADMIN⭐",
            position: VxToastPosition.top);
        afterL = false;
      });

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffFFFFFF),
          leading: Row(
            children: [
              SizedBox(
                width: 5,
              ),
              ProfileW(
                imageUrl:
                    "https://www.pngfind.com/pngs/m/528-5286002_forum-admin-icon-png-nitzer-ebb-that-total.png",
              ),
            ],
          ),
          leadingWidth: 70,
          centerTitle: true,
          title: Image.asset(
            "assets/logo@1X.png",
            height: kToolbarHeight + 10,
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  createDialog(context).then((value) {
                    if (value) {
                      fireMethods.signOut().then(
                          (value) => value ? backToLoginScreen(context) : "");
                    }
                  });
                },
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.red,
                ))
          ],
        ),
        body: SingleChildScrollView(
            child: CustomPaint(
          child: Container(
              width: _myWIDTH,
              constraints:
                  BoxConstraints(minHeight: MediaQuery.of(context).size.height),
              padding: EdgeInsets.all(10),
              child: GridView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _myWIDTH > 800 ? 4 : 2,
                    crossAxisSpacing: 8),
                children: [
                  DashItem(
                      widget: Icon(Icons.add),
                      widget2: Text("Ajouter un utilisateur"),
                      onTap: () => Navigator.push(
                                  context, SlideLeftRoute(page: AddUser()))
                              .then((value) {
                            if (value != null) {
                              if (value == true) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((timeStamp) {
                                  context.showToast(
                                      pdHorizontal: 30,
                                      pdVertical: 12,
                                      textSize: 18,
                                      bgColor: Colors.green.withOpacity(0.7),
                                      msg: "Compte créé avec succès ✅",
                                      position: VxToastPosition.top);
                                });
                              }
                            }
                          })),
                  DashItem(
                      widget: Icon(Icons.add),
                      widget2: Text("Ajouter un produit"),
                      onTap: () {
                        createDialogForAddP(context).then((value) {
                          if (value != null) {
                            if (value == 1) {
                              Navigator.push(context,
                                      SlideLeftRoute(page: AddProduct()))
                                  .then((value) {
                                if (value != null) {
                                  if (value == true) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((timeStamp) {
                                      context.showToast(
                                          pdHorizontal: 30,
                                          pdVertical: 12,
                                          textSize: 18,
                                          bgColor:
                                              Colors.green.withOpacity(0.7),
                                          msg: "Gratuité ajouté avec succès ✅",
                                          position: VxToastPosition.top);
                                    });
                                  }
                                }
                              });
                            } else if (value == 2) {
                              Navigator.push(
                                      context, SlideLeftRoute(page: AddBonus()))
                                  .then((value) {
                                if (value != null) {
                                  if (value == true) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((timeStamp) {
                                      context.showToast(
                                          pdHorizontal: 30,
                                          pdVertical: 12,
                                          textSize: 18,
                                          bgColor:
                                              Colors.green.withOpacity(0.7),
                                          msg: "Vente ajouté avec succès ✅",
                                          position: VxToastPosition.top);
                                    });
                                  }
                                }
                              });
                            } else if (value == 0) {
                              showModalBottomSheet(
                                      elevation: 10,
                                      context: context,
                                      builder: (context) => Add2Bonus(),
                                      isScrollControlled: true)
                                  .then((value) {
                                if (value != null) {
                                  if (value == true) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((timeStamp) {
                                      context.showToast(
                                          pdHorizontal: 30,
                                          pdVertical: 12,
                                          textSize: 18,
                                          bgColor:
                                              Colors.green.withOpacity(0.7),
                                          msg: "Vente N°2 ajouté avec succès ✅",
                                          position: VxToastPosition.top);
                                    });
                                  }
                                }
                              });
                            } else if (value == 3) {
                              showModalBottomSheet(
                                      elevation: 10,
                                      context: context,
                                      builder: (context) => Add3Bonus(),
                                      isScrollControlled: true)
                                  .then((value) {
                                if (value != null) {
                                  if (value == true) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((timeStamp) {
                                      context.showToast(
                                          pdHorizontal: 30,
                                          pdVertical: 12,
                                          textSize: 18,
                                          bgColor:
                                              Colors.green.withOpacity(0.7),
                                          msg: "Vente N°3 ajouté avec succès ✅",
                                          position: VxToastPosition.top);
                                    });
                                  }
                                }
                              });
                            }
                          }
                        });
                      }),
                  DashItem(
                    widget: Icon(Icons.rate_review_outlined),
                    widget2: Text("Voir les réclamations"),
                    onTap: () => Navigator.of(context).push(SlideLeftRoute(
                        page: ClaimScreen(
                      cin: MyConst.adminUid,
                    ))),
                  ),
                  DashItem(
                    widget: Icon(Icons.receipt_rounded),
                    widget2: Text("Voir les Transporteur"),
                    onTap: () => Navigator.of(context).push(SlideLeftRoute(
                        page: DashUserView(
                      id: 1,
                    ))),
                  ),
                  DashItem(
                    widget: Icon(Icons.supervised_user_circle_outlined),
                    widget2: Text("Voir les Magasins"),
                    onTap: () => Navigator.of(context).push(SlideLeftRoute(
                        page: DashUserView(
                      id: 3,
                    ))),
                  ),
                  DashItem(
                    widget: Icon(Icons.person_outline_outlined),
                    widget2: Text("Voir les Supervisors"),
                    onTap: () => Navigator.of(context).push(SlideLeftRoute(
                        page: DashUserView(
                      id: 2,
                    ))),
                  ),
                  DashItem(
                    widget: Icon(Icons.wallet_giftcard_outlined),
                    widget2: Text("Voir les bonus"),
                    onTap: () => Navigator.of(context).push(SlideLeftRoute(
                        page: ProduitView(
                      cin: MyConst.adminUid,
                      canEdit: true,
                    ))),
                  ),
                  DashItem(
                    widget: Icon(Icons.transfer_within_a_station),
                    widget2: Text("Voir les Transfers"),
                    onTap: () => Navigator.of(context)
                        .push(SlideLeftRoute(page: TransfertScreen())),
                  ),
                ],
              )),
          size: Size.infinite,
          painter: MyPCPainter(Color(0xff9FD1A2)),
        )));
  }
}

class DashItem extends StatelessWidget {
  final Widget widget;
  final Widget widget2;
  final Function onTap;
  const DashItem({Key key, this.widget, this.widget2, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget ?? SizedBox(),
            SizedBox(
              height: 10,
            ),
            widget2 ?? SizedBox()
          ],
        ),
      ),
    ));
  }
}
