import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/process.dart';
import '../algorithms/base_algorithm.dart';
import '../algorithms/fcfs.dart';
import '../algorithms/sjf.dart';
import '../algorithms/priority.dart';
import '../algorithms/rr.dart';
import '../algorithms/srtf.dart';

class ProcessController extends GetxController {
  var processes = <Process>[].obs;
  var selectedAlgorithm = ''.obs;
  int? priority;
  int? quantum; // Nullable to store quantum for RR
  RxBool needsPriority = false.obs; // For managing Priority visibility
  RxBool needsQuantum = false.obs; // For managing Quantum visibility

  void addProcess(Process process) {
    processes.add(process);
  }

  Future<void> calculate(String algorithm)  async {
    selectedAlgorithm.value = algorithm;
    if (selectedAlgorithm.value.isEmpty) {
      throw Exception('No algorithm selected');
    }

    BaseAlgorithm selected;

    switch (selectedAlgorithm.value) {
      case 'FCFS':
        selected = FCFSAlgorithm();
        break;
      case 'SJF':
        selected = SJFAlgorithm();
        break;
      case 'Priority':
        if (priority == null || priority! <= 0) {
          throw Exception('Priority is required for Priority and must be greater than 0.');
        }
        selected = PriorityAlgorithm(priority!);
        break;
      case 'Round Robin':
        if (quantum == null || quantum! <= 0) {
          throw Exception('Quantum is required for Round Robin and must be greater than 0.');
        }
        selected = RoundRobinAlgorithm(quantum!);
        break;
      case 'SRTF':
        selected = SRTFAlgorithm();
        break;
      default:
        throw Exception('Algorithm not supported');
    }

    // Execute algorithm and update processes
    List<Process> calculatedProcesses = selected.calculate(processes);
    print("Calculated processes: $calculatedProcesses");
    processes.clear();
    print("Processes after clear: $processes");

    for (var process in calculatedProcesses) {
      print("Adding process: $process");
      processes.add(process);
    }
    print("Updated processes: $processes");
  }

  void updateFieldVisibility(String algorithm) {
    // Dynamically toggle fields based on the algorithm
    needsPriority.value = algorithm == 'Priority';
    needsQuantum.value = algorithm == 'Round Robin';
    update(); // Notify UI about changes
  }

  void generateSampleData() {
    processes.addAll([
      Process(id: 'P1', arrivalTime: 0, burstTime: 4),
      Process(id: 'P2', arrivalTime: 1, burstTime: 3),
      Process(id: 'P3', arrivalTime: 2, burstTime: 1),
    ]);
  }

  void clearProcesses() {
    processes.clear();
  }
}

























// class ProcessController extends GetxController {
//   var processes = <Process>[].obs;
//
//   // Pre-defined processes
//   final defaultProcesses = [
//     Process(id: 'P1', arrivalTime: 0, burstTime: 5),
//     Process(id: 'P2', arrivalTime: 2, burstTime: 3),
//     Process(id: 'P3', arrivalTime: 4, burstTime: 1),
//   ];
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Add pre-defined processes on initialization
//     processes.addAll(defaultProcesses);
//   }
//
//   void addProcess(String id, String arrival, String burst) {
//     // Sanitize and validate inputs
//     id = id.trim();
//     if (!id.startsWith('P')) {
//       id = 'P$id'; // Add 'P' prefix if not provided
//     }
//
//     arrival = arrival.trim();
//     burst = burst.trim();
//
//     // Check if arrival and burst times are valid numbers
//     if (arrival.isEmpty ||
//         burst.isEmpty ||
//         int.tryParse(arrival) == null ||
//         int.tryParse(burst) == null) {
//       Get.snackbar(
//         'Invalid Input',
//         'Please enter valid numeric values for Arrival Time and Burst Time.',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//       return;
//     }
//
//     // Convert to integer after validation
//     final arrivalTime = int.parse(arrival);
//     final burstTime = int.parse(burst);
//
//     // Add sanitized process to the list
//     processes
//         .add(Process(id: id, arrivalTime: arrivalTime, burstTime: burstTime));
//
//     Get.snackbar(
//       'Process Added',
//       'Process $id added successfully!',
//       snackPosition: SnackPosition.BOTTOM,
//     );
//   }
//
//   void clearProcesses() {
//     processes.clear();
//   }
//
//   void simulateFCFS() {
//     int currentTime = 0;
//     for (var process in processes) {
//       if (currentTime < process.arrivalTime) {
//         currentTime = process.arrivalTime;
//       }
//       process.waitingTime = currentTime - process.arrivalTime;
//       process.turnaroundTime = process.waitingTime! + process.burstTime;
//       currentTime += process.burstTime;
//     }
//   }
// }
