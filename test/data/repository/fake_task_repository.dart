import 'package:todo_app/data/repository/task_repository.dart';
import 'package:todo_app/models/task_model.dart';

class FakeTaskRepository implements TaskRepository {
  List<Task> _fakeDatabase = [];

  @override
  bool needRefresh() => false;

  @override
  Future<void> createTask(Task task) async => _fakeDatabase.add(task);

  @override
  Future<Task> getTask(String uuid) async =>
      _fakeDatabase.firstWhere((task) => task.id == uuid);

  @override
  Future<void> updateTask(Task task) async {
    int elementIndex =
        _fakeDatabase.indexWhere((element) => element.id == task.id);
    _fakeDatabase[elementIndex] = task;
  }

  @override
  Future<void> deleteTask(String uuid) async =>
      _fakeDatabase.removeWhere((task) => task.id == uuid);

  @override
  Future<List<Task>> getTasksList() async => _fakeDatabase;

  @override
  Future<void> updateTasksList(List<Task> tasks) async => _fakeDatabase = tasks;
}
