import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  
  final Widget leading;
  final Widget centerW;
  final Widget lWidget;
  
  const TopBar({Key key, this.leading, this.centerW, this.lWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        leading ?? SizedBox(),
        centerW ?? SizedBox(),
        lWidget ?? SizedBox()
      ],
    );
  }
}