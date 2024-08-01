class Goal {
  String title;
  String description;
  bool isCompleted;
  bool isImportant;

  Goal({
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.isImportant = false,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      title: json['title'],
      description: json['description'],
      isCompleted: json['isCompleted'],
      isImportant: json['isImportant'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'isImportant': isImportant,
    };
  }
}
