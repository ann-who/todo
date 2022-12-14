import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:android_id/android_id.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo_app/data/repository/task_repository.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/resources/app_constants.dart';
import 'package:todo_app/todo_app.dart';

part 'task_detailed_screen_event.dart';
part 'task_detailed_screen_state.dart';

class TaskDetailedScreenBloc
    extends Bloc<TaskDetailedScreenEvent, TaskDetailedScreenState> {
  final TaskRepository _taskRepository;

  TaskDetailedScreenBloc({
    required TaskRepository taskRepository,
    Task? initialTask,
  })  : _taskRepository = taskRepository,
        super(
          TaskDetailedScreenState(
            initialTask: initialTask,
            taskText: initialTask?.text ?? '',
            importance: initialTask?.importance ?? Importance.basic,
            deadline: initialTask?.deadline ?? -1,
          ),
        ) {
    on<TaskTextChanged>(_onTaskTextChanged);
    on<TaskDeadlineChanged>(_onTaskDeadlineChanged);
    on<TaskImportanceChanged>(_onTaskImportanceChanged);
    on<TaskDeleted>(_onTaskDeleted);
    on<TaskSubmitted>(_onTaskSubmitted);
  }

  void _onTaskTextChanged(
    TaskTextChanged event,
    Emitter<TaskDetailedScreenState> emit,
  ) {
    emit(
      state.copyWith(
        taskText: event.taskText,
        isChanged: true,
      ),
    );
  }

  void _onTaskDeadlineChanged(
    TaskDeadlineChanged event,
    Emitter<TaskDetailedScreenState> emit,
  ) {
    emit(
      state.copyWith(
        deadline: event.deadline,
        isChanged: true,
      ),
    );
  }

  void _onTaskImportanceChanged(
    TaskImportanceChanged event,
    Emitter<TaskDetailedScreenState> emit,
  ) {
    emit(
      state.copyWith(
        importance: event.priority,
        isChanged: true,
      ),
    );
  }

  void _onTaskDeleted(
    TaskDeleted event,
    Emitter<TaskDetailedScreenState> emit,
  ) async {
    emit(state.copyWith(status: TaskDetailedScreenStatus.loading));
    try {
      await _taskRepository.deleteTask(state.initialTask!.id);
      emit(state.copyWith(status: TaskDetailedScreenStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: TaskDetailedScreenStatus.failure,
          errorStatus: TaskDetailedScreenError.onDeleteError,
        ),
      );
    }
  }

  void _onTaskSubmitted(
    TaskSubmitted event,
    Emitter<TaskDetailedScreenState> emit,
  ) async {
    emit(state.copyWith(status: TaskDetailedScreenStatus.loading));
    try {
      if (state.isNewTask) {
        await _taskRepository.createTask(
          Task.full(
            text: state.taskText,
            importance: state.importance,
            deadline: state.deadline,
          ).copyWith(
            lastUpdatedBy: await _getDeviceId(),
          ),
        );
      } else {
        await _taskRepository.updateTask(
          state.initialTask!.copyWith(
            text: state.taskText,
            importance: state.importance,
            deadline: state.deadline,
            lastUpdatedBy: await _getDeviceId(),
            changedAt: DateTime.now().millisecondsSinceEpoch,
          ),
        );
      }

      emit(state.copyWith(status: TaskDetailedScreenStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: TaskDetailedScreenStatus.failure,
          errorStatus: TaskDetailedScreenError.onCreateError,
        ),
      );
    }
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
