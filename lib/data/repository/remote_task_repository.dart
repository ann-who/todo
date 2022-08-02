import 'package:todo_app/data/network/revision_data_source.dart';
import 'package:todo_app/data/network/task_data_source.dart';
import 'package:todo_app/data/network/token_data_source.dart';
import 'package:todo_app/data/repository/task_repository.dart';
import 'package:todo_app/models/task_model.dart';

//! TODO обработка ошибок
// 1. Ошибки ревизии
// 2. Отсутствие интернета
// 3. Отсутствие записи
// 4. Отсутствие токена
// 5. Прочие ошибки

class RemoteTaskRepository implements TaskRepository {
  TaskDataSource? taskDataSource;
  final RevisionDataSource revisionDataSource = RevisionDataSource();
  final TokenDataSource tokenDataSource = TokenDataSource();

  RemoteTaskRepository() {
    // @dzolotov как поступить, чтобы не заливать личный ключ в репо?
    // Может, сделать диалог при первом старте, который спросит личный ключ?
    tokenDataSource.setToken('Olnnard');
  }

  Future<void> initIfNotInit() async {
    // @dzolotov тут получилось, что лениво инициализирую источник. Но, может, есть вариант лучше?
    taskDataSource ??= TaskDataSource((await tokenDataSource.getToken())!);
  }

  Future<void> initRevisionIfNotInit() async {
    var lastRevision = await revisionDataSource.getRevision();
    if (lastRevision == null) {
      // @dzolotov как сделать красиво, чтобы не гонять трафик ради одной ревизии?
      await getTasksList();
    }
  }

  @override
  Future<void> createTask(Task task) async {
    await initIfNotInit();
    await initRevisionIfNotInit();

    var lastRevision = await revisionDataSource.getRevision();
    var result = await taskDataSource!.createTask(lastRevision!, task);
    revisionDataSource.setRevision(result.revision);
  }

  @override
  Future<Task> getTask(String uuid) async {
    await initIfNotInit();

    var result = await taskDataSource!.getTask(uuid);
    revisionDataSource.setRevision(result.revision);
    return result.result as Task;
  }

  @override
  Future<void> updateTask(Task task) async {
    await initIfNotInit();
    await initRevisionIfNotInit();

    var lastRevision = await revisionDataSource.getRevision();
    var result = await taskDataSource!.updateTask(lastRevision!, task);
    revisionDataSource.setRevision(result.revision);
  }

  @override
  Future<void> deleteTask(String uuid) async {
    await initIfNotInit();
    await initRevisionIfNotInit();

    var lastRevision = await revisionDataSource.getRevision();
    var result = await taskDataSource!.deleteTask(lastRevision!, uuid);
    revisionDataSource.setRevision(result.revision);
  }

  @override
  Future<List<Task>> getTasksList() async {
    await initIfNotInit();

    var result = await taskDataSource!.getTasksList();
    revisionDataSource.setRevision(result.revision);
    return result.result as List<Task>;
  }
}
