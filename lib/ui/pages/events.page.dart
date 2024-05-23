import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moroccan_explorer/model/db_connect.dart';
import 'package:moroccan_explorer/ui/widgets/drawer.widget.dart';
import 'package:moroccan_explorer/ui/widgets/home.button.dart';

class EventPage extends StatefulWidget {
  final User? user;

  const EventPage({Key? key, required this.user}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}




class _EventPageState extends State<EventPage> {
  final DBconnect dbConnect = DBconnect();
  String _selectedVille = 'Toutes les villes';

  late User? user;

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  "Morocco",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            DropdownButton<String>(
              value: _selectedVille,
              items: _buildDropDownItems(),
              onChanged: (value) {
                setState(() {
                  _selectedVille = value!;
                });
              },
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.blue,
              ),
              underline: Container(
                height: 2,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
      // Utiliser le widget MyDrawer pour afficher les informations de l'utilisateur
      drawer: MyDrawer(user: user),
      body: FutureBuilder<List<Ville>>(
        future: dbConnect.fetchVilles(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<Event> filteredEvents = [];
            for (var ville in snapshot.data!) {
              if (_selectedVille == 'Toutes les villes' || ville.nom == _selectedVille) {
                filteredEvents.addAll(ville.events!);
              }
            }
            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                          Text(
                                  "Hello, njimateaicha",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 21),
                          ),
                            SizedBox(height: 6),
                            Text(
                              "Explorons ce qui se passe à proximité",
                              style: TextStyle(color: Colors.black, fontSize: 15),
                            )
                          ],
                        ),
                        Spacer(),
                        Container(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.asset(
                                  "images/Aicha.jpg",
                                  height: 40,
                  ),),

                        )
                        
                       
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      "All Events",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    SizedBox(height: 16),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: filteredEvents.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return PopularEventTile(
                          desc: filteredEvents[index].description,
                          date: filteredEvents[index].date,
                          address: filteredEvents[index].lieu,
                          ville: _findVilleName(filteredEvents[index].lieu, snapshot.data!),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar: HomeBottomBar(),
    );
  }

  List<DropdownMenuItem<String>> _buildDropDownItems() {
    List<DropdownMenuItem<String>> items = [];
    items.add(DropdownMenuItem(
      value: 'Toutes les villes',
      child: Text(
        'Toutes les villes',
        style: TextStyle(
          color: Colors.blue,
        ),
      ),
    ));
    items.add(DropdownMenuItem(
      value: 'Fez',
      child: Text(
        'Fez',
        style: TextStyle(
          color: Colors.blue,
        ),
      ),
    ));

    items.add(DropdownMenuItem(
      value: 'Rabat',
      child: Text(
        'Rabat',
        style: TextStyle(
          color: Colors.blue,
        ),
      ),
    ));
    items.add(DropdownMenuItem(
      value: 'Casablanca',
      child: Text(
        'Casablanca',
        style: TextStyle(
          color: Colors.blue,
        ),
      ),
    ));

    return items;
  }

  String extractNameFromEmail(String email) {
    List<String> parts = email.split("@");
    return parts[0];
  }

  String _findVilleName(String adresse, List<Ville> villes) {
    for (var ville in villes) {
      if (adresse.contains(ville.nom)) {
        return ville.nom;
      }
    }
    return '';
  }
}

class PopularEventTile extends StatelessWidget {
  final String desc;
  final String date;
  final String address;
  final String ville;

  PopularEventTile({required this.desc, required this.date, required this.address, required this.ville});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(
          desc,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.date_range),
                SizedBox(width: 8),
                Text(
                  'Date: $date',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.location_on),
                SizedBox(width: 8),
                Text(
                  'Lieu: $address',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.location_city),
                SizedBox(width: 8),
                Text(
                  'Ville: $ville',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}







