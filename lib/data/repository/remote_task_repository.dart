import 'package:todo_app/data/network/revision_data_source.dart';
import 'package:todo_app/data/network/task_data_source.dart';
import 'package:todo_app/data/network/token_data_source.dart';
import 'package:todo_app/data/repository/task_repository.dart';
import 'package:todo_app/todo_app.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/resources/app_constants.dart';

//! TODO обработка ошибок
// Отсутствие интернета
// Отсутствие токена
// Прочие ошибки

class RemoteTaskRepository implements TaskRepository {
  bool _needRefresh = false;
  TaskDataSource? taskDataSource;
  final RevisionDataSource revisionDataSource = RevisionDataSource();
  final TokenDataSource tokenDataSource = TokenDataSource();

  RemoteTaskRepository() {
    tokenDataSource.setToken(WidgetsSettings.myToken);
  }

  Future<void> initDSIfNotInit() async =>
      taskDataSource ??= TaskDataSource((await tokenDataSource.getToken())!);

  Future<void> initRevisionIfNotInit() async {
    var lastRevision = await revisionDataSource.getRevision();
    if (lastRevision == null) {
      updateRevision();
    }
  }

  Future<void> initIfNotInit() async {
    await initDSIfNotInit();
    await initRevisionIfNotInit();
  }

  Future<void> updateRevision() async => await getTasksList();

  @override
  bool needRefresh() => _needRefresh;

  @override
  Future<void> createTask(Task task) async {
    await initIfNotInit();
    var lastRevision = await revisionDataSource.getRevision();

    TaskDataSourceAnswer result;
    try {
      result = await taskDataSource!.createTask(lastRevision!, task);
    } on RevisionException {
      logger.e('Revision error');
      // TODO придумать, как разрешать конфликты для offline-first.
      await updateRevision();
      lastRevision = await revisionDataSource.getRevision();
      result = await taskDataSource!.createTask(lastRevision!, task);
      _needRefresh = true;
    } on TaskDSException catch (e) {
      logger.e(e.message);
      rethrow;
    }

    revisionDataSource.setRevision(result.revision);
  }

  @override
  Future<Task> getTask(String uuid) async {
    await initIfNotInit();

    TaskDataSourceAnswer result;
    try {
      result = await taskDataSource!.getTask(uuid);
    } on NotFoundException {
      logger.e('Задача $uuid не найдена');
      rethrow;
    } on TaskDSException catch (e) {
      logger.e(e.message);
      rethrow;
    }

    revisionDataSource.setRevision(result.revision);
    return result.result as Task;
  }

  @override
  Future<void> updateTask(Task task) async {
    await initIfNotInit();
    var lastRevision = await revisionDataSource.getRevision();

    TaskDataSourceAnswer result;
    try {
      result = result = await taskDataSource!.updateTask(lastRevision!, task);
    } on NotFoundException {
      logger.e('Задача ${task.id} не найдена');
      rethrow;
    } on RevisionException {
      logger.e('Ошибка ревизии');
      // TODO придумать, как разрешать конфликты для offline-first.
      await updateRevision();
      lastRevision = await revisionDataSource.getRevision();
      result = await taskDataSource!.updateTask(lastRevision!, task);
      _needRefresh = true;
    } on TaskDSException catch (e) {
      logger.e(e.message);
      rethrow;
    }

    revisionDataSource.setRevision(result.revision);
  }

  @override
  Future<void> deleteTask(String uuid) async {
    await initIfNotInit();
    await initRevisionIfNotInit();

    var lastRevision = await revisionDataSource.getRevision();
    TaskDataSourceAnswer result;
    try {
      result = await taskDataSource!.deleteTask(lastRevision!, uuid);
    } on NotFoundException {
      logger.e('Задача $uuid не найдена');
      rethrow;
    } on RevisionException {
      logger.e('Ошибка ревизии');
      await updateRevision();
      lastRevision = await revisionDataSource.getRevision();
      result = await taskDataSource!.deleteTask(lastRevision!, uuid);
      _needRefresh = true;
    } on TaskDSException catch (e) {
      logger.e(e.message);
      rethrow;
    }

    revisionDataSource.setRevision(result.revision);
  }

  @override
  Future<List<Task>> getTasksList() async {
    await initIfNotInit();
    // Считаем, что GUI увидел, что нужно обновление и запросил его
    _needRefresh = false;

    TaskDataSourceAnswer result;
    try {
      result = await taskDataSource!.getTasksList();
    } on TaskDSException catch (e) {
      logger.e(e.message);
      rethrow;
    }

    revisionDataSource.setRevision(result.revision);
    return result.result as List<Task>;
  }

  @override
  Future<void> updateTasksList(List<Task> tasks) async =>
      throw UnimplementedError();
}
