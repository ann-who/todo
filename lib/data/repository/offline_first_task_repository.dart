import 'dart:io';
import 'package:todo_app/data/network/local_changes_source.dart';
import 'package:todo_app/data/repository/local_task_repository.dart';
import 'package:todo_app/data/repository/remote_task_repository.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/resources/app_constants.dart';

class OfflineFirstTaskRepository extends RemoteTaskRepository {
  final LocalTaskRepository _localTaskRepository = LocalTaskRepository();
  final LocalChangesDataSource _localChangesDS = LocalChangesDataSource();
  bool _localChangesWasMerged = false;

  Future<bool> hasInternet() async {
    bool hasInternet = true;
    try {
      final result = await InternetAddress.lookup(WidgetsSettings.domainUrl);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasInternet = true;
      }
    } on Exception catch (_) {
      hasInternet = false;
    }
    return hasInternet;
  }

  @override
  bool get needRefresh => super.needRefresh || _localChangesWasMerged;

  Future<void> offlineFirstResolver() async {
    await super.updateTasksList(await _localTaskRepository.getTasksList());
    await _localChangesDS.setLocalChanges(false);
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

    if (!(await hasInternet())) {
      await _localChangesDS.setLocalChanges(true);
      return;
    }

    if (await _localChangesDS.getLocalChanges()) {
      await offlineFirstResolver();
      _localChangesWasMerged = true;
    } else {
      await super.createTask(task);
    }
  }

  @override
  Future<void> deleteTask(String uuid) async {
    await _localTaskRepository.deleteTask(uuid);

    if (!(await hasInternet())) {
      await _localChangesDS.setLocalChanges(true);
      return;
    }

    if (await _localChangesDS.getLocalChanges()) {
      await offlineFirstResolver();
      _localChangesWasMerged = true;
    } else {
      await super.deleteTask(uuid);
    }
  }

  @override
  Future<Task> getTask(String uuid) async {
    if (await hasInternet()) {
      if (await _localChangesDS.getLocalChanges()) {
        await offlineFirstResolver();
        _localChangesWasMerged = true;
      }

      var task = await super.getTask(uuid);
      _localTaskRepository.updateTask(task);
    }

    return _localTaskRepository.getTask(uuid);
  }

  @override
  Future<List<Task>> getTasksList() async {
    // Считаем, что GUI увидел, что нужно обновление и запросил его
    _localChangesWasMerged = false;

    if (await hasInternet()) {
      if (await _localChangesDS.getLocalChanges()) {
        await offlineFirstResolver();
      }
      var tasksList = await super.getTasksList();
      await _localTaskRepository.updateTasksList(tasksList);
    }

    return _localTaskRepository.getTasksList();
  }

  @override
  Future<void> updateTask(Task task) async {
    await _localTaskRepository.updateTask(task);

    if (!(await hasInternet())) {
      await _localChangesDS.setLocalChanges(true);
      return;
    }

    if (await _localChangesDS.getLocalChanges()) {
      await offlineFirstResolver();
      _localChangesWasMerged = true;
    } else {
      await super.updateTask(task);
    }
  }

  @override
  Future<List<Task>> updateTasksList(List<Task> tasks) async {
    throw UnimplementedError();
  }
}
