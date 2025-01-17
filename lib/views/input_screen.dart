import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/process_controller.dart';
import '../models/process.dart';
import '../widgets/custom_input_field.dart';
import 'simulation_screen.dart';

class InputScreen extends StatelessWidget {
  final String algorithm = Get.arguments; // Algorithm passed from HomeScreen

  final processController = Get.put(ProcessController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final idController = TextEditingController();
  final arrivalController = TextEditingController();
  final burstController = TextEditingController();
  final priorityController = TextEditingController();
  final quantumController = TextEditingController();

  InputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Process Input',
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomInputField(
                  label: 'Process ID',
                  hintText: 'e.g., P1 or 1',
                  controller: idController,
                  validator: (value) {
                    if (value == null || value == 'P' || value.trim().isEmpty) {
                      return 'Valid Process ID is required';
                    }
                    return null;
                  },
                ),
                CustomInputField(
                  label: 'Arrival Time',
                  hintText: 'e.g., 0 or 2',
                  controller: arrivalController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Arrival Time is required';
                    }
                    if (int.tryParse(value) == null || int.parse(value) < 0) {
                      return 'Enter a valid non-negative integer';
                    }
                    return null;
                  },
                ),
                CustomInputField(
                  label: 'Burst Time',
                  hintText: 'e.g., 5 or 3',
                  controller: burstController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Burst Time is required';
                    }
                    if (int.tryParse(value) == null || int.parse(value) <= 0) {
                      return 'Enter a valid positive integer';
                    }
                    return null;
                  },
                ),
                Obx(() =>
                  Visibility(
                    visible: processController.needsPriority.value,
                    child: CustomInputField(
                      label: 'Priority',
                      hintText: 'e.g., 5 or 3',
                      controller: priorityController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Priority is required';
                        }
                        if (int.tryParse(value) == null || int.parse(value) <= 0) {
                          return 'Enter a valid positive integer';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Obx(() =>
                  Visibility(
                    visible: processController.needsQuantum.value,
                    child: CustomInputField(
                      label: 'Quantum Time',
                      hintText: 'e.g., 5 or 3',
                      controller: quantumController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Quantum Time is required';
                        }
                        if (int.tryParse(value) == null || int.parse(value) <= 0) {
                          return 'Enter a valid positive integer';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          final id = idController.text.trim();
                          final arrivalTime = int.parse(arrivalController.text.trim());
                          final burstTime = int.parse(burstController.text.trim());
                          final priority = priorityController.text.trim().isNotEmpty
                              ? int.parse(priorityController.text.trim())
                              : -1;
                          final quantum = quantumController.text.trim().isNotEmpty
                              ? int.parse(quantumController.text.trim())
                              : -1;
            
                          processController.addProcess(Process(
                            id: id.startsWith('P') ? id : 'P$id',
                            arrivalTime: arrivalTime,
                            burstTime: burstTime,
                          ));
                          if (processController.needsPriority.value) {
                            processController.priority = priority;
                          }
                          if (processController.needsQuantum.value) {
                            processController.quantum = quantum;
                          }
                          print("Processes: ${processController.processes}");
                          idController.clear();
                          arrivalController.clear();
                          burstController.clear();
                          priorityController.clear();
                          quantumController.clear();
                        }
                      },
                      child: const Text('Add Process'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        processController.generateSampleData();
                        Get.to(() => SimulationScreen());
                      },
                      child: const Text('Sample Data'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                    onPressed: () async {
                      if (processController.processes.isEmpty) {
                        Get.snackbar('Error', 'No processes to simulate!',
                            snackPosition: SnackPosition.BOTTOM);
                        return;
                      }
                      try {
                        // Perform the calculation and wait for it to complete
                        await processController.calculate(algorithm);

                        print('Processes before navigating to simulation: ${processController.processes}');
                        // Navigate to the simulation screen after calculation
                        if (processController.processes.isNotEmpty) {
                          Get.to(() => SimulationScreen());
                        } else {
                          Get.snackbar('Error', 'Failed to simulate processes!',
                              snackPosition: SnackPosition.BOTTOM);
                        }
                      } catch (e) {
                        // Show error if calculation fails
                        Get.snackbar('Error', e.toString(),
                            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
                      }
                    },
                    child: const Text('Simulate'),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 300,
                  child: Obx(
                        () => ListView.builder(
                      itemCount: processController.processes.length,
                      itemBuilder: (context, index) {
                        final process = processController.processes[index];
                        return ListTile(
                          title: Text(process.id),
                          subtitle: Text(
                              'Arrival: ${process.arrivalTime}, Burst: ${process.burstTime}'),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
