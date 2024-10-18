import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:unisport_player_app/utils/loaders/loaders.dart';
import 'package:http/http.dart' as http;
import '../utils/const/back_end_config.dart';

class EventController extends GetxController {
  var isFav = false.obs;
  var searchedController = TextEditingController();
  var currentUser = FirebaseAuth.instance.currentUser;

  addToFavourite(docId, context) async {
    await BackEndConfig.eventsCollection.doc(docId).set(
        {
          'favourite_list': FieldValue.arrayUnion([currentUser!.uid]),
        },
        SetOptions(
          merge: true,
        ));
    isFav(true);
  }

  removeFavourite(docId, context) async {
    await BackEndConfig.eventsCollection.doc(docId).set(
        {
          'favourite_list': FieldValue.arrayRemove([currentUser!.uid]),
        },
        SetOptions(
          merge: true,
        ));
    isFav(false);
  }

  checkIsFav(data) async {
    if (data['favourite_list'].contains(currentUser!.uid)) {
      return true;
    } else {
      return false;
    }
  }

  searchEvent(title) {
    return BackEndConfig.eventsCollection.snapshots();
  }

  // applyForGame({
  //   required eventID,
  //   required eventName,
  //   required eventGameName,
  //   required eventGameId,
  //   required eventImage,
  //   required isApplied,
  // }) {
  //   var applyId = BackEndConfig.applyGamesCollection.doc().id;
  //   BackEndConfig.applyGamesCollection.doc(applyId).set({
  //     'applier_id': FirebaseAuth.instance.currentUser!.uid,
  //     'apply_id': applyId,
  //     'isApproved': false,
  //     'apply_player_name': playerName.value.toString(),
  //     'player_description': playerDes.value.toString(),
  //     'event_id': eventID,
  //     'event_name': eventName,
  //     'event_game_name': eventGameName,
  //     'event_game_id': eventGameId,
  //     'event_image': eventImage,
  //     'isApplied': isApplied,
  //     'player_department_name': departmentName.value.toString(),
  //     'player_image': playerImage.value.toString(),
  //   }).then((v) {
  //     Loaders.customToast(message: 'Wait for approval in applied game from the admin');
  //   });
  // }
  applyForGame({
    required String eventID,
    required String eventName,
    required String eventGameName,
    required String eventGameId,
    required String eventImage,
    required String eventadminUid,
    // required bool isApplied,
  }) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    // Check if the user has already applied for this event
    final querySnapshot = await BackEndConfig.applyGamesCollection
        .where('applier_id', isEqualTo: userId)
        .where('event_id', isEqualTo: eventID)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // User has already applied for this event
      Loaders.warningSnackBar(title: 'Warning', messagse: 'You have already applied for this event.');
      return;
    }

    // User has not applied yet, proceed with the application
    var applyId = BackEndConfig.applyGamesCollection.doc().id;
    await BackEndConfig.applyGamesCollection.doc(applyId).set({
      'applier_id': userId,
      'apply_id': applyId,
      'isApproved': false,
      'apply_player_name': playerName.value.toString(),
      'player_description': playerDes.value.toString(),
      'event_id': eventID,
      'event_name': eventName,
      'event_game_name': eventGameName,
      'event_game_id': eventGameId,
      'event_image': eventImage,
      'admin_uid': eventadminUid.toString(),
      // 'isApplied': isApplied,
      'player_department_name': departmentName.value.toString(),
      'player_image': playerImage.value.toString(),
    }).then((v) {
      Loaders.customToast(message: 'Wait for approval in applied game from the admin');

      sendNotification('${playerName.value.toString()} applied in your event', eventadminUid.toString());
    });
  }

  var playerName = ''.obs;
  var playerDes = ''.obs;
  var departmentName = ''.obs;
  var playerImage = ''.obs;
  var isPlayer = false.obs;

  getUserDetail() {
    BackEndConfig.userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((DocumentSnapshot snapShot) {
      update();
      playerName.value = snapShot.get('name');
      playerDes.value = snapShot.get('playerDescription');
      isPlayer.value = snapShot.get('isPlayer');
      playerImage.value = snapShot.get('image');
      departmentName.value = snapShot.get('departmentName');
    });
  }
  //
  // var isAppliedFirstTime = false.obs;
  //
  // getApplyGamesFields() {
  //   BackEndConfig.applyGamesCollection.snapshots().listen((QuerySnapshot querySnapshot) {
  //     for (var elements in querySnapshot.docs) {
  //       isAppliedFirstTime.value = elements.get('isApplied');
  //     }
  //   });
  // }

  // Future<String> getAdminId(String usersId) async {
  //   DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('tokens').doc(usersId).get();
  //   // setState(() {});
  //   return documentSnapshot.get('id');
  // }
  ///

  // Future<void> getAdminId(docId) async {
  //   await FirebaseFirestore.instance.collection('tokens').doc(docId).get().then((DocumentSnapshot documentSnapshot) {});
  // }
  //
  // sendNotification(String content, String docId) async {
  //   getAdminId(docId);
  //   var headers = {
  //     'Authorization': 'Bearer MzFmZTM5NWEtM2NjYS00NzA3LTg0OTctOGJmZjg2YjdiYzRl',
  //     'Content-Type': 'application/json',
  //   };
  //   var request = http.Request('POST', Uri.parse('https://onesignal.com/api/v1/notifications'));
  //   request.body = json.encode({
  //     "app_id": "1108f2cd-f8b5-4d2f-9fcf-e42b4b9c8dd0",
  //     "include_player_ids": [docId],
  //     // "include_player_ids": ["ade0858e-5c24-4115-950c-464526346bc4"],
  //     "contents": {"en": content}
  //   });
  //   request.headers.addAll(headers);
  //
  //   http.StreamedResponse response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     print(await response.stream.bytesToString());
  //   } else {
  //     print(response.reasonPhrase);
  //   }
  // }
  /// new
  Future<String?> getAdminPlayerId(String adminUid) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance.collection('tokens').doc(adminUid).get();
      if (docSnapshot.exists && docSnapshot.data() != null) {
        print('Admin player ID retrieved: ${docSnapshot.data()!['id']}');
        return docSnapshot.data()!['id'] as String?;
      } else {
        print('Admin player ID not found');
        return null;
      }
    } catch (e) {
      print('Failed to retrieve admin player ID: $e');
      return null;
    }
  }

  Future<void> sendNotification(String content, String adminUid) async {
    try {
      String? playerId = await getAdminPlayerId(adminUid);
      if (playerId == null) {
        print('Player ID is null, cannot send notification');
        return;
      }

      print('Sending notification to player ID: $playerId with content: $content');

      var headers = {
        'Authorization': 'Bearer MzFmZTM5NWEtM2NjYS00NzA3LTg0OTctOGJmZjg2YjdiYzRl',
        'Content-Type': 'application/json',
      };

      var request = http.Request('POST', Uri.parse('https://onesignal.com/api/v1/notifications'));
      request.body = json.encode({
        "app_id": "1108f2cd-f8b5-4d2f-9fcf-e42b4b9c8dd0",
        "include_player_ids": [playerId],
        "contents": {"en": content}
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print('Notification sent successfully');
        print(await response.stream.bytesToString());
      } else {
        print('Failed to send notification: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    getUserDetail();
    //getApplyGamesFields();
  }
}
