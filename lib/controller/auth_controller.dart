import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:unisport_player_app/view/home/navigation_view/navigation_screen.dart';

import '../view/authentication/login_screen/login_screen.dart';
import '../view/authentication/onboarding_screen/onboarding_screen.dart';

class AuthController extends GetxController {
  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;
  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  screenRedirect() async {
    User? user = _auth.currentUser;
    if (user != null) {
      Get.offAll(() => const NavigationView());
    } else {
      deviceStorage.writeIfNull('isFirstTime', true);
      deviceStorage.read('isFirstTime') == true
          ? Get.to(() => OnboardingScreen())
          : Get.offAll(
              () => LoginScreen(),
            );
    }
    // Local Storage
  }
}
