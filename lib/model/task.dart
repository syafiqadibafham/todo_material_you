class Task {
  final int id;
  final int userId;
  final String title;
  bool isComplete;

  Task({
    required this.id,
    required this.userId,
    required this.title,
    this.isComplete = false,
  });

  copyWith({int? id, int? userId, String? title, bool? isComplete}) {
    return Task(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        title: title ?? this.title,
        isComplete: isComplete ?? this.isComplete);
  }
}
