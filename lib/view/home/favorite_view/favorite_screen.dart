import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:unisport_player_app/controller/event_controller.dart';
import 'package:unisport_player_app/utils/const/back_end_config.dart';
import 'package:unisport_player_app/utils/const/sizes.dart';
import 'package:unisport_player_app/view/home/favorite_view/widget/favourite_card.dart';

import '../../../utils/const/colors.dart';
import '../../../utils/helper/helper_function.dart';
import '../../../utils/widgets/custom_button.dart';
import '../event_detail_view/event_detail_screen.dart';

class FavouriteScreen extends StatelessWidget {
  final dynamic data;

  const FavouriteScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final eventController = Get.put(EventController());
    final dark = BHelperFunction.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Favourite Games',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: StreamBuilder(
        stream: BackEndConfig.eventsCollection
            .where('favourite_list', arrayContains: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: AppColors.kPrimary,
            ));
          } else if (snapshot.hasError) {
            return Text('SomeThing Went Wrong:');
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No Event are added in favourite'),
            );
          }
          return GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.defaultSpace),
            itemCount: snapshot.data!.docs.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 15, crossAxisSpacing: 15, mainAxisExtent: 200),
            itemBuilder: (context, index) {
              final data = snapshot.data!.docs[index];
              return Container(
                height: 200,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Container(
                        height: 150,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: AppColors.kSecondary, borderRadius: BorderRadius.circular(AppSizes.md)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            5.sH,
                            FittedBox(
                              child: Text(
                                data['event_name'],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontWeight: FontWeight.bold, color: dark ? Colors.white : Colors.white),
                              ),
                            ),
                            Text(
                              data['event_game_name'],
                              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                    color: dark ? Colors.white : Colors.white,
                                  ),
                            ),
                            10.sH,
                            CustomButton(
                              title: 'View',
                              onPressed: () {
                                Get.to(
                                  () => EventDetailScreen(
                                    data: data,
                                  ),
                                );
                              },
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20, right: 10, left: 10),
                      height: 120,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              height: 100,
                              width: double.infinity,
                              imageUrl: data['event_image'].toString(),
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.kPrimary, // Loader color
                                ),
                              ),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30.0, right: 15),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  if (eventController.isFav.value) {
                                    /// this is a product id
                                    eventController.removeFavourite(data.id, context);
                                    //controller.isFav(false);
                                  } else {
                                    eventController.addToFavourite(data.id, context);
                                    print(data.id);
                                    //controller.isFav(true);
                                  }
                                },
                                child: Container(
                                  child: Icon(
                                    data['favourite_list'].contains(FirebaseAuth.instance.currentUser!.uid)
                                        ? Iconsax.heart5
                                        : Iconsax.heart,
                                    color: AppColors.kPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
