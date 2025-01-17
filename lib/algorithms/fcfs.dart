import 'base_algorithm.dart';
import '../models/process.dart';

class FCFSAlgorithm extends BaseAlgorithm {
  @override
  List<Process> calculate(List<Process> processes) {
    processes.sort((a, b) => a.arrivalTime.compareTo(b.arrivalTime));
    int currentTime = 0;

    for (var process in processes) {
      process.waitingTime = currentTime - process.arrivalTime;
      currentTime += process.burstTime;
      process.turnaroundTime = process.waitingTime! + process.burstTime;
      print('FCFS= Process ID: ${process.id}, Waiting Time: ${process.waitingTime}, Turnaround Time: ${process.turnaroundTime}');
    }
    print('Returning processes from FCFS: $processes'); // Add this line
    return processes;
  }
}
