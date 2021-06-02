import 'package:declic_ap/Blocs/Image.dart';
import 'package:declic_ap/Blocs/addBonusCubit.dart';
import 'package:declic_ap/Widgets/MycustomB.dart';
import 'package:declic_ap/Widgets/PcustomPaint.dart';
import 'package:declic_ap/Widgets/TopBar.dart';
import 'package:declic_ap/Widgets/myProfileIW.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddBonus extends StatelessWidget {
  const AddBonus({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xffFFFFFF),
      body: SingleChildScrollView(
          child: Container(
        constraints: BoxConstraints(minHeight: size.height),
        child: CustomPaint(
          child: Container(
            margin: EdgeInsets.only(
              top: kToolbarHeight - kToolbarHeight / 2,
              left: size.width * 0.025,
              right: size.width * 0.025,
            ),
            child: Column(
              children: [
                TopBar(
                  leading: IconButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.arrow_back_outlined)),
                  lWidget: Image.asset(
                    "assets/logo@1X.png",
                    width: size.height * 0.1,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                BlocProvider(
                  create: (cntx) => AddBonusCubit()..init(context),
                  child: AddBonusForm(),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
          size: Size.infinite,
          painter: MyPCPainter(Color(0xffFF56C7)),
        ),
      )),
    );
  }
}

class AddBonusForm extends StatelessWidget {
  const AddBonusForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final AddBonusCubit addBonusCubit =
        BlocProvider.of<AddBonusCubit>(context, listen: false);

    return Card(
        elevation: 3,
        color: Colors.white.withOpacity(0.6),
        child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.025,
            ),
            child: Column(children: [
              SizedBox(
                height: 10,
              ),
              BlocProvider(
                create: (cntx) => ImageCubit(ImageState.NOImage),
                child: BlocBuilder<ImageCubit, ImageState>(
                  builder: (context, state) {
                    final ImageCubit imageCubit = context.read<ImageCubit>();

                    if (state == ImageState.NOImage) {
                      return MyPIW(
                        isFile: false,
                        isLoading: false,
                        imageUrl: null,
                        onNoTap: () async => imageCubit.getImage(),
                        isProductImage: true,
                      );
                    } else if (state == ImageState.FileImage) {
                      return MyPIW(
                        isLoading: false,
                        imageUrl: imageCubit.pickedFile.path,
                        onFileImageTaped: () async {
                          await imageCubit.onUploadTapedAddP();
                          addBonusCubit.photoUrl = imageCubit.imageUrl;
                        },
                        isFile: true,
                        isProductImage: true,
                      );
                    } else if (state == ImageState.LOADING) {
                      return MyPIW(
                        isFile: false,
                        isLoading: true,
                        imageUrl: null,
                        isProductImage: true,
                      );
                    }
                    return MyPIW(
                      isFile: false,
                      isLoading: false,
                      imageUrl: imageCubit.imageUrl,
                      isProductImage: true,
                    );
                  },
                ),
              ),
              Form(
                key: addBonusCubit.globalKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (String string) {
                        if (string.isEmpty ||
                            string.length > 30 ||
                            string.length < 3) {
                          return "Longeur de nom doit etre entre 3 et 30";
                        }
                        return null;
                      },
                      controller: addBonusCubit.textEditingControllerName,
                      decoration: InputDecoration(
                          hintText: "Nom", border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    MyCustomB(
                      radius: 20,
                      onTap: () async {
                        addBonusCubit.addBonus();
                      },
                      color: Colors.blue,
                      hMargin: 10,
                      text: "Ajouter",
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              )
            ])));
  }
}
