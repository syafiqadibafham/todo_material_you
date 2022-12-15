import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:todo_material_you/widgets/checkBoxes.dart';

class TaskWidget extends StatelessWidget {
  const TaskWidget({super.key});

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
                  'delectus aut autem',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text('by User'),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
