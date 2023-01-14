import 'dart:async';
import 'dart:core';
import 'package:aqi/services/HttpHelper.dart';
import 'package:aqi/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var aqi;
  double? pm10;
  double? pm2;
  double? o3;
  double? so2;
  double? no2;

  @override
  void initState() {
    super.initState();
    getLocationData().then((getLocationData) {
      setState(() {
        updatUi(getLocationData);
      });
    });
  }

  late double latitude;
  late double longitude;

  getLocationData() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    Position Location = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    longitude = Location.longitude;
    latitude = Location.latitude;
    HttpHelper httpHelper = HttpHelper(
        'https://api.openweathermap.org/data/2.5/air_pollution?lat=$latitude&lon=$longitude&appid=$apiKey');

    var aqiData = await httpHelper.getData();
    // updatUi(aqiData);
    return aqiData;
  }

  void updatUi(dynamic aqiData) {
    aqi = aqiData['list'][0]['main']['aqi'];
    pm10 = aqiData['list'][0]['components']['pm10'];
    no2 = aqiData['list'][0]['components']['no2'];
    o3 = aqiData['list'][0]['components']['o3'];
    pm2 = aqiData['list'][0]['components']['pm2_5'];
    so2 = aqiData['list'][0]['components']['so2'];
  }

  @override
  Widget build(BuildContext context) {
    var generalPadding = EdgeInsets.symmetric(vertical: 10, horizontal: 20);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Air Quality Index'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: const Text('Today Air Quality',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            ),
            Padding(padding: generalPadding),
            Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 100,
                  width: 100,
                  margin: generalPadding,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.deepPurpleAccent,
                        width: 5,
                      ),
                      shape: BoxShape.circle),
                  child: Text(
                    '$aqi',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Very High',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    SizedBox(height: 10),
                    Text(
                      'Reduce physical exertion,\n particularly outdoors, especially\n if you experience symptoms \n such as a cough or sore throat',
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                  shape: BoxShape.rectangle),
            ),
            const SizedBox(height: 15),
            const Text(
              'Primary Pollutant :',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 15),
            const Text(
              'PM2.5 Particulate matter less than 2.5 microns',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                  shape: BoxShape.rectangle),
            ),
            const SizedBox(height: 15),
            const Text('All pollutants',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 15),
            pollutantstile(
              generalPadding: generalPadding,
              pollutants: '$pm10',
              pollutantvalue: 10,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.green,
                    width: 1,
                  ),
                  shape: BoxShape.rectangle),
            ),
            pollutantstile(
              generalPadding: generalPadding,
              pollutants: '$no2',
              pollutantvalue: 1.2,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.green,
                    width: 1,
                  ),
                  shape: BoxShape.rectangle),
            ),
            pollutantstile(
              generalPadding: generalPadding,
              pollutants: 'PM10',
              pollutantvalue: 1.5,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.green,
                    width: 1,
                  ),
                  shape: BoxShape.rectangle),
            ),
            pollutantstile(
              generalPadding: generalPadding,
              pollutants: 'PM10',
              pollutantvalue: 1.5,
            ),
          ],
        ),
      ),
    );
  }
}

class pollutantstile extends StatelessWidget {
  pollutantstile(
      {Key? key,
      required this.generalPadding,
      required this.pollutants,
      required this.pollutantvalue})
      : super(key: key);
// Dynamic keywords defined which are going to be used in the Widgets
  final EdgeInsets generalPadding;
  dynamic pollutants;
  double pollutantvalue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          alignment: Alignment.center,
          height: 70,
          width: 70,
          margin: generalPadding,
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.yellow,
                width: 2,
              ),
              shape: BoxShape.circle),
          child: const Text(
            '10',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(pollutants,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            const Text('Very High',
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(pollutantvalue.toString(),
                style: const TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.bold))
          ],
        )
      ],
    );
  }
}
