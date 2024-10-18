import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../utils/const/back_end_config.dart';
import '../utils/const/decider.dart';
import '../utils/const/loaders.dart';
import '../utils/const/text_string.dart';
import '../utils/exceptions/firebaseauth_exception.dart';
import '../view/authentication/select_role_screen/select_role_screen.dart';
import '../view/home/navigation_view/navigation_screen.dart';

class SignUpController extends GetxController {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  var isLoading = false.obs;
  final signUpKey = GlobalKey<FormState>();

  // text controllers
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  // signUp Function
  Future<void> signUp() async {
    try {
      isLoading(true);
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text, password: password.text);

      await BackEndConfig.userCollection.doc(auth.currentUser!.uid).set({
        'uid': auth.currentUser!.uid,
        'name': name.text,
        'email': email.text,
        'password': password.text,
        'image': '',
        'isPlayer': Decider.groupValue == TextString.playerAccount ? true : false,
        'isBlocked': false,
        'isApproved': false,
        'departmentName': '',
        'regNo': '',
        'playerDescription': '',
      });

      isLoading(false);
      BLoaders.successSnackBar(title: 'Account Created', messagse: 'Your Account Creation is One Step Ahead');
      Get.to(() => SelectRoleScreen());
    } on FirebaseAuthException catch (e) {
      isLoading(false);
      BLoaders.errorSnackBar(title: 'Error', messagse: e.code.toString());
    } catch (e) {
      isLoading(false);
      BLoaders.errorSnackBar(title: 'Error', messagse: 'An unexpected error occurred');
    }
  }
}

class SelectRoleController extends GetxController {
  var isLoading = false.obs;
  final departmentName = TextEditingController();
  final regNo = TextEditingController();
  final playerDescription = TextEditingController();

  confirmSelectRoleAndCreate() {
    isLoading(true);
    BackEndConfig.userCollection.doc(FirebaseAuth.instance.currentUser!.uid).set({
      'isPlayer': Decider.groupValue == TextString.playerAccount ? true : false,
      'departmentName': departmentName.text.toString(),
      'regNo': regNo.text.toString(),
      'playerDescription': playerDescription.text.toString(),
    }, SetOptions(merge: true)).then((value) {
      isLoading(false);
      BLoaders.successSnackBar(title: 'Congratulation 🎉', messagse: 'Your Account Has Been Created.');
      Get.to(() => const NavigationView());
    });
  }
}
