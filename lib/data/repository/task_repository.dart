import 'package:todo_app/models/task_model.dart';

abstract class TaskRepository {
  bool needRefresh();
  Future<void> createTask(Task task);
  Future<Task> getTask(String uuid);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String uuid);
  Future<void> updateTasksList(List<Task> tasks);
  Future<List<Task>> getTasksList();
}
