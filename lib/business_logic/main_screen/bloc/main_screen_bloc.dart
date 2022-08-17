import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo_app/data/repository/task_repository.dart';
import 'package:todo_app/models/task_model.dart';

part 'main_screen_event.dart';
part 'main_screen_state.dart';

class TasksMainScreenBloc
    extends Bloc<TasksMainScreenEvent, TasksMainScreenState> {
  final TaskRepository _taskRepository;

  TasksMainScreenBloc({
    required TaskRepository taskRepository,
  })  : _taskRepository = taskRepository,
        super(
          const TasksMainScreenState(
            tasksList: [],
            isDoneTasksVisible: true,
            newTaskText: '',
          ),
        ) {
    on<TaskFromListDeleted>(_onTaskDeleted);
    on<TaskCompletionToggled>(_onTaskCompletionToggled);
    on<TaskTextChanged>(_onTaskTextChanged);
    on<TaskSubmitted>(_onTaskSubmitted);
    on<DoneTasksVisibilityToggled>(_onDoneTasksVisibilityToggled);
    on<TasksListRefreshed>(_onTasksListRefreshed);
  }

  void _onTaskDeleted(
    TaskFromListDeleted event,
    Emitter<TasksMainScreenState> emit,
  ) async {
    emit(state.copyWith(status: TasksMainScreenStatus.onChanges));
    try {
      var newTaskList = state.tasksList;
      newTaskList.removeWhere(
        (element) => element.id == event.task.id,
      );
      emit(
        state.copyWith(
          status: TasksMainScreenStatus.onChanges,
          tasksList: newTaskList,
        ),
      );

      await _taskRepository.deleteTask(event.task.id);
      emit(state.copyWith(status: TasksMainScreenStatus.ordinary));
    } catch (e) {
      // TODO откат
      emit(
        state.copyWith(
          status: TasksMainScreenStatus.failure,
          errorStatus: TasksMainScreenError.onDeleteError,
        ),
      );
    }
  }

  void _onTaskCompletionToggled(
    TaskCompletionToggled event,
    Emitter<TasksMainScreenState> emit,
  ) async {
    emit(state.copyWith(status: TasksMainScreenStatus.onChanges));
    try {
      var newTaskList = state.tasksList;
      // ищем индекс элемента
      int elementIndex =
          newTaskList.indexWhere((element) => element.id == event.task.id);
      // если индекс -1 сделать обычный статус и ретерн
      if (elementIndex == -1) {
        emit(state.copyWith(status: TasksMainScreenStatus.ordinary));
        return;
      }
      // по индексу берем элемент
      var element = newTaskList[elementIndex];
      // создаем копию, у которой статус выполнения  противоположный
      var newElement = element.copyWith(done: !element.done);
      // заменяем старое значение на новое по индексу, который нашли
      newTaskList[elementIndex] = newElement;
      // запоминаем список с измененным таском в состоянии и отображаем его
      emit(
        state.copyWith(
          status: TasksMainScreenStatus.onChanges,
          tasksList: newTaskList,
        ),
      );

      await _taskRepository
          .updateTask(event.task.copyWith(done: !event.task.done));
      emit(state.copyWith(status: TasksMainScreenStatus.ordinary));
    } catch (e) {
      emit(
        state.copyWith(
          status: TasksMainScreenStatus.failure,
          errorStatus: TasksMainScreenError.onUpdateError,
        ),
      );
    }
  }

  void _onTaskTextChanged(
    TaskTextChanged event,
    Emitter<TasksMainScreenState> emit,
  ) {
    emit(state.copyWith(newTaskText: event.newTaskText));
  }

  void _onTaskSubmitted(
    TaskSubmitted event,
    Emitter<TasksMainScreenState> emit,
  ) async {
    emit(state.copyWith(status: TasksMainScreenStatus.onChanges));
    try {
      var newTaskList = state.tasksList;
      var newTask = Task.minimal(state.newTaskText);
      newTaskList.add(newTask);

      emit(
        state.copyWith(
          status: TasksMainScreenStatus.onChanges,
          newTaskText: newTask.text,
        ),
      );

      // взять список
      // добавить в конец newTask
      // засунуть новый список в состояние

      await _taskRepository.createTask(newTask);
      emit(
        state.copyWith(
          status: TasksMainScreenStatus.ordinary,
          newTaskText: '',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TasksMainScreenStatus.failure,
          errorStatus: TasksMainScreenError.onCreateError,
        ),
      );
    }
  }

  void _onDoneTasksVisibilityToggled(
    DoneTasksVisibilityToggled event,
    Emitter<TasksMainScreenState> emit,
  ) async {
    emit(state.copyWith(isDoneTasksVisible: !state.isDoneTasksVisible));
  }

  void _onTasksListRefreshed(
    TasksListRefreshed event,
    Emitter<TasksMainScreenState> emit,
  ) async {
    emit(state.copyWith(status: TasksMainScreenStatus.loading));

    try {
      var tasksList = await _taskRepository.getTasksList();
      emit(
        state.copyWith(
          status: TasksMainScreenStatus.ordinary,
          tasksList: tasksList,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TasksMainScreenStatus.failure,
          errorStatus: TasksMainScreenError.onRefreshError,
        ),
      );
    }
  }
}
