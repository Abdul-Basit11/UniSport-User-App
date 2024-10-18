import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:unisport_player_app/utils/const/sizes.dart';
import 'package:unisport_player_app/utils/widgets/custom_loaders.dart';
import 'package:unisport_player_app/view/authentication/login_screen/login_screen.dart';

import '../../../controller/login_controller.dart';
import '../../../utils/const/image_string.dart';
import '../../../utils/validators/validators.dart';
import '../../../utils/widgets/custom_button.dart';
import '../../../utils/widgets/custom_screen_title.dart';
import '../../../utils/widgets/custom_textfield.dart';

class ForgotPasswrodScreen extends StatelessWidget {
  TextEditingController email = TextEditingController();
  final forgotKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return CustomLoader(
      isLoading: controller.isLoading.value,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.defaultSpace),
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
                  title: 'Forgot Password .',
                ),
                10.sH,
                Text(
                  'Please enter your address to request a password reuest .',
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
                  controller: email,
                  hintText: 'Email',
                  prefixIcon: Iconsax.direct_right,
                  isPrefixIcon: true,
                ),
                30.sH,
                CustomButton(
                    title: 'Send Email',
                    onPressed: () {
                      if (forgotKey.currentState!.validate()) {
                        controller.sendEmailResetPassword(email.text.toString());
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
