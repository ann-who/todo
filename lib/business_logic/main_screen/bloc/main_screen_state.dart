part of 'main_screen_bloc.dart';

enum TasksMainScreenStatus {
  ordinary,
  onChanges,
  loading,
  failure;

  bool get isBusy => [
        TasksMainScreenStatus.onChanges,
        TasksMainScreenStatus.loading
      ].contains(this);
}

enum TasksMainScreenError {
  none,
  onCreateError,
  onDeleteError,
  onUpdateError,
  onRefreshError,
}

class TasksMainScreenState extends Equatable {
  final TasksMainScreenStatus status;
  final TasksMainScreenError errorStatus;
  final List<Task> tasksList;
  final bool isDoneTasksVisible;
  final String newTaskText;

  const TasksMainScreenState({
    this.status = TasksMainScreenStatus.ordinary,
    this.errorStatus = TasksMainScreenError.none,
    this.tasksList = const [],
    this.isDoneTasksVisible = true,
    this.newTaskText = '',
  });

  Iterable<Task> get filteredTasks =>
      isDoneTasksVisible ? tasksList : tasksList.where((task) => !task.done);

  int get doneTasksCount {
    int doneCount = 0;
    for (var task in tasksList) {
      if (task.done) ++doneCount;
    }
    return doneCount;
  }

  TasksMainScreenState copyWith({
    TasksMainScreenStatus? status,
    TasksMainScreenError? errorStatus,
    List<Task>? tasksList,
    bool? isDoneTasksVisible,
    String? newTaskText,
  }) {
    return TasksMainScreenState(
      status: status ?? this.status,
      errorStatus: errorStatus ?? this.errorStatus,
      tasksList: tasksList ?? this.tasksList,
      isDoneTasksVisible: isDoneTasksVisible ?? this.isDoneTasksVisible,
      newTaskText: newTaskText ?? this.newTaskText,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorStatus,
        tasksList,
        isDoneTasksVisible,
        newTaskText,
      ];
}
