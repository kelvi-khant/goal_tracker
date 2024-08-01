import 'package:flutter/material.dart';
import '../models/goal.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final List<Goal> goals;

  ProgressIndicatorWidget({required this.goals});

  @override
  Widget build(BuildContext context) {
    int completedGoals = goals.where((goal) => goal.isCompleted).length;
    double progress = goals.isEmpty ? 0 : completedGoals / goals.length;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Goals Progress',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            color: Colors.pink,
          ),
          SizedBox(height: 5),
          Text(
            '${(progress * 100).toStringAsFixed(1)}% Completed',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
