import 'package:flutter/material.dart';
import 'package:moroccan_explorer/model/db_connect.dart';
import 'package:moroccan_explorer/ui/widgets/home.button.dart';

import 'package:moroccan_explorer/ui/pages/best_place.dart';

class Besty extends StatelessWidget {
  final String categoryName;

  const Besty({Key? key, required this.categoryName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          categoryName,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<Ville>>(
        future: DBconnect().fetchVilles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final villes = snapshot.data ?? [];
            final bestPlaces = <Place>[];

            // Parcourir toutes les villes et extraire les meilleures places
            villes.forEach((ville) {
              if (categoryName == "Best Places") {
                bestPlaces.addAll(ville.bestPlaces);
              }
            });

            if (bestPlaces.isEmpty) {
              return Center(
                child: Text('Aucune meilleure place disponible'),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0), // Ajout de padding autour de toute la page
                    child: ListView.builder(
                      itemCount: (bestPlaces.length / 2).ceil(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  _handleCityTap(context, bestPlaces[index * 2]);
                                },
                                child: Container(
                                  height: 150,
                                  padding: EdgeInsets.all(20),
                                  margin: EdgeInsets.only(left: 10, top: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(10), // ajout de bord arrondi
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2.0,
                                    ),
                                    image: DecorationImage(
                                      image: AssetImage("images/${bestPlaces[index * 2].url}"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Spacer(),
                                      Container(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          bestPlaces[index * 2].nom!,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16, // réduction de la taille de la police
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (index * 2 + 1 < bestPlaces.length) {
                                    _handleCityTap(context, bestPlaces[index * 2 + 1]);
                                  }
                                },
                                child: Container(
                                  height: 150,
                                  padding: EdgeInsets.all(20),
                                  margin: EdgeInsets.only(left: 10, top: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(10), // ajout de bord arrondi
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2.0,
                                    ),
                                    image: bestPlaces.length > index * 2 + 1
                                        ? DecorationImage(
                                            image: AssetImage(
                                                "images/${bestPlaces[index * 2 + 1].url}"),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: Column(
                                    children: [
                                      Spacer(),
                                      if (bestPlaces.length > index * 2 + 1)
                                        Container(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            bestPlaces[index * 2 + 1].nom!,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16, // réduction de la taille de la police
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                HomeBottomBar(), // Afficher le pied de page
              ],
            );
          }
        },
      ),
    );
  }

  void _handleCityTap(BuildContext context, Place place) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BestPage(bestPlace: place)),
    );
  }
}
