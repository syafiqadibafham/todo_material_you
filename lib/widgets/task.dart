import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:todo_material_you/widgets/checkBoxes.dart';

import '../model/task.dart';

class TaskWidget extends StatelessWidget {
  final Task task;
  const TaskWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: Theme.of(context).primaryColor,
          height: 50,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            children: [
              CheckBoxesWidget(),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  task.title,
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text('by User ${task.userId}'),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
