import 'base_algorithm.dart';
import '../models/process.dart';

class RoundRobinAlgorithm extends BaseAlgorithm {
  final int timeQuantum;

  RoundRobinAlgorithm(this.timeQuantum);

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
        var currentProcess = readyQueue.removeAt(0);
        if (currentProcess.burstTime <= timeQuantum) {
          currentTime += currentProcess.burstTime;
          currentProcess.burstTime = 0;
        } else {
          currentTime += timeQuantum;
          currentProcess.burstTime -= timeQuantum;
        }

        currentProcess.waitingTime =
            currentTime - currentProcess.arrivalTime - currentProcess.burstTime;
        currentProcess.turnaroundTime =
            currentProcess.waitingTime! + currentProcess.burstTime;
        if (currentProcess.burstTime > 0) {
          readyQueue.add(currentProcess);
        }
      } else {
        currentTime++;
      }
    }
    return readyQueue;
  }
}
