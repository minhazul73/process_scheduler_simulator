import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/process_controller.dart';

class SimulationScreen extends StatelessWidget {
  final ProcessController processController = Get.find<ProcessController>();
  final RxBool isAnimationReady = false.obs; // Reactive variable for animation
  final RxString selectedProjection = 'Turnaround Time'.obs; // Track the selected projection

  SimulationScreen({super.key}) {
    // Delay the animation trigger by 500ms
    Future.delayed(const Duration(milliseconds: 500), () {
      isAnimationReady.value = true;
    });
  }

  // Function to get the correct value based on the selected projection
  double getProjectionValue(String projection, process) {
    switch (projection) {
      case 'Turnaround Time':
        return process.turnaroundTime?.toDouble() ?? 0;
      case 'Waiting Time':
        return process.waitingTime?.toDouble() ?? 0;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Simulation',
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Obx(() {
        if (processController.processes.isEmpty) {
          return const Center(
            child: Text(
              'No processes to simulate. \nAdd processes first.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Buttons to switch between projections
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => selectedProjection.value = 'Turnaround Time',
                    child: const Text('Turnaround Time'),
                  ),
                  ElevatedButton(
                    onPressed: () => selectedProjection.value = 'Waiting Time',
                    child: const Text('Waiting Time'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Display the chart when animation is ready
              Expanded(
                child: Obx(() {
                  if (!isAnimationReady.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Get the correct values based on the selected projection
                  return BarChart(
                    BarChartData(
                      maxY: processController.processes.isEmpty
                          ? 5.0 // Default maxY if no processes are present
                          : processController.processes
                          .map((p) => getProjectionValue(selectedProjection.value, p))
                          .reduce((a, b) => a > b ? a : b)
                          .toDouble() +
                          2, // Add padding at the top
                      minY: 0,
                      barGroups: processController.processes.map((process) {
                        return BarChartGroupData(
                          x: int.tryParse(process.id.replaceAll('P', '')) ?? 0,
                          barRods: [
                            BarChartRodData(
                              toY: getProjectionValue(selectedProjection.value, process),
                              width: 12,
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(4),
                              backDrawRodData: BackgroundBarChartRodData(
                                show: true,
                                toY: 0,
                                color: Colors.grey.shade200,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          tooltipMargin: 8,
                          tooltipRoundedRadius: 10,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final process = processController.processes[groupIndex];
                            return BarTooltipItem(
                              'Process ${process.id}\n'
                                  '${selectedProjection.value}: ${getProjectionValue(selectedProjection.value, process)}',
                              const TextStyle(color: Colors.white),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(value.toInt().toString());
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Text('P${value.toInt()}');
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                    ),
                    swapAnimationDuration: const Duration(milliseconds: 800),
                  );
                }),
              ),
              Text(
                "${selectedProjection.value} Chart",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed('/results');
                  processController.clearProcesses();
                },
                child: const Text('HomePage'),
              ),
            ],
          ),
        );
      }),
    );
  }
}
