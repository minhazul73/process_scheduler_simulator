import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/input_screen.dart';
import 'views/simulation_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Process Scheduler',
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => InputScreen()),
        GetPage(name: '/simulation', page: () => SimulationScreen()),
      ],
    );
  }
}
