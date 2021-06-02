import 'package:flutter/material.dart';

class MyCustomB extends StatelessWidget {

  final Function onTap;
  final double hMargin;
  final String text;
  final Color color;
  final double radius;
  
  const MyCustomB({Key key, this.onTap, this.hMargin, this.text, this.color, this.radius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius)
      ),
      margin: EdgeInsets.symmetric(horizontal: hMargin),
      padding: EdgeInsets.symmetric(vertical: 12),
      width: double.infinity,
      child: InkWell(
        onTap: onTap,
        child: Center(child: Text(text,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20,letterSpacing: 0.8),textAlign: TextAlign.center,),),
    ),
    );
  }
}