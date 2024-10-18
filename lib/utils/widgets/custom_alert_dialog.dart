import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisport_player_app/utils/const/colors.dart';
import 'package:unisport_player_app/utils/const/sizes.dart';

import 'custom_button.dart';

class customAlertDialog extends StatelessWidget {
  final String? title;
  final String message;

  const customAlertDialog({
    super.key,
    this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Card(
        color:AppColors.kSecondary,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title ?? 'Message',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              20.sH,
              Text(
                message,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
              10.sW,

              30.sH,
              CustomButton(
                  height: 50,
                  title: 'Ok',
                  onPressed: () {
                    Get.back();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
