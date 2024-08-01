import 'package:flutter/material.dart';
import 'goal_setting_screen.dart';
import 'goal_detail_screen.dart';
import '../models/goal.dart';
import '../services/storage_service.dart';
import '../widgets/progress_indicator.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Goal> _goals = [];
  List<Goal> _filteredGoals = [];
  final StorageService _storageService = StorageService();
  bool _showCompleted = true;
  bool _showImportant = true;

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    List<Goal> goals = await _storageService.getGoals();
    setState(() {
      _goals = goals;
      _applyFilters();
    });
  }

  void _applyFilters() {
    setState(() {
      _filteredGoals = _goals.where((goal) {
        if (!_showCompleted && goal.isCompleted) {
          return false;
        }
        if (!_showImportant && goal.isImportant) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Goal Tracker'),
        actions: [
          IconButton(
            icon: Icon(_showCompleted ? Icons.check_box : Icons.check_box_outline_blank),
            onPressed: () {
              setState(() {
                _showCompleted = !_showCompleted;
                _applyFilters();
              });
            },
          ),
          IconButton(
            icon: Icon(_showImportant ? Icons.star : Icons.star_border),
            onPressed: () {
              setState(() {
                _showImportant = !_showImportant;
                _applyFilters();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          ProgressIndicatorWidget(goals: _goals),
          Expanded(
            child: _filteredGoals.isEmpty
                ? Center(child: Text('No goals set.'))
                : ListView.builder(
              itemCount: _filteredGoals.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _filteredGoals[index].title,
                    style: TextStyle(
                      fontWeight: _filteredGoals[index].isImportant
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(_filteredGoals[index].description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          _filteredGoals[index].isCompleted
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                        ),
                        onPressed: () async {
                          setState(() {
                            _filteredGoals[index].isCompleted = !_filteredGoals[index].isCompleted;
                            _applyFilters();
                          });
                          await _storageService.saveGoals(_goals);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          _filteredGoals[index].isImportant
                              ? Icons.star
                              : Icons.star_border,
                        ),
                        onPressed: () async {
                          setState(() {
                            _filteredGoals[index].isImportant = !_filteredGoals[index].isImportant;
                            _applyFilters();
                          });
                          await _storageService.saveGoals(_goals);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GoalDetailScreen(goal: _filteredGoals[index]),
                      ),
                    );
                  },
                  onLongPress: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.edit),
                              title: Text('Edit'),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GoalSettingScreen(goal: _filteredGoals[index]),
                                  ),
                                ).then((_) => _loadGoals());
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.delete),
                              title: Text('Delete'),
                              onTap: () async {
                                Navigator.pop(context);
                                setState(() {
                                  _goals.remove(_filteredGoals[index]);
                                  _applyFilters();
                                });
                                await _storageService.saveGoals(_goals);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GoalSettingScreen()),
          ).then((_) => _loadGoals());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
