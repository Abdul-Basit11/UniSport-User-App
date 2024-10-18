import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unisport_player_app/utils/const/back_end_config.dart';
import 'package:path/path.dart';
import '../utils/const/loaders.dart';

class ProfileController extends GetxController {
  final auth = FirebaseAuth.instance;

  var name = TextEditingController();
  var playerDescription = TextEditingController();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getUserDetail();
  }

  var userName = ''.obs;
  var playerDes = ''.obs;
  var isPlayer = false.obs;

  getUserDetail() {
    BackEndConfig.userCollection.doc(auth.currentUser!.uid).snapshots().listen((DocumentSnapshot snapShot) {
      update();
      userName.value = snapShot.get('name');
      playerDes.value = snapShot.get('playerDescription');
      isPlayer.value = snapShot.get('isPlayer');
    });
  }

  var imagePath = ''.obs;

  var imageLink = ''.obs;

  /// function
  pickImage({context, required ImageSource imageSource}) async {
    try {
      final Pickedimage = await ImagePicker().pickImage(source: imageSource, imageQuality: 70);
      if (Pickedimage == null) return;
      imagePath.value = Pickedimage.path;
    } on PlatformException catch (e) {
      BLoaders.errorSnackBar(title: 'Error', messagse: e.toString());
    }
  }

  uploadProfileImage() async {
    var fileName = basename(imagePath.value);
    var destination = 'users/${auth.currentUser!.uid}/$fileName)';

    Reference ref = FirebaseStorage.instance.ref().child(destination);
    await ref.putFile(File(imagePath.value));
    imageLink.value = await ref.getDownloadURL();
  }

  updateProfile({name, playerDescription, imgUrl}) {
    isLoading(true);
    BackEndConfig.userCollection.doc(auth.currentUser!.uid).set(
      {
        'name': name,
        'playerDescription': playerDescription,
        'image': imgUrl,
      },
      SetOptions(merge: true),
    ).then((value) {
      isLoading(false);
      Get.back();
      BLoaders.successSnackBar(title: 'Success', messagse: 'Profile Updated');
    });
  }
}
