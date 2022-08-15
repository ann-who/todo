import 'package:equatable/equatable.dart';
import 'package:todo_app/models/task_model.dart';

abstract class TaskDetailedScreenEvent extends Equatable {
  const TaskDetailedScreenEvent();

  @override
  List<Object?> get props => [];
}

class TaskTextChanged extends TaskDetailedScreenEvent {
  final String taskText;

  const TaskTextChanged(this.taskText);

  @override
  List<Object?> get props => [taskText];
}

class TaskDeadlineChanged extends TaskDetailedScreenEvent {
  final int deadline;

  const TaskDeadlineChanged([this.deadline = -1]);

  @override
  List<Object?> get props => [deadline];
}

class TaskImportanceChanged extends TaskDetailedScreenEvent {
  final Importance priority;

  const TaskImportanceChanged(this.priority);

  @override
  List<Object?> get props => [priority];
}

class TaskDeleted extends TaskDetailedScreenEvent {
  const TaskDeleted();
}

class TaskSubmitted extends TaskDetailedScreenEvent {
  const TaskSubmitted();
}
