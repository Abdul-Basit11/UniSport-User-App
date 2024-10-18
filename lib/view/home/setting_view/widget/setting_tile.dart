import 'package:flutter/material.dart';

import '../../../../utils/const/colors.dart';
import '../../../../utils/const/sizes.dart';


class SettingTile extends StatelessWidget {
  final String title;
  final Widget widget;
  final VoidCallback? onTaped;

  const SettingTile({super.key, required this.title, required this.widget, this.onTaped});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
         dense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        onTap: onTaped,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.md)),
        tileColor: AppColors.kSecondary,
        title:  Text(title,style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),),
        trailing: widget,
      ),
    );
  }
}
