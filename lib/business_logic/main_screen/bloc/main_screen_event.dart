part of 'main_screen_bloc.dart';

abstract class TasksMainScreenEvent extends Equatable {
  const TasksMainScreenEvent();

  @override
  List<Object?> get props => [];
}

class TaskFromListDeleted extends TasksMainScreenEvent {
  final Task task;

  const TaskFromListDeleted(this.task);

  @override
  List<Object?> get props => [task];
}

class TaskCompletionToggled extends TasksMainScreenEvent {
  final Task task;

  const TaskCompletionToggled(this.task);

  @override
  List<Object?> get props => [task];
}

class TaskTextChanged extends TasksMainScreenEvent {
  final String newTaskText;

  const TaskTextChanged(this.newTaskText);

  @override
  List<Object?> get props => [newTaskText];
}

class TaskSubmitted extends TasksMainScreenEvent {
  const TaskSubmitted();
}

class DoneTasksVisibilityToggled extends TasksMainScreenEvent {
  const DoneTasksVisibilityToggled();
}

class TasksListRefreshed extends TasksMainScreenEvent {
  const TasksListRefreshed();
}
