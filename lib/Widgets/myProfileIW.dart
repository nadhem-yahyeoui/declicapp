import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyPIW extends StatelessWidget {

  const MyPIW({Key key, this.imageUrl, this.isProductImage, this.onNoTap, this.isFile, this.onFileImageTaped, this.isLoading}) : super(key: key);

  final String imageUrl; 
  final bool isProductImage;
  final Function onNoTap;
  final bool isFile;
  final Function onFileImageTaped;
  final bool isLoading;
  
  @override
  Widget build(BuildContext context) {

    final double _myHeight = MediaQuery.of(context).size.height;
    return Container(
          width:_myHeight*.18,
          height: _myHeight*.18,
          child: GestureDetector(
            child: Container(
            decoration: BoxDecoration(
              color: onNoTap !=null ?Colors.grey.withOpacity(0.7):null,
              borderRadius: isProductImage? null: BorderRadius.circular(25),
              shape: isProductImage ? BoxShape.circle : BoxShape.rectangle,
            ),
            child: isLoading ?
            Center(child: CupertinoActivityIndicator(radius: 10,),): 
            isFile ? 
            Icon(Icons.upload_outlined): onNoTap!=null ?
            Icon(Icons.add):null,
          ),
          onTap:isLoading? null:isFile ? onFileImageTaped :onNoTap,
          ),
          decoration: isLoading ? null:BoxDecoration(
            image: imageUrl!=null? DecorationImage(
              image: isFile ? 
              Image.network(imageUrl).image:
              Image.network(imageUrl,).image,
              fit: BoxFit.fill
              ):null,
            border: Border.all(color: Colors.black),
            shape: isProductImage ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: isProductImage ? null : BorderRadius.circular(25)
          ),
    );
  }
}