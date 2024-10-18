import 'package:flutter/material.dart';
import 'package:unisport_player_app/utils/const/colors.dart';
import 'package:unisport_player_app/utils/const/image_string.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimary,
      body: Center(
        child: Image.asset(
          ImageString.appLogo,
          width: 180,
        ),
      ),
      // body: Column(
      //   children: [
      //
      //      const Spacer(
      //        flex: 3,
      //      ),
      //      Text(
      //        'U S',
      //        style: Theme.of(context).textTheme.headlineSmall,
      //      ),
      //      const Text('Connect'),
      //      const Spacer(),
      //      const SpinKitCircle(color: Colors.white),
      //      const Spacer(),
      //      Image.asset(
      //        ImageString.splashLogo,
      //        width: 392,
      //      ),
      //   ],
      // ),
    );
  }
}
