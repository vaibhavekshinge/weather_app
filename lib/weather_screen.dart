
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/secrets.dart';

import 'additional_info.dart';
import 'hourly_updates_card.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

  Future<Map<String, dynamic>> getCurrentWeather () async{
    try {
      String cityName = "Kolhapur";

      final res = await http.get(
        Uri.parse("https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey"),
      );

      final data = jsonDecode(res.body);

      if(data['cod'] != '200'){
        throw 'an unexcepted error occur';
      }
      return data;
      
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(


      appBar: AppBar(
        title: const Text('Weather App',
        style: TextStyle(fontWeight: FontWeight.bold
        ),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            setState(() {});
          }, 
          icon:const Icon(Icons.refresh),
          )
        ],
      ),


      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {

          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child:  CircularProgressIndicator.adaptive());
          }
          if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;
          final currTemp = data['list'][0]['main']['temp'];
          final currSky = data['list'][0]['weather'][0]['main'];
          final currPressure = data['list'][0]['main']['pressure'];
          final currHumidity = data['list'][0]['main']['humidity'];
          final currWindSpeed = data['list'][0]['wind']['speed'];

          return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //main card
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child:ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 10,
                        sigmaY: 10,
                      ),
                      child:  Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                        
                            Text(
                              '$currTemp K',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16,),
                        
                             Icon(
                             currSky == 'Clouds' || currSky == 'Rain'
                             ? Icons.cloud :Icons.sunny,
                              size: 64,
                            ),
                            const SizedBox(height: 16,),
                        
                             Text(
                              "$currSky",
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
             const SizedBox(height: 20,),
        
             const Text(
              "Hourly Forecast",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
             ),
             const SizedBox(height: 8),
        
          
              //weather forecast cards
              //  SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children: [
              //       for(int i=0; i<5; i++)
                      // HourlyUpdatesCard(
                      // time: data['list'][i+1]['dt'].toString(),
                      // temp: data['list'][i+1]['main']['temp'].toString(),
                      // icon: data['list'][i+1]['weather'][0]['main'] == 'Clouds'
                      // || data['list'][i+1]['weather'][0]['main'] == 'Rain'
                      // ? Icons.cloud : Icons.sunny,
                      // ),
              //     ],
              //   ),
              // ),

              SizedBox(
                height: 120,
                child: ListView.builder(
                  itemCount: 5,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index){
                    final time = DateTime.parse(data['list'][index+1]['dt_txt'].toString());
                    return HourlyUpdatesCard(
                        time: DateFormat.j().format(time),
                        temp: data['list'][index+1]['main']['temp'].toString(),
                        icon: data['list'][index+1]['weather'][0]['main'] == 'Clouds'
                        || data['list'][index+1]['weather'][0]['main'] == 'Rain'
                        ? Icons.cloud : Icons.sunny,
                        );
                  },
                ),
              ),
              const SizedBox(height: 20,),
          
              //additional info
              const Text(
              "Additional Information",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
             ),
             const SizedBox(height: 8,),
        
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                 AdditionalInfo(
                  icon: Icons.water_drop,
                  label: 'Humidity',
                  value: '$currHumidity%'
                ),
                 AdditionalInfo(
                  icon: Icons.air,
                  label: 'Wind Speed',
                  value: '$currWindSpeed m/s',
                ),
                AdditionalInfo(
                  icon: Icons.beach_access,
                  label: 'Pressure',
                  value: '$currPressure hPa',
                ),
              ],
            ),
          
            ],
          ),
        );
        },
      ),
    );
  }
}
