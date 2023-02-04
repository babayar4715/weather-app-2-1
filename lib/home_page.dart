import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_weather_continuing/constants/api.dart';
import 'package:flutter_application_weather_continuing/constants/appColors.dart';
import 'package:flutter_application_weather_continuing/constants/appText.dart';
import 'package:flutter_application_weather_continuing/constants/appTextStyle.dart';
import 'package:flutter_application_weather_continuing/model/weather.dart';
import 'package:geolocator/geolocator.dart';

List<String> cities = [
  'bishkek',
  'osh',
  'talas',
  'naryn',
  'jalal-abad',
  'batken',
  'tokmok',
];

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Weather? weather;
  Future<void> weatherLocation() async {
    // bul jerde bizde <void> bar eken bul bul jerde bizge funcsianyn generigi katary kelgen jana bul menen biz fucsiany ech kanday resultat kaytaryp berbeshi ychyn koldonsok boloot
    // async bul bizge serverden datany alyp kelgende al data ekranga chykkancha kutup tyrat je al datany alyp kelgenge jardam beret
    setState(() {
      // setstate bizge bashynan build kylyp bergende anga berilgen weather = null; bul anyn astynda korsotylgondoy circle prograss indicatordy chygaryp beret
      weather = null;
    });
    LocationPermission permission = await Geolocator.checkPermission();
    // location permission
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.always &&
          permission == LocationPermission.whileInUse) {
        Position position = await Geolocator.getCurrentPosition();
        final dio = Dio();
        final response = await dio.get(Apiconst.getLocator(
            lat: position.latitude, long: position.longitude));
        if (response.statusCode == 200) {
          weather = Weather(
            id: response.data['current']['weather'][0]['id'],
            main: response.data['current']['weather'][0]['main'],
            description: response.data['current']['weather'][0]['description'],
            icon: response.data['current']['weather'][0]['icon'],
            city: response.data['timezone'],
            temp: response.data['current']['temp'],
          );
        }
        setState(() {});
      }
    } else {
      Position position = await Geolocator.getCurrentPosition();
      final dio = Dio();
      final response = await dio.get(Apiconst.getLocator(
          lat: position.latitude, long: position.longitude));
      if (response.statusCode == 200) {
        weather = Weather(
          id: response.data['current']['weather'][0]['id'],
          main: response.data['current']['weather'][0]['main'],
          description: response.data['current']['weather'][0]['description'],
          icon: response.data['current']['weather'][0]['icon'],
          city: response.data['timezone'],
          temp: response.data['current']['temp'],
        );
      }
      setState(() {});
    }
  }

  Future<void> weathername([String? name]) async {
    final dio = Dio();

    final res = await dio.get(Apiconst.address(name ?? 'bishkek'));
    if (res.statusCode == 200) {
      weather = Weather(
        id: res.data['weather'][0]['id'],
        main: res.data['weather'][0]['main'],
        description: res.data['weather'][0]['description'],
        icon: res.data['weather'][0]['icon'],
        city: res.data['name'],
        temp: res.data['main']['temp'],
        country: res.data['sys']['country'],
      );
    }
    setState(() {});
  }

  @override
  void initState() {
    weathername();
    super.initState();
  }

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
      body: weather == null
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
                          await weatherLocation();
                        },
                        iconSize: 50,
                        icon: const Icon(
                          Icons.near_me,
                          color: AppColor.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Showbottom();
                        },
                        iconSize: 50,
                        icon: const Icon(
                          Icons.location_city,
                          color: AppColor.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Row(
                      children: [
                        Text('${(weather!.temp - 273.15).toInt()}',
                            style: AppTextStyle.body1),
                        const SizedBox(width: 20),
                        Image.network(Apiconst.getIcon('${weather!.icon}', 4)),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FittedBox(
                          child: Text(
                            weather!.description.replaceAll(" ", '\n'),
                            textAlign: TextAlign.end,
                            style: AppTextStyle.body2,
                          ),
                        ),
                        const SizedBox(width: 60),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Text(weather!.city, style: AppTextStyle.city),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void Showbottom() {
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
                        setState(() {
                          weather = null;
                        });
                        weathername(city);
                        Navigator.pop(context);
                      },
                      title: Text(city),
                    ),
                  );
                })));
      },
    );
  }
}
