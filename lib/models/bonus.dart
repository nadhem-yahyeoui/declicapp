class Bonus {

   String name;
   String imageUrl;
   String id;
   //int quantityl;
  int quantity;
  
  Bonus({this.name, this.imageUrl, this.id,this.quantity});


  Map<String,dynamic> toMap(Bonus bonus){

    Map<String,dynamic> map =  Map<String,dynamic>();

    map["name"]=bonus.name;
    map["id"]=bonus.id;
    map["image"]=bonus.imageUrl;
   // map["quantityl"]=bonus.quantityl;
  
  return map;

  }

Bonus.fromMap(Map<String,dynamic> map){

//this.quantityl=map["quantityl"];
this.imageUrl=map["image"];
this.name=map["name"];
this.id=map["id"];

}



}