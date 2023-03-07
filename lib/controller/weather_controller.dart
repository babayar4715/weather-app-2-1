import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_weather_continuing/srcc/constants/api.dart';
import 'package:flutter_application_weather_continuing/srcc/constants/appColors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../srcc/model/weather.dart';

class WeatherCtl extends GetxController {
  Rx<Weather?> weather = Rxn();
  final dio = Dio();
  // if RxInt bolo turgan bolso anda anyn artyna / .obsti koshushu kerek je anyn value sin alyshy kerek

  @override
  void onInit() {
    super.onInit();
    weathername();
  }

  Future<void> weatherLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    // location permission
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.always &&
          permission == LocationPermission.whileInUse) {
        Position position = await Geolocator.getCurrentPosition();

        final response = await dio.get(Apiconst.getLocator(
            lat: position.latitude, long: position.longitude));
        if (response.statusCode == 200) {
          weather.value = Weather(
            id: response.data['current']['weather'][0]['id'],
            main: response.data['current']['weather'][0]['main'],
            description: response.data['current']['weather'][0]['description'],
            icon: response.data['current']['weather'][0]['icon'],
            city: response.data['timezone'],
            temp: response.data['current']['temp'],
          );
        }
      }
    } else {
      Position position = await Geolocator.getCurrentPosition();
      final dio = Dio();
      final response = await dio.get(Apiconst.getLocator(
          lat: position.latitude, long: position.longitude));
      if (response.statusCode == 200) {
        weather.value = Weather(
          id: response.data['current']['weather'][0]['id'],
          main: response.data['current']['weather'][0]['main'],
          description: response.data['current']['weather'][0]['description'],
          icon: response.data['current']['weather'][0]['icon'],
          city: response.data['timezone'],
          temp: response.data['current']['temp'],
        );
      }
    }
  }

  Future<void> weathername([String? name]) async {
    final res = await dio.get(Apiconst.address(name ?? 'bishkek'));
    if (res.statusCode == 200) {
      weather.value = Weather(
        id: res.data['weather'][0]['id'],
        main: res.data['weather'][0]['main'],
        description: res.data['weather'][0]['description'],
        icon: res.data['weather'][0]['icon'],
        city: res.data['name'],
        temp: res.data['main']['temp'],
        country: res.data['sys']['country'],
      );
    }
  }

  List<String> cities = [
    'bishkek',
    'osh',
    'talas',
    'naryn',
    'jalal-abad',
    'batken',
    'tokmok',
  ];

  void Showbottom(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 52, 50, 50),
            border: Border.all(color: AppColor.white),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          height: MediaQuery.of(context).size.height * 0.8,
          child: ListView.builder(
            itemCount: cities.length,
            itemBuilder: ((context, index) {
              final city = cities[index];
              return Card(
                child: ListTile(
                  onTap: () {
                    weathername(city);
                    Navigator.pop(context);
                  },
                  title: Text(city),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

// Future<void> weatherLocation() async {
//     // bul jerde bizde <void> bar eken bul bul jerde bizge funcsianyn generigi katary kelgen jana bul menen biz fucsiany ech kanday resultat kaytaryp berbeshi ychyn koldonsok boloot
//     // async bul bizge serverden datany alyp kelgende al data ekranga chykkancha kutup tyrat je al datany alyp kelgenge jardam beret
//     setState(() {
//       // setstate bizge bashynan build kylyp bergende anga berilgen weather = null; bul anyn astynda korsotylgondoy circle prograss indicatordy chygaryp beret
//       weather = null;
//     });
