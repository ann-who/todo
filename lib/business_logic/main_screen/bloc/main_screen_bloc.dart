import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:android_id/android_id.dart';

import 'package:todo_app/data/repository/task_repository.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/resources/app_constants.dart';
import 'package:todo_app/todo_app.dart';

part 'main_screen_event.dart';
part 'main_screen_state.dart';

class TasksMainScreenBloc
    extends Bloc<TasksMainScreenEvent, TasksMainScreenState> {
  final TaskRepository _taskRepository;
  final bool _isTesting;
  int _testingLastId = 0;

  TasksMainScreenBloc({
    required TaskRepository taskRepository,
    bool isTesting = false,
  })  : _taskRepository = taskRepository,
        _isTesting = isTesting,
        super(
          const TasksMainScreenState(
            tasksList: [],
            isDoneTasksVisible: true,
            newTaskText: '',
          ),
        ) {
    on<TaskFromListDeleted>(
      _onTaskDeleted,
      transformer: sequential(),
    );
    on<TaskCompletionToggled>(
      _onTaskCompletionToggled,
      transformer: sequential(),
    );
    on<TaskSubmitted>(
      _onTaskSubmitted,
      transformer: sequential(),
    );
    on<TasksListRefreshed>(
      _onTasksListRefreshed,
      transformer: sequential(),
    );
    on<TaskTextChanged>(_onTaskTextChanged);
    on<DoneTasksVisibilityToggled>(_onDoneTasksVisibilityToggled);
    on<TaskFieldFocusChanged>(_onTaskFieldFocusChanged);
    on<TaskCreationOpened>(_onTaskCreationOpened);
    on<TaskEditOpened>(_onTaskEditOpened);
    on<TaskEditCompleted>(_onTaskEditCompleted);
  }

  void _onTaskDeleted(
    TaskFromListDeleted event,
    Emitter<TasksMainScreenState> emit,
  ) async {
    emit(state.copyWith(status: TasksMainScreenStatus.onDataChanges));
    try {
      var updatedTaskList = List<Task>.from(state.tasksList);

      int elementIndex =
          updatedTaskList.indexWhere((element) => element.id == event.task.id);
      if (elementIndex == -1) {
        throw Exception(WidgetsSettings.notFound);
      }

      updatedTaskList.removeAt(elementIndex);

      emit(state.copyWith(tasksList: updatedTaskList));

      await _taskRepository.deleteTask(event.task.id);
      emit(state.copyWith(status: TasksMainScreenStatus.ordinary));

      if (_taskRepository.needRefresh) {
        add(const TasksListRefreshed());
      }
    } catch (e) {
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
    emit(state.copyWith(status: TasksMainScreenStatus.onDataChanges));

    try {
      var updatedTaskList = List<Task>.from(state.tasksList);
      int elementIndex =
          updatedTaskList.indexWhere((element) => element.id == event.task.id);
      if (elementIndex == -1) {
        throw Exception(WidgetsSettings.notFound);
      }

      var element = updatedTaskList[elementIndex];
      var updatedElement = element.copyWith(
        done: !element.done,
        changedAt: DateTime.now().millisecondsSinceEpoch,
        lastUpdatedBy: await _getDeviceId(),
      );

      if (_isTesting) {
        updatedElement = updatedElement.copyWith(changedAt: -1);
      }

      updatedTaskList[elementIndex] = updatedElement;

      emit(state.copyWith(tasksList: updatedTaskList));

      await _taskRepository.updateTask(updatedElement);

      emit(state.copyWith(status: TasksMainScreenStatus.ordinary));

      if (_taskRepository.needRefresh) {
        add(const TasksListRefreshed());
      }
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
    emit(state.copyWith(status: TasksMainScreenStatus.onDataChanges));
    try {
      var updatedTaskList = List<Task>.from(state.tasksList);
      var newTask = Task.minimal(state.newTaskText).copyWith(
        lastUpdatedBy: await _getDeviceId(),
      );
      if (_isTesting) {
        newTask = newTask.copyWith(
          id: _testingLastId.toString(),
          changedAt: -1,
          createdAt: -1,
        );
        ++_testingLastId;
      }
      updatedTaskList.add(newTask);

      emit(state.copyWith(tasksList: updatedTaskList));

      await _taskRepository.createTask(newTask);
      emit(
        state.copyWith(
          status: TasksMainScreenStatus.ordinary,
          newTaskText: '',
        ),
      );

      if (_taskRepository.needRefresh) {
        add(const TasksListRefreshed());
      }
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
          taskOnEdition: null,
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

  void _onTaskFieldFocusChanged(
    TaskFieldFocusChanged event,
    Emitter<TasksMainScreenState> emit,
  ) async {
    emit(state.copyWith(fieldHasFocus: event.hasFocus));
  }

  void _onTaskCreationOpened(
    TaskCreationOpened event,
    Emitter<TasksMainScreenState> emit,
  ) async {
    emit(state.copyWith(status: TasksMainScreenStatus.onCreate));
  }

  void _onTaskEditOpened(
    TaskEditOpened event,
    Emitter<TasksMainScreenState> emit,
  ) async {
    emit(state.copyWith(
      status: TasksMainScreenStatus.onEdit,
      taskOnEdition: event.task,
    ));
  }

  void _onTaskEditCompleted(
    TaskEditCompleted event,
    Emitter<TasksMainScreenState> emit,
  ) async {
    emit(state.copyWith(
      status: TasksMainScreenStatus.ordinary,
      taskOnEdition: null,
    ));
  }

  Future<String> _getDeviceId() async {
    String deviceId = 'unknown-device';

    try {
      if (Platform.isIOS) {
        final deviceInfo = DeviceInfoPlugin();
        var iosDeviceInfo = await deviceInfo.iosInfo;
        deviceId = iosDeviceInfo.identifierForVendor!;
      } else if (Platform.isAndroid) {
        deviceId = (await const AndroidId().getId())!;
      }
    } catch (e) {
      logger.e(WidgetsSettings.deviceId);
    }

    return deviceId;
  }
}
