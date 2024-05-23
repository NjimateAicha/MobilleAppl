import 'package:flutter/material.dart';
import 'package:moroccan_explorer/model/db_connect.dart';
import 'package:moroccan_explorer/ui/pages/best_place.dart';
import 'package:moroccan_explorer/ui/widgets/home.button.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:convert';

class QrPage extends StatefulWidget {
  const QrPage({super.key});

  @override
  State<QrPage> createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  late QRViewController _controller;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: QRView(
                key: _qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Text('Scan a QR code'),
              ),
            ),
          ],
        ),
         bottomNavigationBar:HomeBottomBar(),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _controller = controller;
      _controller.scannedDataStream.listen((scanData) {
        if (scanData.code!.isNotEmpty) {
          final parsedJson = jsonDecode(scanData.code!);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BestPage(
                  bestPlace: Place(
                      nom: parsedJson["nom"],
                      description: parsedJson["description"],
                      url: parsedJson["url"]))));
        }
        // Handle the scanned data as desired
      });
    });
  }
}