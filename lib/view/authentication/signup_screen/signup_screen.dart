import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iconsax/iconsax.dart';
import 'package:unisport_player_app/controller/signup_controller.dart';
import 'package:unisport_player_app/utils/widgets/custom_loaders.dart';
import 'package:unisport_player_app/view/authentication/login_screen/login_screen.dart';
import 'package:unisport_player_app/view/authentication/select_role_screen/select_role_screen.dart';

import '../../../utils/const/colors.dart';
import '../../../utils/const/decider.dart';
import '../../../utils/const/image_string.dart';
import '../../../utils/const/sizes.dart';
import '../../../utils/const/text_string.dart';
import '../../../utils/widgets/custom_button.dart';
import '../../../utils/widgets/custom_screen_title.dart';
import '../../../utils/widgets/custom_textfield.dart';
import '../login_screen/widget/socialmedia_button.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    return Obx(
      () => CustomLoader(
        isLoading: controller.isLoading.value,
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.defaultSpace),
            child: SingleChildScrollView(
              child: Form(
                key: controller.signUpKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: AppSizes.spaceBtwSection,
                    ),
                    Center(
                      child: Image.asset(
                        ImageString.appLogo1,
                        height: 150,
                      ),
                    ),
                    10.sH,
                    CustomScreenTitle(title: 'Create Account .'),
                    10.sH,
                    Text(
                      'Enter the given detail to create account',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    40.sH,
                    CustomTextField(
                        controller: controller.name,
                        validator: (v) {
                          if (v.isEmpty) {
                            return 'Name is Empty';
                          }
                        },
                        hintText: 'Name',
                        prefixIcon: Iconsax.user_edit,
                        isPrefixIcon: true),
                    CustomTextField(
                      controller: controller.email,
                      validator: (v) {
                        if (v.isEmpty) {
                          return 'Email is Empty';
                        }
                        if (!v.contains('@')) {
                          return 'Email is not Formatted';
                        }
                      },
                      hintText: 'Email',
                      prefixIcon: Iconsax.direct_right,
                      isPrefixIcon: true,
                      textInputType: TextInputType.emailAddress,
                    ),
                    CustomTextField(
                      controller: controller.password,
                      validator: (v) {
                        if (v.isEmpty) {
                          return 'Password is Empty';
                        }
                        if (v.length < 6) {
                          return 'Password is too weak';
                        }
                      },
                      hintText: 'Password',
                      prefixIcon: Iconsax.password_check,
                      isPrefixIcon: true,
                      obsecureText: true,
                      isPasswordField: true,
                    ),
                    30.sH,
                    CustomButton(
                      title: 'Next',
                      onPressed: () {
                        if (controller.signUpKey.currentState!.validate()) {
                          controller.signUp();
                        }
                      },
                    ),
                    20.sH,
                    Center(
                      child: Text.rich(TextSpan(children: [
                        TextSpan(text: 'If you are olden ,\t', style: Theme.of(context).textTheme.bodyMedium),
                        TextSpan(
                            text: 'Login',
                            recognizer: TapGestureRecognizer()..onTap = () => Get.offAll(() => LoginScreen()),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontWeight: FontWeight.bold, color: AppColors.kPrimary)),
                      ])),
                    ),
                    20.sH,
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        8.sW,
                        const Text(
                          'OR',
                        ),
                        8.sW,
                        const Expanded(child: Divider()),
                      ],
                    ),
                    20.sH,
                     SocialMediaButton(
                      googleTapped: (){
                        _handleSignIn();
                      },
                       facebookTapped: (){},
                    ),
                    40.sH,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> _handleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential authResult = await _auth.signInWithCredential(credential);
        final User? user = authResult.user;
        await _storeUserData(user);
        Get.to(
          () => SelectRoleScreen(),
        );
      }
    } catch (error) {
      print("Error signing in with Google: $error");
    }
  }

  Future<void> _storeUserData(User? user) async {
    if (user != null) {
      try {
        final Map<String, dynamic> userData = {
          'uid': user.uid,
          'name': user.displayName,
          'email': user.email,
          'password': '',
          'image': '',
          'isPlayer': Decider.groupValue == TextString.playerAccount ? true : false,
          'isBlocked': false,
          'isApproved': false,
          'departmentName': '',
          'regNo': '',
          'playerDescription': '',
        };

        await usersCollection.doc(user.uid).set(userData);
      } catch (error) {
        print("Error storing user record: $error");
        // Handle error
      }
    }
  }
}
