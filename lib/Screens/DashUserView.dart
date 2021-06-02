import 'dart:async';
import 'package:declic_ap/Widgets/DashUserItem.dart';
import 'package:declic_ap/Widgets/PcustomPaint.dart';
import 'package:declic_ap/Widgets/TopBar.dart';
import 'package:declic_ap/models/user.dart';
import 'package:declic_ap/resources/firebase_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class Debouncer{


final int milliseconds;
VoidCallback action;
Timer _timer;

  Debouncer(this.milliseconds);

run(VoidCallback action){

if (null!=_timer){
  _timer.cancel();
}

_timer=Timer(Duration(milliseconds:milliseconds,),action);

}


}
const String noImageProfile = "https://spng.subpng.com/20190419/tbh/kisspng-computer-icons-user-profile-portable-network-graph-5cb9f8c9973df0.5660964015556917216195.jpg";

class DashUserView extends StatefulWidget {

  DashUserView({Key key,this.id}) : super(key: key);

  final int id;

  @override
  _DashUserViewState createState() => _DashUserViewState();
}

class _DashUserViewState extends State<DashUserView> {
  final FireMethods fireMethods = FireMethods();

  final TextEditingController textEditingController = TextEditingController();

  final Debouncer debouncer = Debouncer(200);

  final ValueNotifier<List<QueryDocumentSnapshot>> docsSnapshotNotifier=ValueNotifier<List<QueryDocumentSnapshot>>([]);

  List<QueryDocumentSnapshot> docsSnapshot;

void filterUsers(String query){

  docsSnapshotNotifier.value = docsSnapshot.where((element){
    
    return "${element.get("nom").toLowerCase()} ${element.get("prenom").toLowerCase()} ${element.get("magasin").toLowerCase()}".contains(query.toLowerCase());
  
  }).toList();

}

  @override
  Widget build(BuildContext context) {

final Size size = Size(MediaQuery.of(context).size.width,MediaQuery.of(context).size.height-(kToolbarHeight-kToolbarHeight/2));     
    
    return Material(
      color: Color(0xffFFFFFF),
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
                child: Container(
             constraints: BoxConstraints(
               minHeight: size.height+(kToolbarHeight-kToolbarHeight/2),
             ),
            child: CustomPaint(
              child: Container(
                margin: EdgeInsets.only(
                  top:  kToolbarHeight-kToolbarHeight/2,
                  left: size.width*0.02,
                  right: size.width*0.02,
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
                    height: size.height*.03,
                  ),
                   SizedBox(
                     width: size.width*.9 ,
                     child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                             controller: textEditingController,
                              decoration: InputDecoration(
                                hintText: "Recherche par nom "
                              ),
                              onChanged: (String newString){
                               debouncer.run(() { 
                                 filterUsers(newString);
                               });
                              },
                            ),
                  ),
                   ),
                  Card(
                    color: Colors.white.withOpacity(0.6),
                    child: Container(
                      width:size.width*.9 ,
                      height: size.height*.75,
                      child: StreamBuilder(
                        stream: widget.id==1? fireMethods.getTransporteurs():widget.id==2?fireMethods.getSupers():fireMethods.getMagasins(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                          
                          if (snapshot.hasData&&snapshot.data!=null){

                            if (snapshot.data.docs.isNotEmpty){

                              docsSnapshot = snapshot.data.docs;

                              debouncer.run(() {
                                  filterUsers(textEditingController.text);
                                });
                              
                              return ValueListenableBuilder(
                                  valueListenable:  docsSnapshotNotifier,
                                  builder: (BuildContext context, List<QueryDocumentSnapshot> value, Widget child) {
                                     return  value.length==0 && textEditingController.text.trim().length>0 ?
                                     Center(
                              child: Text("AUCUN UTILISATEUR AVEC CE NOM"),
                            ): SingleChildScrollView(
                              padding: EdgeInsets.all(size.width*0.006),
                                child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.start,
                                alignment: WrapAlignment.start,
                                runAlignment: WrapAlignment.start,
                                direction: Axis.horizontal,
                                spacing:size.width*0.006,
                                children: value.map(
                                  (element)=> size.width>1000 ? SizedBox(
                                    width: size.width*0.441,
                                    child: DashUserIW(user: Us.fromMap(element.data()),)
                                    ) :DashUserIW(user: Us.fromMap(element.data()),)
                                    ).toList()
                                    ),
                            );
                                  },
                               );
                            }
                            return Center(
                              child: Text("AUCUN UTILISATEUR"),
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


/*GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: MediaQuery.of(context).size.width>900 ? 6.5 :7.5,
                                  crossAxisSpacing: 5.0,
                                  crossAxisCount: MediaQuery.of(context).size.width>900 ? 2 : 1
                                ),
                                padding: EdgeInsets.all(10),
                                shrinkWrap: true,                              
                                itemCount: value.length,
                                itemBuilder: (cntx,index){
                                  return DashUserIW(
                                    user: Us.fromMap( value[index].data()),
                                  );
                                }
                              );*/