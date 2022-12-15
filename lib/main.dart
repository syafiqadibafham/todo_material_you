import 'dart:ffi';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_material_you/blocs/tasks/tasks_bloc.dart';
import 'package:todo_material_you/model/task.dart';
import 'package:todo_material_you/widgets/checkBoxes.dart';
import 'package:todo_material_you/widgets/task.dart';

void main() {
  runApp(const MyApp());
}

Color defaultColor = Color(0XFF4166f5);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => TasksBloc()
              ..add(LoadTask(tasks: [
                Task(id: 1, userId: 1, title: "delectus aut autem"),
                Task(
                  id: 2,
                  userId: 1,
                  title: "quis ut nam facilis et officia qui",
                  isComplete: true,
                ),
              ])))
      ],
      child: DynamicColorBuilder(
          builder: (ColorScheme? lightDynamic, ColorScheme? dark) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;

        if (lightDynamic != null && dark != null) {
          lightColorScheme = lightDynamic.harmonized()..copyWith();
          lightColorScheme = lightColorScheme.copyWith(secondary: defaultColor);
          darkColorScheme = dark.harmonized();
        } else {
          lightColorScheme = ColorScheme.fromSeed(seedColor: defaultColor);
          darkColorScheme = ColorScheme.fromSeed(
              seedColor: defaultColor, brightness: Brightness.dark);
        }

        return MaterialApp(
          title: 'ToDo M-You App',
          theme: ThemeData(
              useMaterial3: true,
              colorScheme: lightColorScheme,
              backgroundColor: lightColorScheme.primaryContainer,
              primaryColor: lightColorScheme.primary,
              primaryTextTheme: TextTheme(
                  headline1:
                      TextStyle(color: lightColorScheme.onPrimaryContainer),
                  headline6: TextStyle(color: Colors.white)),
              appBarTheme: AppBarTheme(
                backgroundColor: lightColorScheme.primaryContainer,
              )),
          home: const MyHomePage(title: 'Your Tasks'),
        );
      }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController textInputTitleController;
  late TextEditingController textInputUserIdController;

  @override
  void initState() {
    super.initState();

    textInputTitleController = TextEditingController();
    textInputUserIdController = TextEditingController();
  }

  @override
  void dispose() {
    textInputTitleController.dispose();
    textInputUserIdController.dispose();
    super.dispose();
  }

  Future<Task?> _openDialog() => showDialog<Task>(
      context: context,
      builder: (context) => AlertDialog(
            title: TextField(
                controller: textInputTitleController,
                decoration: InputDecoration(
                    hintText: 'Task Title', border: InputBorder.none)),
            content: TextField(
                controller: textInputUserIdController,
                decoration: InputDecoration(
                    hintText: 'User ID',
                    border: InputBorder.none,
                    filled: true)),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel')),
              TextButton(
                  onPressed: (() {
                    Navigator.of(context).pop(Task(
                        id: 201,
                        userId: int.parse(textInputUserIdController.text),
                        title: textInputTitleController.text));
                  }),
                  child: Text('Add'))
            ],
          ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
      body: BlocBuilder<TasksBloc, TasksState>(
        builder: (context, state) {
          if (state is TasksLoading) {
            return CircularProgressIndicator();
          }
          if (state is TasksLoaded) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ...state.tasks.map(
                    (task) => TaskWidget(
                      task: task,
                    ),
                  )
                ],
              ),
            );
          } else {
            return Text('No Task Found');
          }
        },
      ),
      floatingActionButton: BlocListener<TasksBloc, TasksState>(
        listener: (context, state) {
          if (state is TasksLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('New Task added!'),
            ));
          }
        },
        child: FloatingActionButton(
          onPressed: () async {
            final task = await _openDialog();
            context.read<TasksBloc>().add(
                  AddTask(task: task!),
                );
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
