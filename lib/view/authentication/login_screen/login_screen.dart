import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iconsax/iconsax.dart';
import 'package:unisport_player_app/controller/login_controller.dart';
import 'package:unisport_player_app/utils/const/colors.dart';
import 'package:unisport_player_app/utils/const/image_string.dart';
import 'package:unisport_player_app/utils/const/sizes.dart';
import 'package:unisport_player_app/utils/helper/helper_function.dart';
import 'package:unisport_player_app/utils/widgets/custom_button.dart';
import 'package:unisport_player_app/utils/widgets/custom_loaders.dart';
import 'package:unisport_player_app/utils/widgets/custom_textfield.dart';
import 'package:unisport_player_app/view/authentication/forgot_password/forgot_password_screen.dart';
import 'package:unisport_player_app/view/authentication/signup_screen/signup_screen.dart';
import 'package:unisport_player_app/view/home/navigation_view/navigation_screen.dart';

import '../../../utils/const/decider.dart';
import '../../../utils/const/text_string.dart';
import '../../../utils/widgets/custom_screen_title.dart';
import '../select_role_screen/select_role_screen.dart';
import 'widget/socialmedia_button.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Obx(
      () => CustomLoader(
        isLoading: controller.isLoading.value,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.defaultSpace),
              child: Form(
                key: controller.loginKey,
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
                    CustomScreenTitle(
                      title: 'Login to your Account .',
                    ),
                    10.sH,
                    Text(
                      'Welcome Back !',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    40.sH,
                    CustomTextField(
                      validator: (va) {
                        if (va.isEmpty) {
                          return 'Email is required';
                        }
                        if (!va.contains('@')) {
                          return 'Email is not in format';
                        }
                      },
                      controller: controller.email,
                      hintText: 'Email',
                      prefixIcon: Iconsax.direct_right,
                      isPrefixIcon: true,
                      textInputType: TextInputType.emailAddress,
                    ),
                    CustomTextField(
                        validator: (va) {
                          if (va.isEmpty) {
                            return 'Password is empty';
                          }
                          if (va.length < 6) {
                            return 'Strong Password Is required';
                          }
                        },
                        controller: controller.password,
                        obsecureText: true,
                        hintText: 'Password',
                        prefixIcon: Iconsax.password_check,
                        isPrefixIcon: true,
                        isPasswordField: true),
                    30.sH,
                    CustomButton(
                        title: 'SignIn',
                        onPressed: () {
                          if (controller.loginKey.currentState!.validate()) {
                            controller.login();

                            //Navigator.push(context, MaterialPageRoute(builder: (context) => const NavigationView()));
                          }
                        }),
                    10.sH,
                    Center(
                        child: TextButton(
                            onPressed: () {
                              Get.to(() => ForgotPasswrodScreen());
                            },
                            child: Text(
                              'Forgot Password ?',
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.kPrimary),
                            ))),
                    10.sH,
                    Center(
                      child: Text.rich(TextSpan(children: [
                        TextSpan(text: 'If you are new ,\t', style: Theme.of(context).textTheme.bodyMedium),
                        TextSpan(
                            text: 'Create Account',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => BHelperFunction.navigate(context, SignUpScreen()),
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
                      googleTapped: () {
                        _handleSignIn();
                      },
                      facebookTapped: () {},
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
