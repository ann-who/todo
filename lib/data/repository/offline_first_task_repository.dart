import 'package:todo_app/data/repository/local_task_repository.dart';
import 'package:todo_app/data/repository/remote_task_repository.dart';
import 'package:todo_app/data/repository/task_repository.dart';
import 'package:todo_app/models/task_model.dart';

class OfflineFirstTaskRepository extends RemoteTaskRepository {
  final LocalTaskRepository _localTaskRepository = LocalTaskRepository();

  Future<bool> hasInternet() => Future.value(false);

  Future<void> offlineFirstResolver() async {
    await super.updateTasksList(await _localTaskRepository.getTasksList());
  }

  @override
  Future<void> onCreateTaskRevisionResolver(Task task) async {
    await offlineFirstResolver();
  }

  @override
  Future<void> onUpdateTaskRevisionResolver(Task task) async {
    await offlineFirstResolver();
  }

  @override
  Future<void> onDeleteTaskRevisionResolver(String uuid) async {
    await offlineFirstResolver();
  }

  @override
  Future<void> createTask(Task task) async {
    await _localTaskRepository.createTask(task);
    if (await hasInternet()) {
      await super.createTask(task);
    }
  }

  @override
  Future<void> deleteTask(String uuid) async {
    await _localTaskRepository.deleteTask(uuid);
    if (await hasInternet()) {
      await super.deleteTask(uuid);
    }
  }

  @override
  Future<Task> getTask(String uuid) async {
    if (await hasInternet()) {
      var task = await super.getTask(uuid);
      _localTaskRepository.updateTask(task);
    }

    return _localTaskRepository.getTask(uuid);
  }

  @override
  Future<List<Task>> getTasksList() async {
    if (await hasInternet()) {
      var tasksList = await super.getTasksList();
      _localTaskRepository.updateTasksList(tasksList);
    }

    return _localTaskRepository.getTasksList();
  }

  @override
  Future<void> updateTask(Task task) async {
    await _localTaskRepository.updateTask(task);
    if (await hasInternet()) {
      await super.updateTask(task);
    }
  }

  @override
  Future<List<Task>> updateTasksList(List<Task> tasks) async {
    throw UnimplementedError();
  }
}
