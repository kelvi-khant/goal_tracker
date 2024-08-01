import 'package:flutter/material.dart';
import '../models/goal.dart';
import '../services/storage_service.dart';
import '../widgets/custom_button.dart';

class GoalSettingScreen extends StatefulWidget {
  final Goal? goal;

  GoalSettingScreen({this.goal});

  @override
  _GoalSettingScreenState createState() => _GoalSettingScreenState();
}

class _GoalSettingScreenState extends State<GoalSettingScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  bool _isEditing = false; // Track whether editing an existing goal

  @override
  void initState() {
    super.initState();
    if (widget.goal != null) {
      _isEditing = true;
      _title = widget.goal!.title;
      _description = widget.goal!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Goal' : 'Add Goal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  _description = value!;
                },
              ),
              SizedBox(height: 20),
              CustomButton(
                label: _isEditing ? 'Update Goal' : 'Add Goal',
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Goal newGoal = Goal(
                      title: _title,
                      description: _description,
                    );

                    final StorageService storageService = StorageService();
                    List<Goal> goals = await storageService.getGoals();

                    if (_isEditing) {
                      // Update existing goal
                      int existingIndex = goals.indexWhere((goal) => goal.title == widget.goal!.title);
                      if (existingIndex != -1) {
                        goals[existingIndex] = newGoal;
                      }
                    } else {
                      // Add new goal
                      goals.add(newGoal);
                    }

                    await storageService.saveGoals(goals);

                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
