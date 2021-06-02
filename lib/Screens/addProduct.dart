import 'package:declic_ap/Blocs/Image.dart';
import 'package:declic_ap/Blocs/addProductCubit.dart';
import 'package:declic_ap/Widgets/BonusItemW.dart';
import 'package:declic_ap/Widgets/MycustomB.dart';
import 'package:declic_ap/Widgets/PcustomPaint.dart';
import 'package:declic_ap/Widgets/TopBar.dart';
import 'package:declic_ap/Widgets/myProfileIW.dart';
import 'package:declic_ap/models/bonus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'BonusView.dart';
import '../Widgets/Extension.dart';

class AddProduct extends StatelessWidget {
  const AddProduct({Key key}) : super(key: key);

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
                  create: (cntx) => AddProductCubit()..init(context),
                  child: AddProductForm(),
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

class AddProductForm extends StatelessWidget {
  const AddProductForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final AddProductCubit addProductCubit =
        BlocProvider.of<AddProductCubit>(context, listen: false);

    return Card(
        elevation: 3,
        color: Colors.white.withOpacity(0.6),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.025,
          ),
          child: Column(
            children: [
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
                          addProductCubit.photoUrl = imageCubit.imageUrl;
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
                  key: addProductCubit.globalKey,
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
                        controller: addProductCubit.textEditingControllerName,
                        decoration: InputDecoration(
                            hintText: "Nom", border: OutlineInputBorder()),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (String string) {
                          if (string.isEmpty) {
                            return "Champ doit etre non vide";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        controller: addProductCubit.textEditingControllerQ,
                        decoration: InputDecoration(
                            hintText: "Quantité", border: OutlineInputBorder()),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (String string) {
                          if (string.isEmpty ||
                              string.length < 10 ||
                              string.length > 100) {
                            return "Description doit etre entre 10 et 100";
                          }
                          return null;
                        },
                        maxLines: 2,
                        maxLength: 100,
                        controller: addProductCubit.textEditingControllerdes,
                        decoration: InputDecoration(
                            hintText: "Description",
                            border: OutlineInputBorder()),
                      ),
                    ],
                  )),
              SizedBox(
                height: 10,
              ),
              ValueListenableBuilder(
                valueListenable: addProductCubit.bonus,
                builder: (BuildContext context, Bonus value, Widget child) {
                  return value != null
                      ? BonusItemW(
                          bonus: value,
                        )
                      : MyCustomB(
                          color: Colors.blue,
                          hMargin: 50,
                          onTap: () {
                            showModalBottomSheet(
                                    elevation: 10,
                                    context: context,
                                    builder: (context) => BonusView(
                                          bonus3: false,
                                          bonus2: false,
                                        ),
                                    isScrollControlled: true)
                                .then((value) {
                              if (value != null) {
                                addProductCubit.setBonusto(value);
                              }
                            });
                          },
                          radius: 20,
                          text: "choisir la vente",
                        );
                },
              ),
              SizedBox(
                height: 10,
              ),
              MyCustomB(
                radius: 20,
                onTap: () async {
                  if (addProductCubit.bonus.value != null) {
                    addProductCubit.addProduct();
                  } else {
                    context.showToast(
                        pdHorizontal: 30,
                        pdVertical: 12,
                        textSize: 18,
                        bgColor: Colors.red.withOpacity(0.7),
                        msg: "Bonus est nécessaire !",
                        position: VxToastPosition.top);
                  }
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
        ));
  }
}
