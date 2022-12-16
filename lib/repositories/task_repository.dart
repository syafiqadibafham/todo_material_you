import 'dart:convert';

import '../model/task.dart';
import 'package:http/http.dart' as http;

class TaskRepository {
  final String _baseUrl = "https://jsonplaceholder.typicode.com/todos";

  Future<List<Task>> getTask() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((task) => Task.fromJson(task))
          .toList();
    } else {
      throw Exception("Failed to load tasks");
    }
  }
}
