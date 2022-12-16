import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_material_you/blocs/tasks/tasks_bloc.dart';
import 'package:todo_material_you/model/task.dart';
import 'package:todo_material_you/repositories/task_repository.dart';
import 'package:todo_material_you/widgets/task.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo M-You App',
      theme: ThemeData(
          useMaterial3: true,
          primaryColor: const Color(0XFFceef86),
          backgroundColor: const Color(0XFF201a1a)),
      home: RepositoryProvider(
        create: (context) => TaskRepository(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (context) => TasksBloc(
                      RepositoryProvider.of<TaskRepository>(context),
                    )..add(LoadTask()))
          ],
          child: MyHomePage(title: 'Your Tasks'),
        ),
      ),
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

  Future<Task?> _openDialog(int lastId) {
    textInputTitleController.text = '';
    textInputUserIdController.text = '';
    return showDialog<Task>(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: const Color(0XFFfeddaa),
              title: TextField(
                  controller: textInputTitleController,
                  decoration: const InputDecoration(
                      fillColor: Color(0XFF322a1d),
                      hintText: 'Task Title',
                      border: InputBorder.none)),
              content: TextField(
                  controller: textInputUserIdController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: const InputDecoration(
                      hintText: 'User ID',
                      border: InputBorder.none,
                      filled: true)),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey),
                    )),
                TextButton(
                    onPressed: (() {
                      if (textInputTitleController.text != '' &&
                          textInputUserIdController.text != '') {
                        Navigator.of(context).pop(Task(
                            id: lastId + 1,
                            userId: int.parse(textInputUserIdController.text),
                            title: textInputTitleController.text));
                      }
                    }),
                    child: const Text('Add',
                        style: TextStyle(color: Color(0xFF322a1d))))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    int? lastId;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          widget.title,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: BlocBuilder<TasksBloc, TasksState>(
        builder: (context, state) {
          if (state is TasksLoading) {
            return const CircularProgressIndicator();
          }
          if (state is TasksLoaded) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ...state.tasks.map(
                      (task) => InkWell(
                        onTap: (() {
                          context.read<TasksBloc>().add(UpdateTask(
                              task:
                                  task.copyWith(isComplete: !task.isComplete)));
                        }),
                        child: TaskWidget(
                          task: task,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    )
                  ],
                ),
              ),
            );
          } else {
            return const Text('No Task Found');
          }
        },
      ),
      floatingActionButton: BlocListener<TasksBloc, TasksState>(
        listener: (context, state) {
          if (state is TasksLoaded) {
            lastId = state.tasks.last.id;
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Task Updated!'),
            ));
          }
        },
        child: FloatingActionButton(
          backgroundColor: const Color(0xFFf8bd47),
          foregroundColor: const Color(0xFF322a1d),
          onPressed: () async {
            Task? task = await _openDialog(lastId ?? 0);
            if (task != null) {
              context.read<TasksBloc>().add(
                    AddTask(task: task),
                  );
            }
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
