import 'package:flutter/material.dart';
import '../models/bonus.dart';

class BonusItemW extends StatelessWidget {

const BonusItemW({Key key, this.bonus, this.onTap,}) : super(key: key);

final Bonus bonus;
final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
          onTap: onTap,
            child: Container(
        decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10)
        ),
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            ProduitImage(
              imageUrl: bonus.imageUrl,
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
                    child: Text(bonus.name,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w900),),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
              padding: EdgeInsets.only(right: 10),
              child: Text(bonus.quantity==null?"":"X${bonus.quantity}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w900,color: Colors.red),),
            )
              ],
                ),
              ),
            ),
          ],
        ),
      ),
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