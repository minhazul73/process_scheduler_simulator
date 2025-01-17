class Process {
  final String id;
  final int arrivalTime;
  late final int burstTime;
  int? waitingTime;
  int? turnaroundTime;

  Process({
    required this.id,
    required this.arrivalTime,
    required this.burstTime,
  });
}
