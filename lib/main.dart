import 'dart:ffi';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_material_you/blocs/tasks/tasks_bloc.dart';
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
        BlocProvider(create: (context) => TasksBloc()..add(LoadTask()))
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
          title: 'Flutter Demo',
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
          home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

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
                  TaskWidget(),
                ],
              ),
            );
          } else {
            return Text('No Task Found');
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
