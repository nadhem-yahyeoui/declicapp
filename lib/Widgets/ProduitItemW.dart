import 'package:declic_ap/models/produit.dart';
import 'package:flutter/material.dart';

class ProduitItemW extends StatelessWidget {

  const ProduitItemW({Key key, this.produit, this.onBonusTaped,this.onWidgetTap, this.canEdit=false, this.onEditTap,@required this.ondeleteTaped}) : super(key: key);

final Produit produit;
final Function onBonusTaped;
final Function onWidgetTap;
final bool canEdit;
final Function onEditTap;
final Function ondeleteTaped;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
      decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10)
      ),
      padding: EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProduitImage(
            imageUrl: produit.imageUrl,
            radius: 35,
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                  child: Text(produit.name,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w900),),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Description :  \n${produit.des}",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      ),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(5.0)
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: Text("Qnt : ${produit.quantity.toString()}",style: TextStyle(fontWeight: FontWeight.w500)),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
                 child: Container(
                 child: Transform.scale(scale: 1.2,child: Image.asset("assets/bonus.png",width: 50,height: 50,),),
               ),
               onTap: onBonusTaped,
               ),
         canEdit? Column(
           children: [
             IconButton(onPressed:onEditTap, icon: Icon(Icons.edit_outlined,color: Colors.green,)),
             IconButton(onPressed:ondeleteTaped, icon: Icon(Icons.delete_outline_outlined,color: Colors.red,)),
           ],
         ):SizedBox()
        ],
      ),
    ),
    onTap: onWidgetTap,
    );
  }
}


const String cachedImageUrl="https://socialistmodernism.com/wp-content/uploads/2017/07/placeholder-image.png";

class ProduitImage extends StatelessWidget {

  const ProduitImage({Key key, this.imageUrl, this.radius=30}) : super(key: key);
  final String imageUrl;
  final double radius;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
            radius: radius,
            backgroundImage: imageUrl!=null?
            Image.network(imageUrl).image:
            Image.network(cachedImageUrl).image,
          );
  }
}