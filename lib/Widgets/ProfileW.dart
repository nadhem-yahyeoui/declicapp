import 'package:flutter/material.dart';

class ProfileW extends StatelessWidget {
  
  final String imageUrl;
  final double radius;
  
  const ProfileW({Key key, this.imageUrl, this.radius}) : super(key: key);
  
final String noImageProfile = "https://www.pikpng.com/pngl/m/80-805068_my-profile-icon-blank-profile-picture-circle-clipart.png";
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
            
            radius: radius!=null?radius:25,
            backgroundImage: Image.network(imageUrl!=null ? imageUrl:noImageProfile,fit: BoxFit.fill).image,
          );
        
  }

}