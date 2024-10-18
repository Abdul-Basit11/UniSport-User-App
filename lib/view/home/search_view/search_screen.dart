import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/event_controller.dart';
import '../../../utils/const/colors.dart';
import '../../../utils/const/sizes.dart';
import '../../../utils/helper/helper_function.dart';
import '../../../utils/widgets/custom_button.dart';
import '../event_detail_view/event_detail_screen.dart';

class SearchScreen extends StatelessWidget {
  final String eventName;

  const SearchScreen({super.key, required this.eventName});

  @override
  Widget build(BuildContext context) {
    final dark = BHelperFunction.isDarkMode(context);

    final eventController = Get.put(EventController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Search Events',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
          child: Column(
            children: [
              StreamBuilder(
                stream: eventController.searchEvent(eventName),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        children: [
                          const SizedBox(height: kToolbarHeight),
                          Text(
                            'No Event Found for\n$eventName',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: kToolbarHeight / 2),
                          const SizedBox(height: kToolbarHeight),
                        ],
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    Text(
                      'some Thing Went Wrong',
                      style: Theme.of(context).textTheme.bodyLarge,
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  var data = snapshot.data!.docs;
                  var filteredData = data
                      .where(
                          (element) => element['event_name'].toString().toLowerCase().contains(eventName.toLowerCase()))
                      .toList();

                  return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: filteredData.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, mainAxisSpacing: 15, crossAxisSpacing: 15, mainAxisExtent: 200),
                    itemBuilder: (context, index) {
                      var data = filteredData[index];
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
      ),
    );
  }
}
