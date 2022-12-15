import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_material_you/widgets/checkBoxes.dart';

import '../blocs/tasks/tasks_bloc.dart';
import '../model/task.dart';

class TaskWidget extends StatelessWidget {
  final Task task;
  const TaskWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    String taskStatus = task.isComplete ? 'Complete' : 'On-going';
    return BlocListener<TasksBloc, TasksState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                width: 2,
                color:
                    task.isComplete ? Color(0xFF272f24) : Colors.transparent),
            color: task.isComplete
                ? Theme.of(context).backgroundColor
                : Color(0XFFfeddaa),
          ),
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(15),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: task.isComplete ? Colors.grey : Color(0XFF322a1d),
                      fontSize: 18),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'by User ${task.userId}',
                      style: TextStyle(color: Colors.grey),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        color: task.isComplete
                            ? Color(0xFF272f24)
                            : Color(0XFF322a1d),
                        child: Text(
                          taskStatus,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: task.isComplete
                                  ? Theme.of(context).primaryColor
                                  : Color(0XFFfeddaa)),
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
