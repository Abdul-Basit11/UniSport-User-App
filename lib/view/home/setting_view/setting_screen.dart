import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';
import 'package:unisport_player_app/utils/const/colors.dart';
import 'package:unisport_player_app/utils/const/image_string.dart';
import 'package:unisport_player_app/utils/const/sizes.dart';
import 'package:unisport_player_app/utils/helper/helper_function.dart';
import 'package:unisport_player_app/utils/widgets/custom_button.dart';
import 'package:unisport_player_app/utils/widgets/custom_screen_title.dart';
import 'package:unisport_player_app/view/home/edit_profile_view/edit_profile_screen.dart';
import 'package:unisport_player_app/view/home/setting_view/widget/setting_tile.dart';

import '../../../controller/theme_controller.dart';
import '../../../utils/const/back_end_config.dart';
import '../../authentication/login_screen/login_screen.dart';
import '../change_password_view/change_password_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController _themeController = Get.put(ThemeController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Setting',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.defaultSpace),
        child: SingleChildScrollView(
          child: Column(
            children: [
              10.sH,
              Container(
                width: double.infinity,
                height: 160,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: AppColors.kGrey,
                    borderRadius: BorderRadius.circular(AppSizes.md),
                    image: const DecorationImage(
                        alignment: Alignment.centerRight, image: AssetImage(ImageString.profilebg))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Text(
                      'CHECK YOUR PROFILE',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: BHelperFunction.isDarkMode(context) ? Colors.white : Colors.white),
                    ),
                    const Spacer(),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: 'HI,\t\t', style: Theme.of(context).textTheme.labelLarge),
                          TextSpan(text: name ?? 'Name', style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                    ),
                    Text(email ?? 'user@gmail.com', style: Theme.of(context).textTheme.labelMedium),
                    const Spacer(
                      flex: 3,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            title: 'View',
                            onPressed: () {
                              Get.to(() => EditProfileScreen());
                            },
                            height: 45,
                          ),
                        ),
                        const Expanded(flex: 2, child: SizedBox()),
                      ],
                    )
                    // OutlinedButton(onPressed: () {}, child: Text('View'))
                  ],
                ),
              ),
              20.sH,
              const Divider(),
              10.sH,
              SettingTile(
                title: 'Theme',
                widget: GetBuilder<ThemeController>(
                  builder: (controller) => Switch(
                    value: controller.theme == ThemeMode.dark,
                    onChanged: (value) {
                      controller.switchTheme();
                    },
                  ),
                ),
              ),
              10.sH,
              CustomScreenTitle(title: 'Profile'),
              20.sH,
              // SettingTile(
              //   onTaped: () {
              //     Get.to(() => const EditProfileScreen());
              //   },
              //   title: 'Edit Profile',
              //   widget: const Icon(
              //     Iconsax.arrow_circle_right,
              //     color: AppColors.kPrimary,
              //   ),
              // ),
              SettingTile(
                onTaped: () {
                  Get.to(() => const ChangePasswordScreen());
                },
                title: 'Change Password',
                widget: const Icon(
                  Iconsax.arrow_circle_right,
                  color: AppColors.kPrimary,
                ),
              ),
              10.sH,
              CustomScreenTitle(title: 'Notification'),
              20.sH,
              SettingTile(
                title: 'Notifications',
                widget: Transform.scale(scale: 0.9, child: Switch(value: false, onChanged: (v) {})),
              ),
              SettingTile(
                title: 'Logout',
                widget: const Icon(
                  Iconsax.logout,
                  color: AppColors.kPrimary,
                ),
                onTaped: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        child: Card(
                          color: AppColors.kSecondary,
                          elevation: 10,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.md)),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSizes.sm),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                10.sH,
                                Text(
                                  'Logout',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                8.sH,
                                const Text('Oh,No you are leaving'),
                                25.sH,
                                CustomButton(
                                  title: 'Logout',
                                  onPressed: () {
                                    FirebaseAuth.instance.signOut().then((value) {
                                      return Get.offAll(() => LoginScreen());
                                    });
                                  },
                                  height: 42,
                                ),
                                8.sH,
                                SizedBox(
                                    height: 42,
                                    width: double.infinity,
                                    child: OutlinedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('No',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(fontWeight: FontWeight.bold, color: Colors.white)))),
                                10.sH,
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              50.sH,
              Center(
                child: Text(
                  'App Version 1.0.0+1',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(shadows: [
                    Shadow(color: Colors.black.withOpacity(0.3), offset: const Offset(4, 0), blurRadius: 10),
                  ], color: AppColors.kPrimary),
                ),
              ),
              10.sH,
            ],
          ),
        ),
      ),
    );
  }

  String? email;

  String? name;

  getCurrentUser() {
    BackEndConfig.userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((DocumentSnapshot documentSnapshot) {
      setState(() {});
      name = documentSnapshot.get('name');
      email = documentSnapshot.get('email');
    });
  }
}
