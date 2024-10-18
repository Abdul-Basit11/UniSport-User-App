import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unisport_player_app/utils/const/back_end_config.dart';
import 'package:unisport_player_app/utils/const/colors.dart';
import 'package:unisport_player_app/utils/const/sizes.dart';

import '../../../utils/helper/helper_function.dart';

class AppliedGamesScreen extends StatelessWidget {
  const AppliedGamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Applied Games'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.defaultSpace),
        child: StreamBuilder(
          stream: BackEndConfig.applyGamesCollection
              .where('applier_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
                child: Text("You don't have apply in any event yet !"),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var data = snapshot.data!.docs[index];
                return Card(
                  color: AppColors.kSecondary,
                  elevation: 4,
                  child: ExpansionTile(
                    backgroundColor: AppColors.kSecondary,
                    expandedAlignment: Alignment.centerLeft,
                    title: Text(
                      data['event_game_name'],
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: AppColors.kwhite),
                    ),
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: AppColors.kPrimary), borderRadius: BorderRadius.circular(12)),
                    subtitle: Text(
                      data['isApproved'] == false ? 'Pending' : 'Approved',
                      style: TextStyle(
                          color: data['isApproved'] == false ? AppColors.kErrorColor : AppColors.kGreenColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                    leading: const Text(
                      "Applied Games:",
                      style: TextStyle(color: AppColors.kGreenColor),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    height: 100,
                                    width: 100,
                                    imageUrl: data['event_image'].toString(),
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.kPrimary, // Loader color
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(child: Text(data['event_name']))
                              ],
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
      ),
    );
  }
}
