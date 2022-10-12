import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_tts/flutter_tts.dart';

// main
void main() {
  runApp(const MyApp());
}

// MyApp
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: 'Qr Code leitor',
        home: HomeScreen(),
        debugShowCheckedModeBanner: false);
  }
}

// Main Page
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String data = "";
  String _scanBarcode = "";
  FlutterTts flutterTts = FlutterTts();
  bool lido = false;

  Future<void> leituraQR() async {
    if (lido) {
      await flutterTts.speak("QR code lido");
      Vibration.vibrate(duration: 1000);
      setState(() {
        lido = false;
      });
    }
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', '', false, ScanMode.QR);
    }
    await flutterTts.speak("QR code lido");
    Vibration.vibrate(duration: 1000);
    setState(() {
      _scanBarcode = barcodeScanRes;
    });
    Future.delayed(const Duration(seconds: 3)).then((value) => scanQR());
  }

  @override
  void initState() {
    scanQR();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Qr Code"), centerTitle: true),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                "Dando instruções",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
