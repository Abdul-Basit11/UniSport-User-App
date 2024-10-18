import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unisport_player_app/utils/widgets/custom_screen_title.dart';
import 'package:unisport_player_app/utils/widgets/custom_textfield.dart';
import 'package:unisport_player_app/utils/widgets/image_builder_widget.dart';

import '../../../controller/profile_controller.dart';
import '../../../utils/const/back_end_config.dart';
import '../../../utils/const/colors.dart';
import '../../../utils/const/sizes.dart';
import '../../../utils/widgets/custom_button.dart';
import '../../../utils/widgets/custom_loaders.dart';
import '../../authentication/signup_screen/widget/image_picker_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final auth = FirebaseAuth.instance;
  String? userImage;
  bool isPlayer = false;
  TextEditingController name = TextEditingController();
  TextEditingController playerDescription = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserDetail();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    controller.name.text = controller.userName.value;
    controller.playerDescription.text = controller.playerDes.value;
    return Obx(
      () => CustomLoader(
        isLoading: controller.isLoading.value,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Edit Profile',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.defaultSpace),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.sH,
                    CustomScreenTitle(title: 'Update Picture'),
                    40.sH,
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          isDismissible: false,
                          context: context,
                          builder: (context) {
                            return ImagePickerWidget(
                              cameraTapped: () {
                                Get.back();
                                controller.pickImage(imageSource: ImageSource.camera);
                              },
                              galleryTapped: () {
                                Get.back();
                                controller.pickImage(imageSource: ImageSource.gallery);
                              },
                            );
                          },
                        );
                      },
                      child: Center(
                        child: Container(
                          height: 100,
                          width: 100,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.kSecondary,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 25,
                                offset: const Offset(2, 3),
                              ),
                            ],
                          ),
                          child: userImage == '' && controller.imagePath.value.isEmpty
                              ? const Icon(
                                  Iconsax.camera,
                                  color: AppColors.kPrimary,
                                  size: 25,
                                )
                              : userImage != '' && controller.imagePath.value.isEmpty
                                  ? ImageBuilderWidget(
                                      height: 100,
                                      width: 100,
                                      image: userImage.toString(),
                                    )
                                  : Image.file(
                                      File(
                                        controller.imagePath.value,
                                      ),
                                      width: 80,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                        ),
                      ),
                    ),
                    25.sH,
                    CustomScreenTitle(title: 'Update Information'),
                    25.sH,
                    CustomTextField(
                      controller: controller.name,
                      hintText: '',
                      prefixIcon: Iconsax.user_edit,
                      isPrefixIcon: true,
                    ),
                    controller.isPlayer.value
                        ? CustomTextField(
                            controller: controller.playerDescription,
                            hintText: '',
                            isPrefixIcon: true,
                            prefixIcon: Iconsax.note,
                          )
                        : const SizedBox(),
                    30.sH,
                    CustomButton(
                      title: 'Update',
                      onPressed: () async {
                        controller.isLoading(true);
                        if (controller.imagePath.value.isNotEmpty) {
                          await controller.uploadProfileImage();
                        } else {
                          controller.imageLink.value = userImage.toString();
                        }
                        controller.updateProfile(
                          imgUrl: controller.imageLink.value,
                          name: controller.name.text,
                          playerDescription: controller.playerDescription.text,
                        );
                        controller.isLoading(false);
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

  getUserDetail() {
    BackEndConfig.userCollection.doc(auth.currentUser!.uid).snapshots().listen((DocumentSnapshot snapShot) {
      name.text = snapShot.get('name');
      playerDescription.text = snapShot.get('playerDescription');
      isPlayer = snapShot.get('isPlayer');
      userImage = snapShot.get('image');
      setState(() {});
    });
  }

  ImagePicker _picker = ImagePicker();
  File? file;

  // updateUser() async {
  //   String imageURL = '';
  //   if (file != null) {
  //     imageURL = await ImageUpload().uploadImage(context, file: file!);
  //   }
  //   FirebaseFirestore.instance.collection('userCollection').doc(uid).set({
  //     "userName": _name.text,
  //     "userEmail": _email.text,
  //     "userAddress": _address.text,
  //     "userImage": imageURL != "" ? imageURL : userProfileImage,
  //   }, SetOptions(merge: true)).then((value) {
  //     makeLoadingFalse();
  //     Navigator.pop(context);
  //     Utils().toastMessage('User Updated', Theme.of(context).colorScheme.primary);
  //   }).onError((error, stackTrace) {
  //     makeLoadingFalse();
  //   });
  // }
}
