import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:unisport_player_app/view/home/navigation_view/navigation_screen.dart';

import '../utils/const/loaders.dart';
import '../utils/exceptions/firebaseauth_exception.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  final localStorage = GetStorage();
  final _auth = FirebaseAuth.instance;
  final loginKey = GlobalKey<FormState>();

  // text controller
  final email = TextEditingController();
  final password = TextEditingController();

  // functions
  Future<void> login() async {
    try {
      isLoading(true);

      await _auth.signInWithEmailAndPassword(email: email.text, password: password.text).then((value) {
        isLoading(false);
        Get.offAll(
          () => NavigationView(),
        );

        BLoaders.successSnackBar(title: 'Login Successfully', messagse: value.user!.email.toString());
      }).onError((error, stackTrace) {
        isLoading(false);
        BLoaders.errorSnackBar(title: 'Error', messagse: error.toString());
      });
    } on FirebaseAuthException catch (e) {
      throw BFirebaseAuthException(e.code).message;
    }
  }

  Future<void> sendEmailResetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.back();
    } on FirebaseAuthException catch (e) {
      BLoaders.errorSnackBar(title: e.message.toString());
    } on FirebaseException catch (e) {
      BLoaders.errorSnackBar(title: e.message.toString());
    } catch (e) {
      BLoaders.errorSnackBar(title: e.toString());
    }
  }
}
