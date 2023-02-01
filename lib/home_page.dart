import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_weather_continuing/constants/api.dart';
import 'package:flutter_application_weather_continuing/constants/appColors.dart';
import 'package:flutter_application_weather_continuing/constants/appText.dart';
import 'package:flutter_application_weather_continuing/constants/appTextStyle.dart';
import 'package:flutter_application_weather_continuing/model/weather.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Future<void> weatherLocation() async {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.always) {
          return Future.error('Location permission are denied');
        }
      }
    }

    Future<Weather?> fetchData() async {
      final dio = Dio();
      await Future.delayed(const Duration(seconds: 5));

      final res = await dio.get(Apiconst.address);
      if (res.statusCode == 200) {
        final weather = Weather(
          id: res.data['weather'][0]['id'],
          main: res.data['weather'][0]['main'],
          description: res.data['weather'][0]['description'],
          icon: res.data['weather'][0]['icon'],
          city: res.data['name'],
          temp: res.data['main']['temp'],
          country: res.data['sys']['country'],
        );
        return weather;
      }
      return null;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColor.white,
        title: const Text(
          AppText.appBarTitle,
          style: AppTextStyle.AppBarStyle,
        ),
      ),
      body: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.none) {
            return const Text('404');
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final weather = snapshot.data;
              return Container(
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
                          onPressed: () {},
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
                          Image.network(Apiconst.getIcon('${weather.icon}', 4)),
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
                              weather.description.replaceAll(" ", '\n'),
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
                        child: Text(weather.city, style: AppTextStyle.city),
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          } else {
            return const Text('404');
          }
        },
      ),
    );
    // body: Center(
    //   child: FutureBuilder(
    //     future: fetchData(),
    //     builder: (context, snapshot) {
    //       if (snapshot.hasData) {
    //         return Column(
    //           children: [
    //             Text('${snapshot.data!.id}'),
    //             Text(snapshot.data!.description),
    //             Text(snapshot.data!.main),
    //             Text(snapshot.data!.icon),
    //             Text(snapshot.data!.city),
    //             Text('${snapshot.data!.temp}'),
    //             Text(snapshot.data!.country),
    //           ],
    //         );
    //       } else if (snapshot.hasError) {
    //         return Center(child: Text(snapshot.error.toString()));
    //       } else {
    //         return const Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       }
    //     },
    //   ),
    // ),
  }
}
