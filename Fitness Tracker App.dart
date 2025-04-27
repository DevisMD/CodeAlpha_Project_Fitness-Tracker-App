import 'package:flutter/material.dart';

void main() {
  runApp(const FitnessTrackerApp());
}

class FitnessTrackerApp extends StatelessWidget {
  const FitnessTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Tracker',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const FitnessHomePage(),
    );
  }
}

class Workout {
  final String type;
  final int duration; // in minutes
  final DateTime date;

  Workout({required this.type, required this.duration, required this.date});
}

class FitnessHomePage extends StatefulWidget {
  const FitnessHomePage({super.key});

  @override
  State<FitnessHomePage> createState() => _FitnessHomePageState();
}

class _FitnessHomePageState extends State<FitnessHomePage> {
  final List<Workout> _workouts = [];

  void _addWorkout(String type, int duration) {
    setState(() {
      _workouts.add(Workout(
        type: type,
        duration: duration,
        date: DateTime.now(),
      ));
    });
  }

  void _showAddWorkoutDialog() {
    final typeController = TextEditingController();
    final durationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Workout'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: typeController,
              decoration: const InputDecoration(labelText: 'Workout Type (e.g., Running, Yoga)'),
            ),
            TextField(
              controller: durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Duration (minutes)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final type = typeController.text.trim();
              final duration = int.tryParse(durationController.text.trim()) ?? 0;
              if (type.isNotEmpty && duration > 0) {
                _addWorkout(type, duration);
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutTile(Workout workout) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        title: Text(workout.type),
        subtitle: Text('Duration: ${workout.duration} minutes\nDate: ${workout.date.toLocal().toString().split(' ')[0]}'),
        leading: const Icon(Icons.fitness_center),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Tracker'),
      ),
      body: _workouts.isEmpty
          ? const Center(child: Text('No workouts recorded yet.'))
          : ListView.builder(
              itemCount: _workouts.length,
              itemBuilder: (context, index) => _buildWorkoutTile(_workouts[index]),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddWorkoutDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
