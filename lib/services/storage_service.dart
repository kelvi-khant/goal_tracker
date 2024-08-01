import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/goal.dart';

class StorageService {
  static const String _storageKey = 'goals';

  Future<List<Goal>> getGoals() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? goalsString = prefs.getString(_storageKey);
    if (goalsString == null) {
      return [];
    }
    final List<dynamic> goalsJson = json.decode(goalsString);
    return goalsJson.map((json) => Goal.fromJson(json)).toList();
  }

  Future<void> saveGoals(List<Goal> goals) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String goalsString = json.encode(goals.map((goal) => goal.toJson()).toList());
    await prefs.setString(_storageKey, goalsString);
  }
}
