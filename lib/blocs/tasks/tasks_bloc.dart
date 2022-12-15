import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:todo_material_you/model/task.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TaskEvent, TasksState> {
  TasksBloc() : super(TasksInitial()) {
    on<LoadTask>(_onLoadTask);
    on<AddTask>(_onAddTask);
    on<DeleteTask>(_onDeleteTask);
    on<UpdateTask>(_onUpdateTask);
  }

  void _onLoadTask(LoadTask event, Emitter<TasksState> emit) {
    emit(TasksLoaded(tasks: event.tasks));
  }

  void _onAddTask(AddTask event, Emitter<TasksState> emit) {
    final state = this.state;
    if (state is TasksLoaded) {
      emit(TasksLoaded(tasks: List.from(state.tasks)..add(event.task)));
    }
  }

  void _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) {}

  void _onUpdateTask(UpdateTask event, Emitter<TasksState> emit) {}
}
