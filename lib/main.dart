import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:moroccan_explorer/firebase_options.dart';
import 'package:moroccan_explorer/ui/pages/chatbot.page.dart';
import 'package:moroccan_explorer/ui/pages/events.page.dart';
import 'package:moroccan_explorer/ui/pages/home.page.dart';
import 'package:moroccan_explorer/ui/pages/login.page.dart';
import 'package:moroccan_explorer/ui/pages/app_provider.dart';
import 'package:moroccan_explorer/ui/pages/qr.page.dart';

import 'package:provider/provider.dart';

// Assurez-vous d'importer correctement votre fichier Settings.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => UiProvider()..init(),
      child: Consumer<UiProvider>(
        builder: (context, UiProvider notifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Dark Theme',
            // By default theme setting, you can also set system
            // when your mobile theme is dark the app also become dark
            themeMode: notifier.isDark ? ThemeMode.dark : ThemeMode.light,

            // Our custom theme applied
            darkTheme:
                notifier.isDark ? notifier.darkTheme : notifier.lightTheme,

            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            routes: {
              "/": (context) => LoginPage(),
              "/qr": (context) =>
                  QrPage(), // Assurez-vous que votre page d'accueil est correctement définie ici
              "/chatbot": (context) => ChatbotPage(),
              "/events": (context) => EventPage(user: null,),
              "/home": (context) => HomePage(),
              "/login": (context) => LoginPage(),
            },
            initialRoute: "/",
          );
        },
      ),
    );
  }
}