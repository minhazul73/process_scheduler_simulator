import 'base_algorithm.dart';
import '../models/process.dart';

class PriorityAlgorithm extends BaseAlgorithm {
  final int priority;

  PriorityAlgorithm(this.priority);

  @override
  List<Process> calculate(List<Process> processes) {
    processes.sort((a, b) => a.arrivalTime.compareTo(b.arrivalTime));
    List<Process> result = [];
    List<Process> readyQueue = [];
    int currentTime = 0;

    while (processes.isNotEmpty || readyQueue.isNotEmpty) {
      while (processes.isNotEmpty && processes.first.arrivalTime <= currentTime) {
        readyQueue.add(processes.removeAt(0));
      }
      readyQueue.sort((a, b) => priority.compareTo(priority));
      if (readyQueue.isNotEmpty) {
        var currentProcess = readyQueue.removeAt(0);
        currentProcess.waitingTime = currentTime - currentProcess.arrivalTime;
        currentTime += currentProcess.burstTime;
        currentProcess.turnaroundTime = currentProcess.waitingTime! + currentProcess.burstTime;
        result.add(currentProcess);
      } else {
        currentTime++;
      }
    }
    return result;
  }
}
