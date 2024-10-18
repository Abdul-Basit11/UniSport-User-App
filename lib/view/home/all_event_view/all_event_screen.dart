import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:unisport_player_app/utils/const/sizes.dart';

import '../../../utils/const/colors.dart';
import '../../../utils/widgets/custom_textfield.dart';
import '../home_view/widget/event_card.dart';

class AllEventScreen extends StatelessWidget {
  const AllEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'All Events',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.defaultSpace),
        child: SingleChildScrollView(
          child: Column(
            children: [
              10.sH,
              CustomTextField(
                hintText: 'Search Game',
                suffixicon: const Icon(
                  Iconsax.search_normal_14,
                  color: AppColors.kPrimary,
                  size: 22,
                ),
              ),
              20.sH,
              AnimationLimiter(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 6,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, mainAxisSpacing: 15, crossAxisSpacing: 15, mainAxisExtent: 200),
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      columnCount: 2,
                      duration: const Duration(milliseconds: 1000),
                      child: const SlideAnimation(
                        duration: Duration(milliseconds: 1000),
                        child: SlideAnimation(
                          delay: Duration(milliseconds: 275),
                          child: EventCard(),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // GridView.builder(
              //   itemCount: 10,
              //   physics: const NeverScrollableScrollPhysics(),
              //   shrinkWrap: true,
              //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //       crossAxisCount: 2, mainAxisSpacing: 15, crossAxisSpacing: 15, mainAxisExtent: 200),
              //   itemBuilder: (context, index) {
              //     return const EventCard();
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
