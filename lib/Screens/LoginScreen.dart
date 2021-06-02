import 'package:declic_ap/Blocs/SignInCubit.dart';
import 'package:declic_ap/Widgets/LScustomPaint.dart';
import 'package:declic_ap/Widgets/MycustomB.dart';
import 'package:declic_ap/Widgets/SlideLeftRoute.dart';
import 'package:declic_ap/enum/UserR.dart';
import 'package:declic_ap/models/FetchedUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'AdminDash.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void pushToScreenAfterLogin(FetchedUser fetchedUser) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (fetchedUser.userR == UserR.ADMIN) {
        Navigator.of(context).pushAndRemoveUntil(
            SlideLeftRoute(
                page: DashBoard(
              afterL: true,
            )),
            (route) => false);
      } else return;
    });
  }

  @override
  Widget build(BuildContext context) {

    final double topbarHeight =
        MediaQuery.of(context).viewPadding.top; // GET THE TOP BAR HEIGHT
    final double _myHeight = MediaQuery.of(context).size.height -
        topbarHeight; // GET THE FINAL HEIGHT
    final double _myWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(0xffFFFFFF),
        body: Container(
          height: _myHeight,
          margin: EdgeInsets.only(top: topbarHeight),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Container(
                    height: _myHeight * 0.4,
                    child: Image.asset(
                      "assets/logo@1X.png",
                      height: _myHeight * 0.4,
                    ),
                  ),
                ),
                Container(
                    width: double.infinity,
                    height: _myHeight * 0.6,
                    child: CustomPaint(
                      child: Container(
                          margin: EdgeInsets.only(
                              top: _myHeight * 0.18,
                              left: _myWidth > 800 ? _myWidth * 0.3:_myWidth*0.1,
                              right: _myWidth > 800 ? _myWidth * 0.3:_myWidth*0.1,
                              ),
                          child: bloc.BlocProvider(
                            create: (cntx) => SignInCubit()..init(cntx),
                            child: bloc.BlocListener<SignInCubit, FetchedUser>(
                              listener: (cntx, state) {
                                if (state != null) {
                                  pushToScreenAfterLogin(state);
                                }
                              },
                              child: LoginLayout(),
                            ),
                          )),
                      size: Size.infinite,
                      painter: LoginSPainter(
                          gcolors: [Color(0xff0273B5), Color(0xff1C3760)]),
                )),
              ],
            ),
          ),
        ));
  }
}

class LoginLayout extends StatelessWidget {
  const LoginLayout({Key key}) : super(key: key);

  bool isnotNumeric(String s) {
    
    try {
      int.parse(s);
      return false;
    } catch (e) {
      return true;
    }

  }

  String isvalideCin(String string) {

    if (string.length != 8 || isnotNumeric(string))
      return "cin doit contenir 8 chiffres";
    return null;
  
  }

  String isvalidepass(String string) {
    if (string.length < 8) return "la longueur du mot de passe doit etre d'au moins 8";
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<SignInCubit>().formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextFormField(
            validator: (string) => isvalideCin(string),
            controller: context.read<SignInCubit>().cinTextController,
            cursorColor: Colors.blue,
            style: TextStyle(color: Colors.black),
            maxLength: 8,
            decoration: InputDecoration(
              counterText: "",
              prefixIcon: Icon(Icons.person),
              filled: true,
              fillColor: Color(0xffFFFFFF),
              hintText: "CIN",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          TextFormField(
            validator: (string) => isvalidepass(string),
            controller: context.read<SignInCubit>().passTextController,
            cursorColor: Colors.blue,
            style: TextStyle(color: Colors.black),
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock),
              filled: true,
              fillColor: Color(0xffFFFFFF),
              hintText: "PASSWORD",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: ()async=>context.read<SignInCubit>().handlePassOublier(),
              child: Text(
              "Mot de passe oublié?",
              style: TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          MyCustomB(
            radius: 20,
            onTap: () async => context.read<SignInCubit>().signIn(),
            color: Colors.blue,
            hMargin: 5,
            text: "Connecter",
          )
        ],
      ),
    );
  }
}
