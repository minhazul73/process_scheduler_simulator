import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/process_controller.dart';
import '../widgets/custom_input_field.dart';

class InputScreen extends StatelessWidget {
  final processController = Get.put(ProcessController());
  final idController = TextEditingController();
  final arrivalController = TextEditingController();
  final burstController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Process Input', style: TextStyle(color: Colors.white),),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomInputField(
                label: 'Process ID',
                hintText: 'e.g., P1 or 1',
                controller: idController,
              ),
              CustomInputField(
                label: 'Arrival Time',
                hintText: 'e.g., 0 or 2',
                controller: arrivalController,
                keyboardType: TextInputType.number,
              ),
              CustomInputField(
                label: 'Burst Time',
                hintText: 'e.g., 5 or 3',
                controller: burstController,
                keyboardType: TextInputType.number,
              ),

              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final id = idController.text;
                  final arrival = arrivalController.text;
                  final burst = burstController.text;

                  // Call the addProcess method with raw user inputs
                  processController.addProcess(id, arrival, burst);

                  // Clear input fields
                  idController.clear();
                  arrivalController.clear();
                  burstController.clear();
                },
                child: Text('Add Process'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Get.toNamed('/simulation'),
                child: Text('Simulate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
