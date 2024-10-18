import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:unisport_player_app/controller/onboarding_controller.dart';
import 'package:unisport_player_app/utils/const/colors.dart';
import 'package:unisport_player_app/utils/const/image_string.dart';
import 'package:unisport_player_app/utils/const/sizes.dart';
import 'package:unisport_player_app/utils/helper/helper_function.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final onBoardingContect = [
    ['We Help You Get Better', 'No Matter What Sport You Play', ImageString.on1],
    ['Analyze Your Every Move', 'Detail Stats on How You Play and How to Improve', ImageString.on2],
    ['Notifications', 'Get notified when the best match found by us', ImageString.on3],
  ];
  double d = 3.25;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              controller.skipPage();
            },
            child: Text(
              "SKIP",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          PageView.builder(
            onPageChanged: controller.updatePageIndex,
            controller: controller.pageController,
            itemCount: onBoardingContect.length,
            //physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.defaultSpace),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          onBoardingContect[index][2],
                          height: 300,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(
                          height: AppSizes.spaceBtwItem / 2,
                        ),
                        Text(
                          onBoardingContect[index][0],
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(
                          height: AppSizes.spaceBtwItem / 2,
                        ),

                        /// subtitle
                        Text(
                          onBoardingContect[index][1],
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w300),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: AppSizes.spaceBtwItem,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: BHelperFunction.screenHeight() * 0.13,
            child: SmoothPageIndicator(
              controller: controller.pageController,
              count: 3,
              effect: const ExpandingDotsEffect(
                dotHeight: 5,
                dotWidth: 20,
                activeDotColor: AppColors.kPrimary,
                dotColor: AppColors.kSecondary,
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
          height: 50,
          margin: const EdgeInsets.all(AppSizes.spaceBtwSection / 2),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.kPrimary),
          child: TextButton.icon(
            onPressed: () {
              controller.nextPage();
            },
            icon: const Icon(
              Iconsax.arrow_right_34,
              size: AppSizes.iconMd,
            ),
            label: Text(
              'NEXT',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          )),
    );
  }
}
