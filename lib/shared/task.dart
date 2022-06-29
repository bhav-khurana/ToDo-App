class Task {
  final String title;
  final String duedate;
  final bool completed;

  const Task({
    required this.title,
    required this.duedate,
    required this.completed,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'duedate': duedate,
      'completed': completed,
    };
  }
}