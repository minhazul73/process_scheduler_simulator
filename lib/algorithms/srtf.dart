import 'base_algorithm.dart';
import '../models/process.dart';

class SRTFAlgorithm extends BaseAlgorithm {
  @override
  List<Process> calculate(List<Process> processes) {
    processes.sort((a, b) => a.arrivalTime.compareTo(b.arrivalTime));
    List<Process> readyQueue = [];
    int currentTime = 0;

    while (processes.isNotEmpty || readyQueue.isNotEmpty) {
      while (processes.isNotEmpty && processes.first.arrivalTime <= currentTime) {
        readyQueue.add(processes.removeAt(0));
      }

      if (readyQueue.isNotEmpty) {
        readyQueue.sort((a, b) => a.burstTime.compareTo(b.burstTime));
        var currentProcess = readyQueue.first;
        currentProcess.burstTime -= 1;
        currentTime++;

        if (currentProcess.burstTime == 0) {
          readyQueue.remove(currentProcess);
          currentProcess.turnaroundTime = currentTime - currentProcess.arrivalTime;
          currentProcess.waitingTime =
              currentProcess.turnaroundTime! - currentProcess.burstTime;
        }
      } else {
        currentTime++;
      }
    }
    return readyQueue;
  }
}
