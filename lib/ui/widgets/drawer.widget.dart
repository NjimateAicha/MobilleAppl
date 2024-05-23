import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moroccan_explorer/ui/pages/app_provider.dart';




class MyDrawer extends StatefulWidget {
   final User? user;
  // const MyDrawer({Key? key}) : super(key: key);
   const MyDrawer({Key? key, required this.user}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}class _MyDrawerState extends State<MyDrawer> {
  double value = 0;

  late User? user; // Déclarer user comme une variable de classe

  @override
  void initState() {
    super.initState();
    user = widget.user; // Initialiser user avec la valeur passée depuis MyDrawer
  }

  @override
  Widget build(BuildContext context) {
    final UiProvider uiProvider = Provider.of<UiProvider>(context, listen: false);

              // Fonction pour extraire le nom de l'adresse e-mail
          String extractNameFromEmail(String email) {
            // Divise l'adresse e-mail en deux parties : nom et domaine
            List<String> parts = email.split("@");
            // Retourne la première partie (le nom)
            return parts[0];
          }
   
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Column(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
  radius: 40.0,
  backgroundImage: user != null && user!.photoURL != null
      ? NetworkImage(user!.photoURL!)
      : AssetImage("images/default_avatar.jpg") as ImageProvider,
),

                        SizedBox(height: 5),
Text(
  user?.displayName != null ? user!.displayName! : extractNameFromEmail(user!.email!),
  style: TextStyle(
    color: Colors.black,
    fontSize: 20.0,
  ),
)



                      ],
                    ),
                  ),
                ),
                ListTile(
                  title: Text('Dark Mode', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                  leading: Icon(Icons.dark_mode, color: Colors.black),
                  trailing: Switch(
                    value: uiProvider.isDark,
                    onChanged: (bool newValue) {
                      setState(() {
                        uiProvider.changeTheme();
                      });
                    },
                  ),
                ),
                   
       ListTile(
                  title: Text('Log Out',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                  leading: Icon(Icons.exit_to_app, color: Colors.black),
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/log', (Route<dynamic> route) => false);
                    // Mettre votre logique de déconnexion ici
                  },
  ),



              ],
            ),
          ],
        ),
      ),
    );
  }
}
