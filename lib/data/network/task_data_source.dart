import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:todo_app/models/task_model.dart';

//! TODO check internet connection or catch this error

class TaskDataSourceAnswer {
  int revision;
  Object result;

  TaskDataSourceAnswer(this.revision, this.result);
}

class TaskDataSource {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://beta.mrdekk.ru/todobackend',
      connectTimeout: 5000,
      receiveTimeout: 3000,
    ),
  );
  final String token;

  TaskDataSource(this.token) {
    _dio.options.headers = {'Authorization': 'Bearer $token'};
  }

  Future<TaskDataSourceAnswer> createTask(int lastRevision, Task task) async {
    Response response = await _dio.post(
      '/list',
      options: Options(
        headers: {
          'X-Last-Known-Revision': lastRevision.toString(),
          'Content-Type': 'application/json'
        },
      ),
      data: jsonEncode({'element': task.toJson()}),
    );

    if (response.statusCode == HttpStatus.badRequest) {
      // TODO throw revision error
    } else if (response.statusCode != HttpStatus.ok) {
      // TODO throw unknown error
    }

    var result = response.data;
    return TaskDataSourceAnswer(
      result['revision'],
      Task.fromJson(result['element']),
    );
  }

  Future<TaskDataSourceAnswer> getTask(String uuid) async {
    Response response = await _dio.get('/list/$uuid');

    if (response.statusCode == HttpStatus.notFound) {
      // TODO throw not found error
    } else if (response.statusCode != HttpStatus.ok) {
      // TODO throw unknown error
    }

    var result = response.data;
    return TaskDataSourceAnswer(
      result['revision'],
      Task.fromJson(result['element']),
    );
  }

  Future<TaskDataSourceAnswer> updateTask(int lastRevision, Task task) async {
    Response response = await _dio.put(
      '/list/${task.id}',
      options: Options(
        headers: {
          'X-Last-Known-Revision': lastRevision.toString(),
          'Content-Type': 'application/json'
        },
      ),
      data: jsonEncode({'element': task.toJson()}),
    );

    if (response.statusCode == HttpStatus.badRequest) {
      // TODO throw revision error
    } else if (response.statusCode == HttpStatus.notFound) {
      // TODO throw not found error
    } else if (response.statusCode != HttpStatus.ok) {
      // TODO throw unknown error
    }

    var result = response.data;
    return TaskDataSourceAnswer(
      result['revision'],
      Task.fromJson(result['element']),
    );
  }

  Future<TaskDataSourceAnswer> deleteTask(int lastRevision, String uuid) async {
    Response response = await _dio.delete(
      '/list/$uuid',
      options: Options(
        headers: {
          'X-Last-Known-Revision': lastRevision.toString(),
        },
      ),
    );

    if (response.statusCode == HttpStatus.badRequest) {
      // TODO throw revision error
    } else if (response.statusCode == HttpStatus.notFound) {
      // TODO throw not found error
    } else if (response.statusCode != HttpStatus.ok) {
      // TODO throw unknown error
    }

    var result = response.data;
    return TaskDataSourceAnswer(
      result['revision'],
      Task.fromJson(result['element']),
    );
  }

  //! TODO update tasks list

  Future<TaskDataSourceAnswer> getTasksList() async {
    Response response = await _dio.get('/list');

    if (response.statusCode != HttpStatus.ok) {
      // TODO throw unknown error
    }

    var result = response.data;
    List<Task> tasksList = (result['list'] as List)
        .map((element) => Task.fromJson(element))
        .toList();
    return TaskDataSourceAnswer(
      result['revision'],
      tasksList,
    );
  }
}
