import 'package:flutter/material.dart';

import 'package:flutter_application_weather_continuing/controller/weather_controller.dart';
import 'package:flutter_application_weather_continuing/srcc/constants/api.dart';
import 'package:flutter_application_weather_continuing/srcc/constants/appColors.dart';
import 'package:flutter_application_weather_continuing/srcc/constants/appText.dart';
import 'package:flutter_application_weather_continuing/srcc/constants/appTextStyle.dart';

import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final controller = Get.put(WeatherCtl());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColor.white,
        title: const Text(
          AppText.appBarTitle,
          style: AppTextStyle.AppBarStyle,
        ),
      ),
      body: controller.weather.value == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/weather.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () async {
                          await controller.weatherLocation();
                        },
                        iconSize: 50,
                        icon: const Icon(
                          Icons.near_me,
                          color: AppColor.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          controller.Showbottom;
                        },
                        iconSize: 50,
                        icon: const Icon(
                          Icons.location_city,
                          color: AppColor.white,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Obx(() {
                        return Text(
                            '${(controller.weather.value!.temp - 273.15).toInt()}',
                            style: AppTextStyle.body1);
                      }),
                      Obx(() {
                        return Image.network(Apiconst.getIcon(
                            controller.weather.value!.icon, 4));
                      }),
                      // Image.network(
                      //   Apiconst.getIcon(controller.weather.value!.icon, 4),
                      // ),
                    ],
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FittedBox(
                          child: Obx(() {
                            return Text(
                              controller.weather.value!.description
                                  .replaceAll(" ", '\n'),
                              textAlign: TextAlign.end,
                              style: AppTextStyle.body2,
                            );
                          }),
                        ),
                        const SizedBox(width: 60),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Obx(() {
                          return Text(controller.weather.value!.city,
                              style: AppTextStyle.city);
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
