//import 'package:flutter/material.dart';
//import 'dart:html';
import 'dart:convert';
import 'package:http/http.dart' as http;


class DBconnect {

  final url = Uri.parse('https://tourisme-3d54a-default-rtdb.firebaseio.com/.json');
  

   Future<List<Ville>> fetchVilles() async {
    return http.get(url).then((response) {
      var data = json.decode(response.body) as Map<String, dynamic>;
      var villesData = data['villes'] as Map<String, dynamic>;
      List<Ville> newVilles = [];
      villesData.forEach((key, value) {
        var newVille = Ville(
          nom: value['nom'],
          description: value['description'],
          url: value['url'],
          bestPlaces: (value['best_places'] as Map<String, dynamic>).values
              .map((placeData) => Place(
                    nom: placeData['nom'],
                    description: placeData['description'],
                    url: placeData['url'],
                  ))
              .toList(),
          events:(value['Event'] as Map<String, dynamic>).values
              .map((eventData) => Event(
                  date: eventData['date'],
                  description: eventData['description'],
                  lieu: eventData['lieu'],
                  ))
              .toList(),


               questions: (value['questions'] as Map<String, dynamic>).entries
              .map((questionEntry) => Question(
               
                    title: questionEntry.value['title'],
                    description: questionEntry.value['description'],
                    reponse: questionEntry.value['reponse'],
                    url: questionEntry.value['url'],
                  ))
              .toList(),
        );
        newVilles.add(newVille);
      });
      
      return newVilles;
    });
  }
}
class Ville {
  final String nom;
  final String description;
  final String url;
  final List<Place> bestPlaces;
   final List<Event> events;
    final List<Question> questions;
   

  Ville({
    required this.nom,
    required this.description,
    required this.url,
    required this.bestPlaces,
    required this.events,
      required this.questions,


  });
}


class Event {
  final String lieu;
  final String description;
  final String date;


  Event({
    required this.lieu,
    required this.description,
    required this.date,
  });
}





class Place {
  final String nom;
  final String description;
  final String url;


  Place({
    required this.nom,
    required this.description,
    required this.url,
  });
}





class Question {
 // Utilisez la clé associée à chaque question comme ID
  final String title;
  final String description;
  final dynamic reponse ;
  final String url;

  Question({
   
    required this.title,
    required this.description,
    required this.reponse,
    required this.url,
  });
}



