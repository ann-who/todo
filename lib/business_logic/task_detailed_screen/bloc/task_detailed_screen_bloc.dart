import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo_app/business_logic/task_detailed_screen/bloc/task_detailed_screen_event.dart';
import 'package:todo_app/business_logic/task_detailed_screen/bloc/task_detailed_screen_state.dart';
import 'package:todo_app/data/repository/task_repository.dart';
import 'package:todo_app/models/task_model.dart';

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
          ),
        );
      } else {
        await _taskRepository.updateTask(
          state.initialTask!.copyWith(
            text: state.taskText,
            importance: state.importance,
            deadline: state.deadline,
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
}
