import 'package:todo_app/models/task_model.dart';

abstract class TaskRepository {
  bool get needRefresh;
  Future<void> createTask(Task task);
  Future<Task> getTask(String uuid);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String uuid);
  Future<List<Task>> updateTasksList(List<Task> tasks);
  Future<List<Task>> getTasksList();
}
