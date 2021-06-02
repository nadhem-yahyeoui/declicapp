import 'package:declic_ap/Widgets/PcustomPaint.dart';
import 'package:declic_ap/Widgets/TopBar.dart';
import 'package:declic_ap/Widgets/claimItemW.dart';
import 'package:declic_ap/models/claim.dart';
import 'package:declic_ap/resources/firebase_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';




const String noImageProfile = "https://spng.subpng.com/20190419/tbh/kisspng-computer-icons-user-profile-portable-network-graph-5cb9f8c9973df0.5660964015556917216195.jpg";

class ClaimScreen extends StatelessWidget {

  ClaimScreen({Key key, this.cin}) : super(key: key);

  final String cin;

  final FireMethods fireMethods = FireMethods();

  @override
  Widget build(BuildContext context) {

final Size size = Size(MediaQuery.of(context).size.width,MediaQuery.of(context).size.height);     
    
    return Material(
      color: Color(0xffFFFFFF),
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
                child: Container(
              constraints: BoxConstraints(
                minHeight: size.height,
              ),
            child: CustomPaint(
              child: Container(
                margin: EdgeInsets.only(
                  top: kToolbarHeight-kToolbarHeight/2,
                  left: size.width*0.05,
                  right: size.width*0.05,
                ),
                child: Column(
                  children: [
                   TopBar(
                    leading: IconButton(
                      onPressed: ()async{
                         Navigator.of(context).pop();
                        }, 
                      icon: Icon(Icons.arrow_back_outlined)
                      ),
                    lWidget: Image.asset("assets/logo@1X.png",width: size.height*0.1,),
                  ),
                  SizedBox(
                    height: size.height*.05,
                  ),
                  Card(
                    color: Colors.white.withOpacity(0.6),
                    child: Container(
                      width:size.width*.9 ,
                      height: size.height*.75,
                      child: StreamBuilder(
                        stream: fireMethods.getClaimStreamFrom(cin) ,
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                          
                          if (snapshot.hasData&&snapshot.data!=null){

                            if (snapshot.data.docs.isNotEmpty){

                              final List<QueryDocumentSnapshot> docsSnapshot = snapshot.data.docs;
                              
                              return ListView.builder(
                                padding: EdgeInsets.all(10),
                                shrinkWrap: true,                              
                                itemCount: docsSnapshot.length,
                                itemBuilder: (cntx,index){
                                  return ClaimItemW(
                                    isME:docsSnapshot[index].get("sender")==cin ,
                                    claim: Claim.fromMap(docsSnapshot[index].data()),
                                    );
                                }
                              );
                            }
                            return Center(
                              child: Text("PAS DE RECLAMATIONS ENCORE.."),
                            );
                          }
                            return Center(child: CupertinoActivityIndicator(radius: 20,),);
                        },
                      ),
                    ),
                  )
                  ],            
                ),
              ),
              size: Size.infinite,
              painter: MyPCPainter(Color(0xffA0368D)),
            ),
        ),
          ),
    );
  }
}