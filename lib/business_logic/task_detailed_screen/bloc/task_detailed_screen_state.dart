part of 'task_detailed_screen_bloc.dart';

enum TaskDetailedScreenStatus {
  ordinary,
  loading,
  success,
  failure;

  bool get isLoadingOrSuccess => [
        TaskDetailedScreenStatus.loading,
        TaskDetailedScreenStatus.success
      ].contains(this);
}

enum TaskDetailedScreenError {
  none,
  onCreateError,
  onDeleteError,
}

class TaskDetailedScreenState extends Equatable {
  final TaskDetailedScreenStatus status;
  final Task? initialTask;
  final String taskText;
  final Importance importance;
  final int deadline;
  final TaskDetailedScreenError errorStatus;
  final bool isChanged;

  const TaskDetailedScreenState({
    this.status = TaskDetailedScreenStatus.ordinary,
    this.initialTask,
    this.taskText = '',
    this.importance = Importance.basic,
    this.deadline = -1,
    this.errorStatus = TaskDetailedScreenError.none,
    this.isChanged = false,
  });

  bool get isNewTask => initialTask == null;
  bool get hasDeadline => deadline != -1;

  TaskDetailedScreenState copyWith({
    TaskDetailedScreenStatus? status,
    Task? initialTask,
    String? taskText,
    Importance? importance,
    int? deadline,
    TaskDetailedScreenError? errorStatus,
    bool? isChanged,
  }) {
    return TaskDetailedScreenState(
      status: status ?? this.status,
      initialTask: initialTask ?? this.initialTask,
      taskText: taskText ?? this.taskText,
      importance: importance ?? this.importance,
      deadline: deadline ?? this.deadline,
      errorStatus: errorStatus ?? this.errorStatus,
      isChanged: isChanged ?? this.isChanged,
    );
  }

  @override
  List<Object?> get props => [
        status,
        initialTask,
        taskText,
        importance,
        deadline,
      ];
}
