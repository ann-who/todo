import 'dart:io';
import 'package:todo_app/data/repository/local_task_repository.dart';
import 'package:todo_app/data/repository/remote_task_repository.dart';
import 'package:todo_app/data/repository/task_repository.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/resources/app_constants.dart';

class OfflineFirstTaskRepository extends RemoteTaskRepository {
  final LocalTaskRepository _localTaskRepository = LocalTaskRepository();
  bool hasLocalChanges = false; // TODO хранить при перезапуске

  Future<bool> hasInternet() async {
    bool hasInternet = true;
    try {
      // TODO get permission and check with InternetAddress.lookup
      // final result = await InternetAddress.lookup(WidgetsSettings.baseUrl);
      // if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      hasInternet = true;
      // }
    } on Exception catch (_) {
      hasInternet = false;
    }
    return hasInternet;
  }

  Future<void> offlineFirstResolver() async {
    await super.updateTasksList(await _localTaskRepository.getTasksList());
    hasLocalChanges = false;
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
  Future<void> onRefreshRevisionResolver() async {
    await offlineFirstResolver();
  }

  @override
  Future<void> createTask(Task task) async {
    await _localTaskRepository.createTask(task);
    if (await hasInternet()) {
      if (hasLocalChanges) {
        offlineFirstResolver();
      } else {
        await super.createTask(task);
      }
    } else {
      hasLocalChanges = true;
    }
  }

  @override
  Future<void> deleteTask(String uuid) async {
    await _localTaskRepository.deleteTask(uuid);
    if (await hasInternet()) {
      if (hasLocalChanges) {
        offlineFirstResolver();
      } else {
        await super.deleteTask(uuid);
      }
    } else {
      hasLocalChanges = true;
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
      if (hasLocalChanges) {
        offlineFirstResolver();
      }
      var tasksList = await super.getTasksList();
      await _localTaskRepository.updateTasksList(tasksList);
    }

    return _localTaskRepository.getTasksList();
  }

  @override
  Future<void> updateTask(Task task) async {
    await _localTaskRepository.updateTask(task);
    if (await hasInternet()) {
      if (hasLocalChanges) {
        offlineFirstResolver();
      } else {
        await super.updateTask(task);
      }
    } else {
      hasLocalChanges = true;
    }
  }

  @override
  Future<List<Task>> updateTasksList(List<Task> tasks) async {
    throw UnimplementedError();
  }
}
