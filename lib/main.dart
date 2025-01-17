import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/home.dart';
import 'views/input_screen.dart';
import 'views/simulation_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Process Scheduler',
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const Home()),
        GetPage(name: '/input', page: () => InputScreen()),
        GetPage(name: '/simulation', page: () => SimulationScreen()),
      ],
    );
  }
}
