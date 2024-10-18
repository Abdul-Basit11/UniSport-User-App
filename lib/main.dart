import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:unisport_player_app/utils/const/colors.dart';
import 'package:unisport_player_app/utils/exceptions/notification_permission.dart';
import 'package:unisport_player_app/utils/theme/theme.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'controller/auth_controller.dart';
import 'firebase_options.dart';
import 'services/theme_services.dart';

void main() async {
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) {
    return Get.put(
      AuthController(),
    );
  });
  await GetStorage.init();
  await NotificationPermision().requestPermission();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize('1108f2cd-f8b5-4d2f-9fcf-e42b4b9c8dd0');

  OneSignal.Notifications.addClickListener((OSNotificationClickEvent event) {
    if (event.notification.additionalData!["custom_data"]["NOTIFICATION_TYPE"] == "MESSAGE_NOTIFICATION") {
      // navigatorKey.currentState?.pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (context) => BottomBarScreen(index: 1,)),
      //     ModalRoute.withName("/Home"));
    } else {
      // navigatorKey.currentState?.push(
      //   MaterialPageRoute(builder: (context) => OrderHistoryScreen()),
      // );
    }
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UniSport Connect Player',
      theme: AppTheme.lightTheme(context),
      darkTheme: AppTheme.darkTheme(context),
      themeMode: ThemeService().getThemeMode(),
      home: const Scaffold(
        backgroundColor: AppColors.kLightOrange,
        body: Center(
          child: CircularProgressIndicator(
            backgroundColor: AppColors.kPrimary,
          ),
        ),
      ),
    );
  }
}
