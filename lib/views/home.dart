import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:process_scheduler_simulator/controllers/process_controller.dart';

import 'input_screen.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Algorithm Selector')),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        children: [
          _buildAlgorithmTile(context, 'FCFS'),
          _buildAlgorithmTile(context, 'SJF'),
          _buildAlgorithmTile(context, 'Priority'),
          _buildAlgorithmTile(context, 'Round Robin'),
          _buildAlgorithmTile(context, 'SRTF'),
        ],
      ),
    );
  }

  Widget _buildAlgorithmTile(BuildContext context, String algorithm) {
    ProcessController processController = Get.put(ProcessController());
    return GestureDetector(
      onTap: () {
        processController.updateFieldVisibility(algorithm);
        Get.to(() => InputScreen(), arguments: algorithm);
      },
      child: Card(
        child: Center(child: Text(algorithm, style: const TextStyle(fontSize: 18))),
      ),
    );
  }
}
