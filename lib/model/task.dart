class Task {
  final int id;
  final int userId;
  final String title;
  final bool isComplete;

  Task({
    required this.id,
    required this.userId,
    required this.title,
    this.isComplete = false,
  });
}
