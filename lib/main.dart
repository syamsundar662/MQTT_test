import 'package:flutter/material.dart';
import 'package:mqtt_test/services/mqtt_services.dart';
import 'package:mqtt_test/view%20model/home_view_model.dart';
import 'package:mqtt_test/view/home.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(mqttService: MQTTService()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
        ),
        home: const Home(),
      ),
    );
  }
}