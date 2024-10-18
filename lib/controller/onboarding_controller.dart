import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../view/authentication/login_screen/login_screen.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentIndex = 0.obs;

  void updatePageIndex(index) {
    currentIndex.value = index;
  }

  void dotNavigationClick(index) {
    currentIndex.value = index;
    pageController.jumpTo(index);
  }

  // void nextPage() {
  //   if (currentIndex.value == 2) {
  //     // final storage=GetStorage();
  //     // storage.write('isFirstTime', false);
  //     Get.offAll(
  //        LoginScreen(),
  //       transition: Transition.downToUp,
  //     );
  //   } else {
  //     pageController.nextPage(
  //       duration: const Duration(milliseconds: 600),
  //       curve: Curves.easeIn,
  //     );
  //   }
  // }

  void nextPage() {
    if (currentIndex.value == 2) {
      final storage=GetStorage();
      storage.write('isFirstTime', false);
      Get.offAll(
         LoginScreen(),
        transition: Transition.downToUp,
      );
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    }
  }
  void skipPage() {
    currentIndex.value = 2;
    pageController.jumpToPage(2);
  }
}
