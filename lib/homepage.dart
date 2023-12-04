import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:search_map_place_updated/search_map_place_updated.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LatLng startLocation = LatLng(23.8041, 90.4152);
  String location = "Search Location";
  late MapControllerClass _mapControllerClass;
  double temperature = 10;
  String date = "Today";
  String windStatus = "2.07";
  int humidity = 94;
  double visibility = 10000;
  int airPressure = 1013;




  get placeApiKey => 'AIzaSyBH791EwQqqScXBHNaHFrSh5fNFljqGP6k';
  final String weatherApiKey = 'https://api.openweathermap.org/data/2.5/forecast?lat=23.8041&lon=90.4152&appid=2597a8f67a33d3c584d09c5fc0a2fd2d';


  @override
  void initState() {
    super.initState();
    _mapControllerClass = MapControllerClass();
  }
  Future<void> fetchWeatherData(double latitude, double longitude) async {
    final weatherApiUrl = 'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=2597a8f67a33d3c584d09c5fc0a2fd2d';

    try {
      final response = await http.get(Uri.parse(weatherApiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> weatherData = json.decode(response.body);

        setState(() {
          temperature = (weatherData['main']['temp'] - 273.15).toDouble();
          date = DateTime.now().toString();
          windStatus = weatherData['wind']['speed'].toString();
          humidity = weatherData['main']['humidity'];
          visibility = weatherData['visibility'].toDouble();
          airPressure = weatherData['main']['pressure'];
         
        });
      } else {
        print('Failed to fetch weather data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle error
      print('Error fetching weather data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var userPosition;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blueAccent,
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
        children:[
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: SearchMapPlaceWidget(
            textColor: Colors.blue,
              iconColor: Colors.blue,
              bgColor: Colors.white,
              apiKey: '$placeApiKey',
              language: 'bn',
              location: userPosition?.coordinates, // Make sure userPosition is not null
              onSelected: (Place place) async {
                final geolocation = await place.geolocation;
                final GoogleMapController controller = _mapControllerClass.mapController;
                controller.animateCamera(CameraUpdate.newLatLng(geolocation?.coordinates));
                controller.animateCamera(CameraUpdate.newLatLngBounds(geolocation?.bounds, 0));
                await fetchWeatherData(
                    geolocation?.coordinates.latitude ?? 0.0,
                    geolocation?.coordinates.longitude ?? 0.0);
              }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Text(
              date = DateTime.now().toString(),
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
            child: Text(
              "Bangladesh",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: Text(
              'Dhaka',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 240,
            width: 240,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: Colors.white,
              child: Column(
                //alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Image.asset(
                      'assets/image/4.png',
                      width: 60,
                      height: 60,
                    ),
                  ),
                  Text(
                    '${temperature.toStringAsFixed(1)} °C',
                    style: TextStyle(
                      fontSize: 70,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
         SizedBox(height: 25,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 70),
                child: Column(
                  children: [
                    Text(
                      "WindStatus",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      '$windStatus m/s',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Colors.white
                      ),
                    ),
                    Text(
                      'Humidity',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                    Text(
                      "$humidity%",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Colors.white
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 70),
                child: Column(
                  children: [
                    Text(
                      'Visibility',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      "${visibility.toStringAsFixed(2)}",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Colors.white
                      ),
                    ),
                    Text(
                      'Airpressure',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                    Text(
                      "$airPressure hPa",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Colors.white
                      ),),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 50),
          Container(
            height: 248,
            width: 420,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               Padding(
                  padding: const EdgeInsets.all(30),
                  child: Text(
                    'The Next 5 days',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: Row(
                      children: <Widget>[
                        Text('Sunday',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                        ),
                        ),
                        SizedBox(width: 55),
                        Text('Monday',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.black
                          ),
                        ),
                        SizedBox(width: 55),
                        Text('Tuesday',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.black
                          ),
                        ),
                        SizedBox(width: 55),
                        Text('Wednesday',style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.black
                        ),
                        ),
                        SizedBox(width: 55),
                        Text('Thusday',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.black
                        ),
                        ),
                        SizedBox(width: 55),
                        Text('Friday',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.black
                          ),
                        ),
                        SizedBox(width: 55),
                        Text('Saterday',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.black
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 25,),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 75,
                          width: 70,
                          decoration: BoxDecoration(
                              border:  Border.all(color: Colors.blueGrey),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              Image(image: AssetImage('assets/image/4.png'),
                              height: 35,
                              width: 35,),
                              Text('10\u00B0C',
                              style: TextStyle(
                              fontSize: 30,
                                color: Colors.black,
                              ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 15),
                        Container(
                          height: 75,
                          width: 70,
                          decoration: BoxDecoration(
                              border:  Border.all(color: Colors.blueGrey),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              Image(image: AssetImage('assets/image/4.png'),
                                height: 35,
                                width: 35,),
                              Text('10\u00B0C',
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 15),
                        Container(
                          height: 75,
                          width: 70,
                          decoration: BoxDecoration(
                              border:  Border.all(color: Colors.blueGrey),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              Image(image: AssetImage('assets/image/4.png'),
                                height: 35,
                                width: 35,),
                              Text('10\u00B0C',
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 15),
                        Container(
                          height: 75,
                          width: 70,
                          decoration: BoxDecoration(
                              border:  Border.all(color: Colors.blueGrey),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              Image(image: AssetImage('assets/image/4.png'),
                                height: 35,
                                width: 35,),
                              Text('10\u00B0C',
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 15),
                        Container(
                          height: 75,
                          width: 70,
                          decoration: BoxDecoration(
                              border:  Border.all(color: Colors.blueGrey),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              Image(image: AssetImage('assets/image/4.png'),
                                height: 35,
                                width: 35,),
                              Text('10\u00B0C',
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 15),
                        Container(
                          height: 75,
                          width: 70,
                          decoration: BoxDecoration(
                              border:  Border.all(color: Colors.blueGrey),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              Image(image: AssetImage('assets/image/4.png'),
                                height: 35,
                                width: 35,),
                              Text('10\u00B0C',
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 15),
                        Container(
                          height: 75,
                          width: 70,
                          decoration: BoxDecoration(
                              border:  Border.all(color: Colors.blueGrey),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              Image(image: AssetImage('assets/image/4.png'),
                                height: 35,
                                width: 35,),
                              Text('10\u00B0C',
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

            ),
          ),

        ],
                ),
      ),
    );
  }
}

class MapControllerClass {
  late GoogleMapController _mapController;

  GoogleMapController get mapController => _mapController;

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }
}
