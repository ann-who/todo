import 'package:todo_app/data/network/revision_data_source.dart';
import 'package:todo_app/data/network/task_data_source.dart';
import 'package:todo_app/data/network/token_data_source.dart';
import 'package:todo_app/data/repository/task_repository.dart';
import 'package:todo_app/todo_app.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/resources/app_constants.dart';

class RemoteTaskRepository implements TaskRepository {
  bool _needRefresh = false;
  TaskDataSource? _taskDataSource;
  final RevisionDataSource _revisionDataSource = RevisionDataSource();
  final TokenDataSource _tokenDataSource = TokenDataSource();

  RemoteTaskRepository() {
    _tokenDataSource.setToken(WidgetsSettings.myToken);
  }

  Future<void> _initDSIfNotInit() async =>
      _taskDataSource ??= TaskDataSource((await _tokenDataSource.getToken())!);

  Future<void> _initRevisionIfNotInit() async {
    var lastRevision = await _revisionDataSource.getRevision();
    if (lastRevision == null) {
      await getTasksList();
    }
  }

  Future<void> _initIfNotInit() async {
    await _initDSIfNotInit();
    await _initRevisionIfNotInit();
  }

  /// Обработчики ошибок ревизии

  Future<void> onCreateTaskRevisionResolver(Task task) async {
    await getTasksList();
    var lastRevision = await _revisionDataSource.getRevision();
    await _taskDataSource!.createTask(lastRevision!, task);
    await getTasksList();
  }

  Future<void> onUpdateTaskRevisionResolver(Task task) async {
    await getTasksList();
    var lastRevision = await _revisionDataSource.getRevision();
    await _taskDataSource!.updateTask(lastRevision!, task);
    await getTasksList();
  }

  Future<void> onDeleteTaskRevisionResolver(String uuid) async {
    await getTasksList();
    var lastRevision = await _revisionDataSource.getRevision();
    await _taskDataSource!.deleteTask(lastRevision!, uuid);
    await getTasksList();
  }

  /// Переопределение базового класса

  @override
  bool get needRefresh => _needRefresh;

  @override
  Future<void> createTask(Task task) async {
    await _initIfNotInit();
    var lastRevision = await _revisionDataSource.getRevision();
    int resultRevision = lastRevision!;

    try {
      var result = await _taskDataSource!.createTask(lastRevision, task);
      resultRevision = result.revision;
    } on RevisionException {
      logger.e(WidgetsSettings.revisionError);
      await onCreateTaskRevisionResolver(task);
      _needRefresh = true;
    } on TaskDSException catch (e) {
      logger.e(e.message);
      rethrow;
    }

    _revisionDataSource.setRevision(resultRevision);
  }

  @override
  Future<Task> getTask(String uuid) async {
    await _initIfNotInit();

    TaskDataSourceAnswer result;
    try {
      result = await _taskDataSource!.getTask(uuid);
    } on NotFoundException {
      logger.e('$uuid ${WidgetsSettings.notFound}');
      rethrow;
    } on TaskDSException catch (e) {
      logger.e(e.message);
      rethrow;
    }

    _revisionDataSource.setRevision(result.revision);
    return result.result as Task;
  }

  @override
  Future<void> updateTask(Task task) async {
    await _initIfNotInit();
    var lastRevision = await _revisionDataSource.getRevision();
    int resultRevision = lastRevision!;

    try {
      var result = await _taskDataSource!.updateTask(lastRevision, task);
      resultRevision = result.revision;
    } on NotFoundException {
      logger.e('${task.id} ${WidgetsSettings.notFound}');
      rethrow;
    } on RevisionException {
      logger.e(WidgetsSettings.revisionError);
      await onUpdateTaskRevisionResolver(task);
      _needRefresh = true;
    } on TaskDSException catch (e) {
      logger.e(e.message);
      rethrow;
    }

    _revisionDataSource.setRevision(resultRevision);
  }

  @override
  Future<void> deleteTask(String uuid) async {
    await _initIfNotInit();
    var lastRevision = await _revisionDataSource.getRevision();
    int resultRevision = lastRevision!;

    try {
      var result = await _taskDataSource!.deleteTask(lastRevision, uuid);
      resultRevision = result.revision;
    } on NotFoundException {
      logger.e('$uuid ${WidgetsSettings.notFound}');
      rethrow;
    } on RevisionException {
      logger.e(WidgetsSettings.revisionError);
      await onDeleteTaskRevisionResolver(uuid);
      _needRefresh = true;
    } on TaskDSException catch (e) {
      logger.e(e.message);
      rethrow;
    }

    _revisionDataSource.setRevision(resultRevision);
  }

  @override
  Future<List<Task>> getTasksList() async {
    await _initIfNotInit();

    // Считаем, что GUI увидел, что нужно обновление и запросил его
    _needRefresh = false;

    TaskDataSourceAnswer result;
    try {
      result = await _taskDataSource!.getTasksList();
    } on TaskDSException catch (e) {
      logger.e(e.message);
      rethrow;
    }
    _revisionDataSource.setRevision(result.revision);

    return result.result as List<Task>;
  }

  @override
  Future<List<Task>> updateTasksList(List<Task> tasks) async {
    var lastRevision = await _revisionDataSource.getRevision();

    TaskDataSourceAnswer result;
    try {
      result = await _taskDataSource!.updateTasksList(lastRevision!, tasks);
    } on TaskDSException catch (e) {
      logger.e(e.message);
      rethrow;
    }

    _revisionDataSource.setRevision(result.revision);
    return result.result as List<Task>;
  }
}
