import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/resources/app_constants.dart';

class TaskDataSourceAnswer {
  int revision;
  Object result;

  TaskDataSourceAnswer({required this.revision, required this.result});
}

class TaskDSException implements Exception {
  String message;
  TaskDSException([this.message = WidgetsSettings.dsError]);
}

class RevisionException extends TaskDSException {
  RevisionException([String message = WidgetsSettings.revisionError])
      : super(message);
}

class NotFoundException extends TaskDSException {
  NotFoundException([String message = WidgetsSettings.notFound])
      : super(message);
}

class TaskDataSource {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: WidgetsSettings.baseUrl,
      connectTimeout: WidgetsSettings.connectTimeout,
      receiveTimeout: WidgetsSettings.receiveTimeout,
    ),
  );

  TaskDataSource(String token) {
    _dio.options.headers = {'Authorization': 'Bearer $token'};
  }

  Future<TaskDataSourceAnswer> createTask(int lastRevision, Task task) async {
    Response response;
    try {
      response = await _dio.post(
        '/list',
        options: Options(
          headers: {
            'X-Last-Known-Revision': lastRevision.toString(),
            'Content-Type': 'application/json'
          },
        ),
        data: jsonEncode({'element': task.toJson()}),
      );
    } on DioError catch (e) {
      if (e.response == null) {
        rethrow;
      }

      if (e.response!.statusCode == HttpStatus.badRequest) {
        throw RevisionException();
      } else if (e.response!.statusCode != HttpStatus.ok) {
        throw TaskDSException();
      }

      rethrow;
    }

    var result = response.data;
    return TaskDataSourceAnswer(
      revision: result['revision'],
      result: Task.fromJson(result['element']),
    );
  }

  Future<TaskDataSourceAnswer> getTask(String uuid) async {
    Response response;
    try {
      response = await _dio.get('/list/$uuid');
    } on DioError catch (e) {
      if (e.response == null) {
        rethrow;
      }

      if (e.response!.statusCode == HttpStatus.notFound) {
        throw NotFoundException();
      } else if (e.response!.statusCode != HttpStatus.ok) {
        throw TaskDSException();
      }

      rethrow;
    }

    var result = response.data;
    return TaskDataSourceAnswer(
      revision: result['revision'],
      result: Task.fromJson(result['element']),
    );
  }

  Future<TaskDataSourceAnswer> updateTask(int lastRevision, Task task) async {
    Response response;
    try {
      response = await _dio.put(
        '/list/${task.id}',
        options: Options(
          headers: {
            'X-Last-Known-Revision': lastRevision.toString(),
            'Content-Type': 'application/json'
          },
        ),
        data: jsonEncode({'element': task.toJson()}),
      );
    } on DioError catch (e) {
      if (e.response == null) {
        rethrow;
      }

      if (e.response!.statusCode == HttpStatus.badRequest) {
        throw RevisionException();
      } else if (e.response!.statusCode == HttpStatus.notFound) {
        throw NotFoundException();
      } else if (e.response!.statusCode != HttpStatus.ok) {
        throw TaskDSException();
      }

      rethrow;
    }

    var result = response.data;
    return TaskDataSourceAnswer(
      revision: result['revision'],
      result: Task.fromJson(result['element']),
    );
  }

  Future<TaskDataSourceAnswer> deleteTask(int lastRevision, String uuid) async {
    Response response;
    try {
      response = await _dio.delete(
        '/list/$uuid',
        options: Options(
          headers: {
            'X-Last-Known-Revision': lastRevision.toString(),
          },
        ),
      );
    } on DioError catch (e) {
      if (e.response == null) {
        rethrow;
      }

      if (e.response!.statusCode == HttpStatus.badRequest) {
        throw RevisionException();
      } else if (e.response!.statusCode == HttpStatus.notFound) {
        throw NotFoundException();
      } else if (e.response!.statusCode != HttpStatus.ok) {
        throw TaskDSException();
      }

      rethrow;
    }

    var result = response.data;
    return TaskDataSourceAnswer(
      revision: result['revision'],
      result: Task.fromJson(result['element']),
    );
  }

  Future<TaskDataSourceAnswer> getTasksList() async {
    Response response;
    try {
      response = await _dio.get('/list');
    } on DioError catch (e) {
      if (e.response == null) {
        rethrow;
      }

      if (e.response!.statusCode != HttpStatus.ok) {
        throw TaskDSException();
      }

      rethrow;
    }

    var result = response.data;
    List<Task> tasksList = (result['list'] as List)
        .map((element) => Task.fromJson(element))
        .toList();

    return TaskDataSourceAnswer(
      revision: result['revision'],
      result: tasksList,
    );
  }

  Future<TaskDataSourceAnswer> updateTasksList(
      int lastRevision, List<Task> tasksList) async {
    Response response;
    try {
      response = await _dio.patch(
        '/list',
        options: Options(
          headers: {
            'X-Last-Known-Revision': lastRevision.toString(),
            'Content-Type': 'application/json'
          },
        ),
        data: jsonEncode({'list': tasksList}),
      );
    } on DioError catch (e) {
      if (e.response == null) {
        rethrow;
      }

      if (e.response!.statusCode != HttpStatus.ok) {
        throw TaskDSException();
      }

      rethrow;
    }

    var result = response.data;
    List<Task> resultTasksList = (result['list'] as List)
        .map((element) => Task.fromJson(element))
        .toList();

    return TaskDataSourceAnswer(
      revision: result['revision'],
      result: resultTasksList,
    );
  }
}
