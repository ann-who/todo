import 'package:drift/drift.dart';

import 'package:todo_app/data/database/database.dart';
import 'package:todo_app/data/repository/task_repository.dart';
import 'package:todo_app/models/task_model.dart';

class LocalTaskRepository implements TaskRepository {
  final ToDoDatabase _toDoDatabase = ToDoDatabase();

  @override
  bool get needRefresh => false;

  @override
  Future<void> createTask(Task task) async =>
      await _toDoDatabase.taskTable.insertOne(
        TaskTableCompanion.insert(
          id: task.id,
          title: task.text,
          importance: task.importance.name,
          deadline: task.deadline,
          done: task.done,
          createdAt: task.createdAt,
          changedAt: task.changedAt,
          lastUpdatedBy: task.lastUpdatedBy,
        ),
      );

  @override
  Future<Task> getTask(String uuid) =>
      (_toDoDatabase.select(_toDoDatabase.taskTable)
            ..where((tbl) => tbl.id.equals(uuid)))
          .getSingle()
          .then(
            (taskEntry) => Task(
              id: taskEntry.id,
              text: taskEntry.title,
              importance: ImportanceExtension.fromString(taskEntry.importance),
              deadline: taskEntry.deadline,
              done: taskEntry.done,
              createdAt: taskEntry.createdAt,
              changedAt: taskEntry.changedAt,
              lastUpdatedBy: taskEntry.lastUpdatedBy,
            ),
          );

  @override
  Future<void> updateTask(Task task) async =>
      await (_toDoDatabase.taskTable.update()
            ..where((tbl) => tbl.id.equals(task.id)))
          .write(
        TaskTableCompanion(
          title: Value(task.text),
          importance: Value(task.importance.name),
          deadline: Value(task.deadline),
          done: Value(task.done),
          createdAt: Value(task.createdAt),
          changedAt: Value(task.changedAt),
          lastUpdatedBy: Value(task.lastUpdatedBy),
        ),
      );

  @override
  Future<void> deleteTask(String uuid) async =>
      await _toDoDatabase.taskTable.deleteWhere((tbl) => tbl.id.equals(uuid));

  @override
  Future<List<Task>> getTasksList() async => _toDoDatabase
      .select(_toDoDatabase.taskTable)
      .map((taskEntry) => Task(
            id: taskEntry.id,
            text: taskEntry.title,
            importance: ImportanceExtension.fromString(taskEntry.importance),
            deadline: taskEntry.deadline,
            done: taskEntry.done,
            createdAt: taskEntry.createdAt,
            changedAt: taskEntry.changedAt,
            lastUpdatedBy: taskEntry.lastUpdatedBy,
          ))
      .get();

  @override
  Future<List<Task>> updateTasksList(List<Task> tasks) async {
    await _toDoDatabase.delete(_toDoDatabase.taskTable).go();
    for (var task in tasks) {
      createTask(task);
    }
    return getTasksList();
  }
}
