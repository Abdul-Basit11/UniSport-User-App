import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:unisport_player_app/controller/profile_controller.dart';
import 'package:unisport_player_app/utils/const/colors.dart';
import 'package:unisport_player_app/utils/const/sizes.dart';
import 'package:unisport_player_app/utils/helper/helper_function.dart';
import 'package:unisport_player_app/utils/widgets/custom_button.dart';

import '../../../controller/event_controller.dart';
import '../../../utils/widgets/custom_alert_dialog.dart';

class EventDetailScreen extends StatefulWidget {
  final dynamic data;

  EventDetailScreen({super.key, this.data});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final profileCOntroller = Get.put(ProfileController());
    final eventController = Get.put(EventController());
    final dark = BHelperFunction.isDarkMode(context);
    return WillPopScope(
      onWillPop: () async {
        eventController.isFav.value = false;
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/football_logo.png',
                height: 50,
              ),
              10.sW,
              Text(
                widget.data['event_game_name'],
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.defaultSpace),
            child: Column(
              children: [
                20.sH,
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    height: BHelperFunction.screenHeight() * 0.4,
                    width: double.infinity,
                    imageUrl: widget.data['event_image'].toString(),
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.kPrimary, // Loader color
                      ),
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
                10.sH,
                Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  decoration:
                      BoxDecoration(color: AppColors.kSecondary, borderRadius: BorderRadius.circular(AppSizes.md)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 30,
                            width: 4,
                            decoration:
                                BoxDecoration(color: AppColors.kPrimary, borderRadius: BorderRadius.circular(12)),
                          ),
                          10.sW,
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text: "${widget.data['event_game_name']}\t/\t",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(color: AppColors.kwhite, fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: widget.data['event_name'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(color: AppColors.kPrimary, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      15.sH,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Event Date',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(color: dark ? Colors.white : Colors.white),
                          ),
                          Text(
                            widget.data['event_date'],
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: dark ? Colors.white : Colors.white),
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Event Time',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(color: dark ? Colors.white : Colors.white),
                          ),
                          Text(
                            widget.data['event_time'],
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: dark ? Colors.white : Colors.white),
                          ),
                        ],
                      ),
                      15.sH,
                      Text(
                        'Description',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: dark ? Colors.white : Colors.white, fontWeight: FontWeight.bold),
                      ),
                      8.sH,
                      Text(
                        widget.data['event_description'],
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(color: dark ? Colors.white : Colors.white),
                      ),
                      25.sH,
                      Row(
                        children: [
                          Obx(
                            () => Expanded(
                              child: CustomButton(
                                title: 'Apply For Game',
                                onPressed: profileCOntroller.isPlayer.value
                                    ? widget.data['isApproved']
                                        ?
                                        // ? eventController.isAppliedFirstTime.value
                                        //     ? () {
                                        //         showDialog(
                                        //           barrierDismissible: false,
                                        //           context: context,
                                        //           builder: (context) {
                                        //             return const customAlertDialog(
                                        //               message: 'You can apply only in one event ',
                                        //             );
                                        //           },
                                        //         );
                                        //       }
                                        () {
                                            eventController.applyForGame(
                                              eventID: widget.data.id,
                                              eventName: widget.data['event_name'],
                                              eventGameName: widget.data['event_game_name'],
                                              eventGameId: widget.data['event_game_id'],
                                              eventImage: widget.data['event_image'].toString(),
                                              eventadminUid: widget.data['admin_uid'].toString(),
                                              // isApplied: true,
                                            );
                                          }
                                        : () {
                                            showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (context) {
                                                return const customAlertDialog(
                                                  message: 'You cannot apply till the event is approved!',
                                                );
                                              },
                                            );
                                          }
                                    : () {
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return const customAlertDialog(
                                              message: 'For Apply you must have a player account ',
                                            );
                                          },
                                        );
                                      },
                              ),
                            ),
                          ),
                          8.sW,
                          IconButton(
                            onPressed: () {
                              if (eventController.isFav.value) {
                                /// this is a product id
                                eventController.removeFavourite(widget.data.id.toString(), context);
                                //controller.isFav(false);
                              } else {
                                eventController.addToFavourite(widget.data.id.toString(), context);
                                print(widget.data.id);
                                //controller.isFav(true);
                              }
                            },
                            icon: Icon(
                              widget.data['favourite_list'].contains(FirebaseAuth.instance.currentUser!.uid)
                                  ? Iconsax.heart5
                                  : Iconsax.heart,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                20.sH,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
