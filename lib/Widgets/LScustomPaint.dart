import 'package:flutter/material.dart';
class LoginSPainter extends CustomPainter {

  LoginSPainter({this.gcolors});
  final List<Color> gcolors; // Gradient Colors

  @override
  void paint(Canvas canvas, Size size) {
    
  Paint paint = new Paint()
      ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [
            0.0,
            0.45,
          ],
          colors: gcolors,
      ).createShader(Rect.fromLTRB(0,0,size.width,size.height))
      ..style = PaintingStyle.fill;
     
    Path path = Path();

    path.moveTo(0,size.height*0.18);
    path.lineTo(0,size.height);
    path.lineTo(size.width,size.height);
    path.lineTo(size.width, size.height*0.18);
    path.quadraticBezierTo(size.width/2,-size.height*0.15,0,size.height*0.18);
    path.close();
    canvas.drawPath(path, paint);

  }

  @override
  bool shouldRepaint(LoginSPainter oldDelegate) => false;


}

