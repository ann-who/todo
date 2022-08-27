part of 'main_screen_bloc.dart';

enum TasksMainScreenStatus {
  /// Нормальное состояние экрана
  ordinary,

  /// Создание задачи со второго экрана
  onCreate,

  /// Редактирование задачи со второго экрана
  onEdit,

  /// Редактирование списка задач без необходимости обновления
  onDataChanges,

  /// Обновление списка задач
  loading,

  /// Ошибка выполненения действия
  failure;

  bool get isBusy => [
        TasksMainScreenStatus.onDataChanges,
        TasksMainScreenStatus.loading,
        TasksMainScreenStatus.onCreate,
        TasksMainScreenStatus.onEdit,
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
  final bool fieldHasFocus;
  final Task? taskOnEdition;

  const TasksMainScreenState({
    this.status = TasksMainScreenStatus.ordinary,
    this.errorStatus = TasksMainScreenError.none,
    this.tasksList = const [],
    this.isDoneTasksVisible = true,
    this.newTaskText = '',
    this.fieldHasFocus = false,
    this.taskOnEdition,
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
    bool? fieldHasFocus,
    Task? taskOnEdition,
  }) {
    return TasksMainScreenState(
      status: status ?? this.status,
      errorStatus: errorStatus ?? this.errorStatus,
      tasksList: tasksList ?? this.tasksList,
      isDoneTasksVisible: isDoneTasksVisible ?? this.isDoneTasksVisible,
      newTaskText: newTaskText ?? this.newTaskText,
      fieldHasFocus: fieldHasFocus ?? this.fieldHasFocus,
      taskOnEdition: taskOnEdition ?? this.taskOnEdition,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorStatus,
        tasksList,
        isDoneTasksVisible,
        newTaskText,
        fieldHasFocus,
      ];
}
