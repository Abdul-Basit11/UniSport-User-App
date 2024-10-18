import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';
import 'package:unisport_player_app/utils/const/sizes.dart';
import 'package:unisport_player_app/utils/helper/helper_function.dart';

import '../../../../utils/const/colors.dart';
import '../../../../utils/widgets/custom_button.dart';
import '../../event_detail_view/event_detail_screen.dart';

class FavouriteCard extends StatelessWidget {
  const FavouriteCard({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = BHelperFunction.isDarkMode(context);
    return Container(
      height: 200,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 140,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppColors.kSecondary, borderRadius: BorderRadius.circular(AppSizes.md)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        'Game: ',
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(
                              color: dark ? Colors.white : Colors.white,
                            ),
                      ),
                      Text('FootBall',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold, color: dark ? Colors.white : Colors.white)),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Total Events: ',
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(
                              color: dark ? Colors.white : Colors.white,
                            ),
                      ),
                      Text('5',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold, color: dark ? Colors.white : Colors.white)),
                    ],
                  ),
                  5.sH,
                  CustomButton(
                    title: 'View',
                    onPressed: () {
                      Get.to(() => EventDetailScreen());
                    },
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
                padding: const EdgeInsets.only(right: 20, bottom: 10),
                height: 110,
                //margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  // color: Colors.green,
                  image: const DecorationImage(image: AssetImage('assets/images/football.png')),
                  borderRadius: BorderRadius.circular(AppSizes.md),
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: CircleAvatar(
                    backgroundColor: AppColors.kSecondary.withOpacity(0.3),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Iconsax.heart5,
                        color: Colors.red,
                      ),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
