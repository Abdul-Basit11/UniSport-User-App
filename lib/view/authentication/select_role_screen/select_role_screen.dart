import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:unisport_player_app/utils/const/colors.dart';
import 'package:unisport_player_app/utils/widgets/custom_button.dart';
import 'package:unisport_player_app/utils/widgets/custom_loaders.dart';

import '../../../controller/signup_controller.dart';
import '../../../utils/const/decider.dart';
import '../../../utils/const/image_string.dart';
import '../../../utils/const/sizes.dart';
import '../../../utils/const/text_string.dart';
import '../../../utils/helper/helper_function.dart';
import '../../../utils/widgets/custom_screen_title.dart';
import '../../../utils/widgets/custom_textfield.dart';

class SelectRoleScreen extends StatefulWidget {
  const SelectRoleScreen({super.key});

  @override
  State<SelectRoleScreen> createState() => _SelectRoleScreenState();
}

class _SelectRoleScreenState extends State<SelectRoleScreen> {
  TextEditingController departmentName = TextEditingController(text: 'as');
  TextEditingController regNo = TextEditingController(text: 'as');
  TextEditingController playerDescription = TextEditingController(text: 'ass');

  final _key = GlobalKey<FormState>();

  // that specify a match pattern in text
  String? _validateRegistrationNumber(String value) {
    List<String> validPrefixes = ['CS', 'SE', 'MLT', "MT", "PS", 'EN', 'PSY', 'AF', 'PHR'];

    if (value.isEmpty) {
      return 'Please enter your registration number';
    }

    bool isValidPrefix = validPrefixes.any((prefix) => value.toUpperCase().startsWith(prefix));

    if (!isValidPrefix) {
      return 'Please enter a valid registration number (e.g.,CS,SE,MLT,MT,PS,EN,PSY,AF,PHR)';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SelectRoleController());

    return Obx(
      () => CustomLoader(
        isLoading: controller.isLoading.value,
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.defaultSpace),
            child: SingleChildScrollView(
              child: Form(
                key: _key,
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
                    CustomScreenTitle(title: 'Select User Type .'),
                    40.sH,
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              setState(() {
                                Decider.groupValue = TextString.userAccount;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              height: Get.height * 0.23,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.kGrey,
                                borderRadius: BorderRadius.circular(AppSizes.md),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'User',
                                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                              fontSize: 16,
                                            ),
                                      ),
                                      Radio<String>(
                                        activeColor: AppColors.kPrimary,
                                        value: TextString.userAccount,
                                        groupValue: Decider.groupValue,
                                        onChanged: (v) {
                                          setState(() {
                                            Decider.groupValue = v!;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  Image.asset(
                                    'assets/images/user_account.png',
                                    width: 100,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        10.sW,
                        Expanded(
                          child: InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              setState(() {
                                Decider.groupValue = TextString.playerAccount;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              height: Get.height * 0.23,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.kGrey,
                                borderRadius: BorderRadius.circular(AppSizes.md),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    bottom: -105,
                                    right: 0,
                                    left: 0,
                                    child: Image.asset(
                                      'assets/images/player_image.png',
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Player',
                                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                              fontSize: 16,
                                            ),
                                      ),
                                      Spacer(),
                                      Radio<String>(
                                        activeColor: AppColors.kPrimary,
                                        value: TextString.playerAccount,
                                        groupValue: Decider.groupValue,
                                        onChanged: (v) {
                                          setState(() {
                                            Decider.groupValue = v!;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    20.sH,
                    Decider.groupValue == TextString.playerAccount
                        ? Column(
                            children: [
                              CustomTextField(
                                controller: controller.departmentName,
                                validator: (v) {
                                  if (v.isEmpty) {
                                    return 'Department Name is Empty';
                                  }
                                },
                                hintText: 'Department Name',
                                isPrefixIcon: true,
                                prefixIcon: Iconsax.unlimited,
                              ),
                              CustomTextField(
                                controller: controller.regNo,
                                validator: _validateRegistrationNumber,
                                hintText: 'Reg No..',
                                isPrefixIcon: true,
                                prefixIcon: Iconsax.unlimited,
                              ),
                              CustomTextField(
                                controller: controller.playerDescription,
                                validator: (v) {
                                  if (v.isEmpty) {
                                    return 'Player Description is Empty';
                                  }
                                },
                                hintText: 'Player Description',
                                isPrefixIcon: true,
                                prefixIcon: Iconsax.note,
                                suffixicon: InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            backgroundColor: Colors.transparent,
                                            elevation: 0,
                                            child: Card(
                                              color: AppColors.kGrey,
                                              child: Padding(
                                                padding: const EdgeInsets.all(AppSizes.md),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      'Information',
                                                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                          color: BHelperFunction.isDarkMode(context)
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                    10.sH,
                                                    const Text(
                                                      'Give Information About Your self and your skills in a specified game you select',
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: const Icon(Iconsax.info_circle)),
                                maxline: null,
                              ),
                            ],
                          )
                        : SizedBox.shrink(),
                    25.sH,
                    CustomButton(
                      title: 'SignUp',
                      onPressed: () {
                        if (_key.currentState!.validate()) {
                          controller.confirmSelectRoleAndCreate();
                          // BackEndConfig.userCollection.doc(FirebaseAuth.instance.currentUser!.uid).set({
                          //   'isPlayer': Decider.groupValue == TextString.playerAccount ? true : false,
                          //   'departmentName': controller.departmentName.text.toString(),
                          //   'regNo': controller.regNo.text.toString(),
                          //   'playerDescription': controller.playerDescription.text.toString(),
                          // }, SetOptions(merge: true)).then((value) {
                          //   Get.to(() => const NavigationView());
                          // });
                        }
                      },
                    ),
                    20.sH,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
