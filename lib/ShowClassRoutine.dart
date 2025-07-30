import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/providers/class_routine_provider.dart';

class ShowClassRoutine extends StatefulWidget {
  const ShowClassRoutine({super.key});

  @override
  State<ShowClassRoutine> createState() => _ShowClassRoutineState();
}

class _ShowClassRoutineState extends State<ShowClassRoutine> {
  final TextEditingController _classNameController = TextEditingController();

  @override
  void dispose() {
    _classNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ClassRoutineProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Class Routine"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search input and button
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _classNameController,
                        decoration: InputDecoration(
                          labelText: 'Class Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_classNameController.text.isNotEmpty) {
                            provider.fetchRoutinesByClass(_classNameController.text.trim());
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          elevation: 5,
                          padding: const EdgeInsets.symmetric(vertical: 14.0),
                          side: BorderSide(color: Colors.teal.shade700),
                          shadowColor: Colors.teal.withOpacity(0.5),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search, size: 20),
                            SizedBox(width: 8.0),
                            Text("Search"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16.0),

            // Show loading / error / data
            Expanded(
              child: Builder(
                builder: (context) {
                  if (provider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                      ),
                    );
                  }
                  if (provider.error != null) {
                    return Center(
                      child: Text(
                        "Error: ${provider.error}",
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    );
                  }
                  if (provider.routines.isEmpty) {
                    return Center(
                      child: Card(
                        color: Colors.teal.shade50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 2,
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "No data found",
                            style: TextStyle(
                              color: Colors.teal,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: provider.routines.length,
                    itemBuilder: (context, index) {
                      final routine = provider.routines[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 3,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          title: const Text('Class Routine'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Day: ${routine.day}'),
                              Text('Section: ${routine.section}'),
                              Text('Subject: ${routine.subject}'),
                              Text('Start Time: ${routine.startTime}'),
                              Text('End Time: ${routine.endTime}'),
                              Text('Teacher: ${routine.teacher}'),
                              Text('Room No: ${routine.roomNo}'),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
