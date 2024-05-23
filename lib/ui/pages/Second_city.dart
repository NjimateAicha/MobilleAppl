import 'package:flutter/material.dart';
import 'package:moroccan_explorer/consts.dart';
import 'package:moroccan_explorer/model/db_connect.dart';
import 'package:moroccan_explorer/ui/pages/Quiz_page.dart';
import 'package:moroccan_explorer/ui/pages/best_place.dart';
import 'package:moroccan_explorer/ui/widgets/home.button.dart';

import 'package:weather/weather.dart';

// ignore: must_be_immutable
class SecondPage extends StatelessWidget {
  void _handleCityTap(BuildContext context, Place bestPlace) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BestPage(bestPlace: bestPlace)),
    );
  }

   List<Place> bestPlaces = [];

  final String cityName;

  SecondPage({Key? key, required this.cityName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Weather? _weather;

    final WeatherFactory _wf = WeatherFactory(apiKey);
    _wf.currentWeatherByCityName(cityName).then((w) {
      _weather = w;
    });

    return FutureBuilder<List<Ville>>(
      future: DBconnect().fetchVilles(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
         if (snapshot.hasError) {
           return const Text('Erreur de chargement des données');
         } else {
           List<Ville>? data = snapshot.data;
           if (data == null || data.isEmpty) {
                return Container(
                color: Colors.white,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 12.0),
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.amber),
                ),
              );
           }
   

          // Trouver la ville correspondant au nom donné
          Ville? selectedCity;
          for (Ville ville in data) {
            if (ville.nom == cityName) {
              selectedCity = ville;
              bestPlaces = selectedCity.bestPlaces;
              break;
            }
          
          }

          if (selectedCity == null) {
            return Text('La ville sélectionnée n\'existe pas');
          }

          // Afficher les données de la ville sélectionnée
          return Scaffold(
             appBar:  AppBar(
  backgroundColor: Colors.white,
  title: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "Morocco",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.black, // Couleur du texte
        ),
      ),
      SizedBox(width: 8), // Espacement entre le texte et l'image
      Container(
        padding: EdgeInsets.all(6), // Ajustez le padding selon vos besoins
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
            ),
          ],
          borderRadius: BorderRadius.circular(15),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image(
            image: AssetImage('images/m.jpg'),
            width: 28,
            height: 28,
            fit: BoxFit.cover,
          ),
        ),
      ),
    ],
  ),
  centerTitle: true,
  automaticallyImplyLeading: false,
),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                 
                      Container(
                        height: 400,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(
                            image: AssetImage("images/${selectedCity.url}"),
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(
                            color: Colors.white,
                            width: 4.0,
                          ),
                        ),
                      ),
                         Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    Row(
      children: [
        Image.asset(
          'images/meteo.jpeg',
          width: 30,
        ),
        SizedBox(width: 5),

        _currentTemp(_weather), // Température actuelle
      ],
    ),
    
ElevatedButton(
  onPressed: () {
    // Naviguer vers la page du quiz
  Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => QuizPage(selectedCity: selectedCity!)),
);


  },
  child: Text('Passer un quiz'),
),

    // ElevatedButton(
    //   onPressed: () {
    //     // Naviguer vers la page du quiz
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(builder: (context) => QuizPage()),
    //     );
    //   },
    //   child: Text('Passer un quiz'),
    // ),
  ],
),

                      
                      SizedBox(height: 30),
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "A Propos:",
                              style: TextStyle(
                            color: Colors.black,
                             fontFamily: 'Roboto',
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Description de la ville : ${selectedCity.description}",
                              style: TextStyle(
                                  color: Color(0xff686771),
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                              
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: Text(
                          "Places à Visiter",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 200,
                        child: ListView.builder(
                          itemCount: selectedCity.bestPlaces!.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            var place = selectedCity?.bestPlaces![index];
                            return GestureDetector(
                              onTap: () {
                                // Utiliser l'index pour personnaliser l'action pour chaque image
                                _handleCityTap(context, bestPlaces[index]);
                              },
                              child: Container(
                                width: 130,
                                padding: EdgeInsets.all(20),
                                margin: index % 2 == 0
                                    ? EdgeInsets.only(left: 10, top: 20)
                                    : EdgeInsets.only(left: 10, top: 20),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 4.0,
                                  ),
                                  image: DecorationImage(
                                    image: AssetImage("images/${place?.url}"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                  
                                    Spacer(),
                                    Container(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        place!.nom!,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                transform: index % 2 == 0
                                    ? Matrix4.translationValues(0.0, -20.0, 0.0)
                                    : Matrix4.identity(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: HomeBottomBar(),
          );
        }
      },
    );
  }


  Widget _currentTemp(Weather? _weather) {
    return Text(
      "${_weather?.temperature?.celsius?.toStringAsFixed(0)}°C",
      style: const TextStyle(
       
         fontFamily: 'Roboto',
                           
        color: Colors.black,
        fontSize: 25,
        fontWeight: FontWeight.w200,
      ),
    );
  }
}









