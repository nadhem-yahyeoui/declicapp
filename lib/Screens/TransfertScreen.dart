import 'package:declic_ap/Utils/Utils.dart';
import 'package:declic_ap/Widgets/MycustomB.dart';
import 'package:declic_ap/Widgets/PcustomPaint.dart';
import 'package:declic_ap/Widgets/TopBar.dart';
import 'package:declic_ap/models/TransfertHistory.dart';
import 'package:declic_ap/resources/firebase_methods.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:html' show AnchorElement;
import 'package:excel/excel.dart';
import 'dart:convert';

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





class TransfertScreen extends StatelessWidget {
  
  
  TransfertScreen({Key key,}) : super(key: key);


final FireMethods fireMethods = FireMethods();

final TextEditingController textEditingController = TextEditingController();
final Debouncer debouncer = Debouncer(500);
final ValueNotifier<List<TransfertHistory>> filterTransfertHistoryNotifier=ValueNotifier<List<TransfertHistory>>(null);

List<TransfertHistory> listTransfertHistory;


void createExcel(BuildContext context)async{


final Excel excel = Excel.createExcel();
  

  CellStyle cellStyle = CellStyle(
    horizontalAlign: HorizontalAlign.Center,
    backgroundColorHex: "#1AFF1A", 
    fontFamily : getFontFamily(FontFamily.Calibri)
    );

  
 Sheet sheetObject = excel['Sheet1'];
      
      List<String> rows = [
        "SENDEUR",
        "S.FONCTION", 
        "S.CIN",
        "RECEIVEUR",
        "R.FONCTION",
        "R.CIN",
        "BONUS",
        "VENTE",
        "DATE"
      ];
      int i=0;
      rows.forEach((element) {
      var  cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: i,rowIndex: 0));
      cell.value=element;
      cell.cellStyle = cellStyle;
      i++;
      });
      

    listTransfertHistory.forEach((element) {
      if (element.receiverD.contains(":")){
        excel.appendRow("Sheet1", [
          element.senderD.split(":")[0], 
          element.senderD.split(":")[1], 
          element.senderD.split(":")[2], 
          element.receiverD.split(":")[0],
          element.receiverD.split(":")[1],
          element.receiverD.split(":")[2],
          element.produitdes,
          "",
          Utils.getCustomDate2FromTimeS(element.timestamp),
          ]);
      }else{
        excel.appendRow("Sheet1", [
          element.senderD.split(":")[0], 
          element.senderD.split(":")[1], 
          element.senderD.split(":")[2], 
          element.receiverD,
          "",
          "",
          "${element.produitQ} ${element.produitName}",
          "${element.bonus1Q>0 ?element.bonus1Q :""} ${element.bonus1Q>0 ?element.bonus1Name :""}\n${element.bonus2Q>0 ?element.bonus2Q :""} ${element.bonus2Q>0 ?element.bonus2Name :""}\n${element.bonus3Q>0 ?element.bonus3Q :""} ${element.bonus3Q>0 ?element.bonus3Name :""}"
          ,Utils.getCustomDate2FromTimeS(element.timestamp)
          ]);
      }
    });

      
        final content = base64Encode(excel.encode());
        AnchorElement(
      href: "data:application/octet-stream;charset=utf-16le;base64,$content")
    ..setAttribute("download", "${Timestamp.now().toString()}.xlsx")
    ..click();

}



void filterTransfertHistory(String query){

  filterTransfertHistoryNotifier.value = listTransfertHistory.where((element){

    return element.senderD.toLowerCase().contains(query.toLowerCase())
    || element.receiverD.toLowerCase().contains(query.toLowerCase());
  
  }).toList();

}

  @override
  Widget build(BuildContext context) {

     final Size size = MediaQuery.of(context).size;

    print("TRANSFERT SCREEN BUILDED");

    return Scaffold(
      
      resizeToAvoidBottomInset: false,
      
      backgroundColor: Color(0xffFFFFFF),
      
      body: Container(
            constraints: BoxConstraints(
              minHeight: size.height,
              maxHeight: size.height,
            ),
        child: CustomPaint(
        willChange: false,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width*.01,vertical: size.height*0.05),
              child: Column(
          children:[
            Container(
              child: TopBar(
                leading: IconButton(
                  onPressed: ()async{
                     Navigator.of(context).pop();
                    }, 
                  icon: Icon(Icons.arrow_back_outlined)
                  ),
                lWidget: Image.asset("assets/logo@1X.png",width: size.height*0.1,),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: textEditingController,
                decoration: InputDecoration(
                  hintText: "Recherche par nom ou cin"
                ),
                onChanged: (String newString){

                 debouncer.run(() { 
                   filterTransfertHistory(newString);
                 });
                },
              ),
            ),
           StreamBuilder(
             stream: fireMethods.getHistory(),
             builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
               if (snapshot.hasData&&snapshot.data!=null){
                 if (snapshot.data.docs.length==0){
                   return Center(
                     child: Text("AUCUNE TRANSFERT HISTORIQUE ENCORE"),
                   );
                 }
                 listTransfertHistory = List.generate(
                   snapshot.data.docs.length
                   , (index) => snapshot.data.docs[index].get("receiverD").toString().contains(":")
                   ? TransfertHistory.fromMap(snapshot.data.docs[index].data())
                   :TransfertHistory.fromBuymap(snapshot.data.docs[index].data())
                   );

                    debouncer.run(() { 
                   filterTransfertHistory(textEditingController.text);
                 });


                 return  ValueListenableBuilder(
                     valueListenable:  filterTransfertHistoryNotifier,
                     builder: (BuildContext context, List<TransfertHistory> value, Widget child) {
                        return  value !=null ?SingleChildScrollView(
              scrollDirection: Axis.horizontal,
                  child: DataTable(
                columns: [
                  DataColumn(label: Text("SENDEUR",style: TextStyle(color: Colors.red),)),
                  DataColumn(label: Text("S.FONCTION",style: TextStyle(color: Colors.red),)),
                  DataColumn(label: Text("S.CIN",style: TextStyle(color: Colors.red),)),
                  DataColumn(label: Text("RECEIVEUR",style: TextStyle(color: Colors.red),)),
                  DataColumn(label: Text("R.FONCTION",style: TextStyle(color: Colors.red),)),
                  DataColumn(label: Text("R.CIN",style: TextStyle(color: Colors.red),)),
                  DataColumn(label: Text("BONUS",style: TextStyle(color: Colors.red),)),
                  DataColumn(label: Text("VENTE",style: TextStyle(color: Colors.red),)),
                  DataColumn(label: Text("DATE",style: TextStyle(color: Colors.red),)),
                ], 
                rows: List.generate(value.length, (index){
                                    
                  return value[index].receiverD.contains(":") ?DataRow(
                  cells: [
                    DataCell(
                    Text(value[index].senderD.split(":")[0])
                  ),DataCell(
                    Text(value[index].senderD.split(":")[1])
                  ),DataCell(
                    Text(value[index].senderD.split(":")[2])
                  ),DataCell(
                    Text(value[index].receiverD.split(":")[0])
                  ),DataCell(
                    Text(value[index].receiverD.split(":")[1])
                  ),DataCell(
                    Text(value[index].receiverD.split(":")[2])
                  ),DataCell(
                    Text(value[index].produitdes)
                  ),DataCell(
                    Text("")
                  ),DataCell(
                    Text(Utils.getCustomDate2FromTimeS(value[index].timestamp))
                  ),
                  ]
                  ):DataRow(
                  cells: [
                    DataCell(
                    Text(value[index].senderD.split(":")[0])
                  ),DataCell(
                    Text(value[index].senderD.split(":")[1])
                  ),DataCell(
                    Text(value[index].senderD.split(":")[2])
                  ),DataCell(
                    Text(value[index].receiverD)
                  ),DataCell(
                    Text("")
                  ),DataCell(
                    Text("")
                  ),DataCell(
                    Text(
                      "${value[index].produitQ} ${value[index].produitName}"
                      ),
                  ),DataCell(
                    Text(
                      "${value[index].bonus1Q >0 ?value[index].bonus1Q :""} ${value[index].bonus1Q>0 ?value[index].bonus1Name :""}\n${value[index].bonus2Q >0 ?value[index].bonus2Q :""} ${value[index].bonus2Q>0 ?value[index].bonus2Name :""}\n${value[index].bonus3Q >0 ?value[index].bonus3Q :""} ${value[index].bonus3Q>0 ?value[index].bonus3Name :""}"
                    )
                  ),
                  DataCell(
                    Text(Utils.getCustomDate2FromTimeS(value[index].timestamp))
                  ),
                  ]
                  );
                })
                ),
            ):Center(
              child:CircularProgressIndicator(),
            );
                  },
                  );
               }
               return Center(
                 child: CircularProgressIndicator(),
               );
             },
           ),
           SizedBox(
             height: 20,
           ),
           MyCustomB(
             color: Colors.green.withOpacity(0.8),
             text: "enregistrer comme excel",
             radius: 25,
             onTap: ()async=>createExcel(context),
             hMargin: 20,
           )
          ]
              )
              ),
          ),
          size: Size.infinite,
          painter: MyPCPainter(Color(0xff9FD1A2)),
            ),
            )
            );
  }
}