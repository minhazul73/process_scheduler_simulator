import '../models/process.dart';

abstract class BaseAlgorithm {
  List<Process> calculate(List<Process> processes);
}
