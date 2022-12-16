import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
part 'task.g.dart';

@JsonSerializable()
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

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
