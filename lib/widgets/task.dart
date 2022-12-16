import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/tasks/tasks_bloc.dart';
import '../model/task.dart';

class TaskWidget extends StatelessWidget {
  final Task task;
  const TaskWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    String taskStatus = task.isComplete ? 'Complete' : 'On-going';
    return BlocListener<TasksBloc, TasksState>(
      listener: (context, state) {},
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                width: 2,
                color: task.isComplete
                    ? const Color(0xFF272f24)
                    : Colors.transparent),
            color: task.isComplete
                ? Theme.of(context).backgroundColor
                : const Color(0XFFfeddaa),
          ),
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(15),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: task.isComplete
                          ? Colors.grey
                          : const Color(0XFF322a1d),
                      fontSize: 18),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'by User ${task.userId}',
                      style: TextStyle(
                          color: task.isComplete
                              ? Colors.grey
                              : const Color(0XFF322a1d).withOpacity(0.7)),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        color: task.isComplete
                            ? const Color(0xFF272f24)
                            : const Color(0XFF322a1d),
                        child: Text(
                          taskStatus,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: task.isComplete
                                  ? Theme.of(context).primaryColor
                                  : const Color(0XFFfeddaa)),
                        ),
                      ),
                    )
                  ],
                ),
              ]),
        ),
      ),
    );
  }
}
