import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:unisport_player_app/controller/event_controller.dart';
import 'package:unisport_player_app/utils/const/back_end_config.dart';
import 'package:unisport_player_app/utils/const/colors.dart';
import 'package:unisport_player_app/utils/const/image_string.dart';
import 'package:unisport_player_app/utils/const/sizes.dart';
import 'package:unisport_player_app/utils/helper/helper_function.dart';
import 'package:unisport_player_app/utils/widgets/custom_screen_title.dart';
import 'package:unisport_player_app/utils/widgets/custom_textfield.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../utils/widgets/custom_button.dart';
import '../event_detail_view/event_detail_screen.dart';
import '../game_wise_events/games_wise_events.dart';
import '../search_view/search_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pagecontroller = PageController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _regPlayerID();
  }

  final storage = FlutterSecureStorage();

  _regPlayerID() async {
    final tokenID = OneSignal.User.pushSubscription.id;
    if (tokenID != null) {
      String palyeriD = await storage.read(key: "playerID") ?? "";
      if (palyeriD != tokenID) {
        ///update token in firebase
        FirebaseFirestore.instance.collection('tokens').doc(FirebaseAuth.instance.currentUser!.uid).set({
          'id': tokenID,
        }, SetOptions(merge: true)).then((value) {
          storage.write(key: "playerID", value: tokenID);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = BHelperFunction.isDarkMode(context);
    final eventController = Get.put(EventController());
    DateTime now = DateTime.now();
    DateTime threeDaysFromNow = now.add(Duration(days: 3));

    Stream<QuerySnapshot> _eventsStream = FirebaseFirestore.instance.collection('events').snapshots();

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Container(
              height: 45,
              width: 45,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: image == ''
                  ? Image.asset(
                      ImageString.placeholder,
                      fit: BoxFit.cover,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        width: 38,
                        height: 38,
                        imageUrl: image.toString(),
                        placeholder: (context, url) => Container(
                          width: 10,
                          height: 10,

                          color: AppColors.kPrimary.withOpacity(0.2), // Placeholder background color
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.kPrimary,
                              // Loader color
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.downloading),
                      ),
                    ),
            ),
          ),
        ],
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Iconsax.location5,
              color: Theme.of(context).colorScheme.primary,
            ),
            8.sW,
            Text(
              'Pakistan,Kohat Kust',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.sH,
              CustomTextField(
                controller: eventController.searchedController,
                hintText: 'Search Events',
                onFieldSubmitted: (v) {
                  eventController.searchedController.text = v;
                  if (eventController.searchedController.text.isNotEmpty) {
                    Get.to(() => SearchScreen(
                          eventName: eventController.searchedController.text,
                        ));
                  }
                },
                suffixicon: const Icon(
                  Iconsax.search_normal_14,
                  color: AppColors.kPrimary,
                  size: 22,
                ),
              ),
              10.sH,
              CustomScreenTitle(title: 'Upcoming Events Banners'),
              20.sH,
              StreamBuilder<QuerySnapshot>(
                stream: BackEndConfig.bannerCollection.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Something went wrong!'));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No Banners available.'));
                  } else {
                    List<DocumentSnapshot> docs = snapshot.data!.docs;
                    return Column(
                      children: [
                        SizedBox(
                          height: 155,
                          width: double.infinity,
                          child: PageView.builder(
                            itemCount: docs.length,
                            controller: pagecontroller,
                            itemBuilder: (context, index) {
                              var data = docs[index];
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  width: BHelperFunction.screenWidth() * 0.4,
                                  height: 155,
                                  imageUrl: data['banner'],
                                  placeholder: (context, url) => Container(
                                    width: 10,
                                    height: 10,
                                    color: AppColors.kPrimary.withOpacity(0.2), // Placeholder background color
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.kPrimary,
                                        // Loader color
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => const Icon(Icons.downloading),
                                ),
                              );
                            },
                          ),
                        ),
                        15.sH,
                        Container(
                          alignment: Alignment.center,
                          height: 30,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppSizes.sm),
                            color: dark ? AppColors.kwhite.withOpacity(0.1) : AppColors.kblack.withOpacity(0.1),
                          ),
                          child: SmoothPageIndicator(
                            controller: pagecontroller,
                            count: docs.length,
                            effect: const ExpandingDotsEffect(
                              dotHeight: 5,
                              dotWidth: 20,
                              activeDotColor: AppColors.kPrimary,
                              dotColor: AppColors.kblack,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
              15.sH,
              Row(
                children: [
                  Text(
                    'All Games',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              15.sH,
              StreamBuilder(
                stream: BackEndConfig.gamesCollection.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'No Game Added yet !',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold),
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
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        var game = snapshot.data!.docs[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: CupertinoButton(
                            onPressed: () {
                              BHelperFunction.navigate(
                                context,
                                GamesWiseEvents(gameId: game['game_id'], gameName: game['game_name']),
                              );
                            },
                            padding: EdgeInsets.zero,
                            child: Column(
                              children: [
                                DottedBorder(
                                  borderType: BorderType.Circle,
                                  dashPattern: [8],
                                  radius: const Radius.circular(12),
                                  padding: const EdgeInsets.all(6),
                                  strokeWidth: 0.5,
                                  color: AppColors.kPrimary,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      width: 38,
                                      height: 38,
                                      imageUrl: game['game_logo'],
                                      placeholder: (context, url) => Container(
                                        width: 10,
                                        height: 10,
                                        color: AppColors.kPrimary.withOpacity(0.2), // Placeholder background color
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.kPrimary,
                                            // Loader color
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) => const Icon(Icons.downloading),
                                    ),
                                  ),
                                ),
                                8.sH,
                                SizedBox(
                                  width: 70,
                                  child: Text(
                                    game['game_name'],
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w500),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomScreenTitle(title: 'UpComing Events'),
                ],
              ),
              20.sH,
              StreamBuilder(
                stream: _eventsStream,
                builder: (context, snapshot) {
                  if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'No UpComing Event Available yet !',
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
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

                  List<QueryDocumentSnapshot> filteredDocs = snapshot.data!.docs.where((doc) {
                    String eventDateString = doc['event_date'];
                    DateTime eventDate = DateTime.parse(eventDateString);
                    return eventDate.isAfter(now) && eventDate.isBefore(threeDaysFromNow);
                  }).toList();
                  if (filteredDocs.isEmpty) {
                    return Center(
                      child: Text(
                        'No Upcoming Events within the next 3 days!',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: dark ? Colors.white54 : Colors.black,
                            ),
                      ),
                    );
                  }
                  return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: filteredDocs.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, mainAxisSpacing: 15, crossAxisSpacing: 15, mainAxisExtent: 200),
                    itemBuilder: (context, index) {
                      var data = filteredDocs[index];
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

  String? image;

  getCurrentUser() {
    BackEndConfig.userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((DocumentSnapshot documentSnapshot) {
      setState(() {});
      image = documentSnapshot.get('image');
    });
  }
}
