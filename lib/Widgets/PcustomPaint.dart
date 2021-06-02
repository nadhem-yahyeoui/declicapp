import 'package:flutter/material.dart';

class MyPCPainter extends CustomPainter {


  MyPCPainter(this.color);

final Color color;

  @override
  void paint(Canvas canvas, Size size) {

  Paint paint_0 = new Paint()
      ..color = color
      ..style = PaintingStyle.fill;
     
    Path path_0 = Path();
    path_0.moveTo(size.width*0.4,size.height);
    path_0.quadraticBezierTo(size.width*0.4,size.height*0.26,size.width,size.height*0.15);
    path_0.quadraticBezierTo(size.width,size.height*0.35,size.width,size.height);
    path_0.lineTo(size.width*0.4,size.height);
    path_0.close();

    canvas.drawPath(path_0, paint_0);
  
    
  }

  @override
  bool shouldRepaint(MyPCPainter oldDelegate) => false;

}