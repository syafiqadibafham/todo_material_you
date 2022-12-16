import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:todo_material_you/model/task.dart';
import 'package:todo_material_you/repositories/task_repository.dart';
part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TaskEvent, TasksState> {
  final TaskRepository _taskRepository;

  TasksBloc(this._taskRepository) : super(TasksLoaded()) {
    on<LoadTask>(_onLoadTask);
    on<AddTask>(_onAddTask);
    on<DeleteTask>(_onDeleteTask);
    on<UpdateTask>(_onUpdateTask);
  }

  Future<void> _onLoadTask(LoadTask event, Emitter<TasksState> emit) async {
    emit(TasksLoading());
    try {
      final tasks = await _taskRepository.getTask();
      emit(TasksLoaded(tasks: tasks));
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }

  void _onAddTask(AddTask event, Emitter<TasksState> emit) {
    final state = this.state;
    if (state is TasksLoaded) {
      emit(TasksLoaded(tasks: List.from(state.tasks)..add(event.task)));
    }
  }

  void _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) {
    final state = this.state;
    if (state is TasksLoaded) {
      List<Task> tasks = state.tasks.where((task) {
        return task.id != event.task.id;
      }).toList();
      emit(TasksLoaded(tasks: tasks));
    }
  }

  void _onUpdateTask(UpdateTask event, Emitter<TasksState> emit) {
    final state = this.state;
    if (state is TasksLoaded) {
      List<Task> tasks = (state.tasks.map((task) {
        return task.id == event.task.id ? event.task : task;
      })).toList();
      emit(TasksLoaded(tasks: tasks));
    }
  }
}
