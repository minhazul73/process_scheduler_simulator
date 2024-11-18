import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/process.dart';

class ProcessController extends GetxController {
  var processes = <Process>[].obs;

  // Pre-defined processes
  final defaultProcesses = [
    Process(id: 'P1', arrivalTime: 0, burstTime: 5),
    Process(id: 'P2', arrivalTime: 2, burstTime: 3),
    Process(id: 'P3', arrivalTime: 4, burstTime: 1),
  ];

  @override
  void onInit() {
    super.onInit();
    // Add pre-defined processes on initialization
    processes.addAll(defaultProcesses);
  }

  void addProcess(String id, String arrival, String burst) {
  // Sanitize and validate inputs
  id = id.trim();
  if (!id.startsWith('P')) {
    id = 'P$id'; // Add 'P' prefix if not provided
  }

  arrival = arrival.trim();
  burst = burst.trim();

  // Check if arrival and burst times are valid numbers
  if (arrival.isEmpty || burst.isEmpty || int.tryParse(arrival) == null || int.tryParse(burst) == null) {
    Get.snackbar(
      'Invalid Input',
      'Please enter valid numeric values for Arrival Time and Burst Time.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
    return;
  }

  // Convert to integer after validation
  final arrivalTime = int.parse(arrival);
  final burstTime = int.parse(burst);

  // Add sanitized process to the list
  processes.add(Process(id: id, arrivalTime: arrivalTime, burstTime: burstTime));

  Get.snackbar(
    'Process Added',
    'Process $id added successfully!',
    snackPosition: SnackPosition.BOTTOM,
  );
}


  void clearProcesses() {
    processes.clear();
  }

  void simulateFCFS() {
    int currentTime = 0;
    for (var process in processes) {
      if (currentTime < process.arrivalTime) {
        currentTime = process.arrivalTime;
      }
      process.waitingTime = currentTime - process.arrivalTime;
      process.turnaroundTime = process.waitingTime! + process.burstTime;
      currentTime += process.burstTime;
    }
  }
}
