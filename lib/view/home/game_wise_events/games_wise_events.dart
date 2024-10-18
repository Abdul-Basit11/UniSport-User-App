import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisport_player_app/utils/const/back_end_config.dart';

import '../../../utils/const/colors.dart';
import '../../../utils/const/sizes.dart';
import '../../../utils/helper/helper_function.dart';
import '../../../utils/widgets/custom_button.dart';
import '../event_detail_view/event_detail_screen.dart';
import '../home_view/widget/event_card.dart';

class GamesWiseEvents extends StatelessWidget {
  final String gameName;
  final String gameId;

  const GamesWiseEvents({super.key, required this.gameName, required this.gameId});

  @override
  Widget build(BuildContext context) {
    final dark = BHelperFunction.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(gameName.toString()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.defaultSpace),
        child: Column(
          children: [
            StreamBuilder(
              stream: BackEndConfig.eventsCollection.where('event_game_id', isEqualTo: gameId.toString()).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'No Event Added yet for\n${gameName.toString()} !',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  Text(
                    'Some Thing Went Wrong 🚫',
                    style: Theme.of(context).textTheme.bodyLarge,
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.kPrimary,
                      strokeWidth: 5,
                    ),
                  );
                }
                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, mainAxisSpacing: 15, crossAxisSpacing: 15, mainAxisExtent: 200),
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index];
                    return Stack(
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
                                FittedBox(
                                  child: Text(
                                    data['event_name'],
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                        fontWeight: FontWeight.bold, color: dark ? Colors.white : Colors.white),
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
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
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
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
