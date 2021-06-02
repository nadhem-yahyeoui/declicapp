import 'package:declic_ap/resources/firebase_methods.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

enum ImageState{
  NOImage,FileImage,OnlineImage,LOADING
}

class ImageCubit extends Cubit<ImageState>{
  
  ImageCubit(ImageState initialState) : super(initialState);

  String imageUrl;
  PickedFile pickedFile;

  final FireMethods fireMethods = FireMethods();

  final picker = ImagePicker();

  Future getImage() async {

     pickedFile = await picker.getImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        emit(ImageState.FileImage);
      } else {
        print('No image selected.');
      }

  }
  Future onUploadTapedAddP()async{
    
    emit(ImageState.LOADING);
    imageUrl = await uploadImageToDB();
    if (imageUrl!=null){
      emit(ImageState.OnlineImage);
    }else{
      emit(ImageState.NOImage);
    }
  }
  
  Future onUploadTapedPS(String uid)async{
    emit(ImageState.LOADING);
    imageUrl = await uploadImageToDB();
    if (imageUrl!=null){
      fireMethods.addImageProfile(uid, imageUrl).then((value) => value?emit(ImageState.OnlineImage):"");
    }else{
      emit(ImageState.NOImage);
    }
  }

Future<String> uploadImageToDB() async {

    if (pickedFile == null) {
      return null;
    }

    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('Images')
        .child(pickedFile.path+pickedFile.path.hashCode.toString());
     return await ref.putData(await pickedFile.readAsBytes()).then((tasksnAP)async{
       return await tasksnAP.ref.getDownloadURL();
     }
     ).onError((error, stackTrace) => null);
}

}