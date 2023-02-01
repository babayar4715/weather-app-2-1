import 'package:flutter/material.dart';

import 'package:flutter_application_weather_continuing/constants/appColors.dart';

class AppTextStyle {
  static const AppBarStyle =
      TextStyle(color: AppColor.black, fontWeight: FontWeight.bold);

  static const TextStyle body1 = TextStyle(color: AppColor.white, fontSize: 95);

  static const TextStyle body2 = TextStyle(
    color: AppColor.white,
    fontSize: 60,
  );
  static const TextStyle city = TextStyle(
    fontSize: 96,
    color: AppColor.white,
  );
}
