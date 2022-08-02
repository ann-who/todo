import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:todo_app/models/task_model.dart';

//! TODO check internet connection or catch this error
//! TODO update tasks list

class TaskDataSourceAnswer {
  int revision;
  Object result;

  TaskDataSourceAnswer(this.revision, this.result);
}

class TaskDSException implements Exception {
  String message;
  TaskDSException([this.message = '']);
}

class RevisionException extends TaskDSException {
  RevisionException([String message = '']) : super(message);
}

class NotFoundException extends TaskDSException {
  NotFoundException([String message = '']) : super(message);
}

class TaskDataSource {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://beta.mrdekk.ru/todobackend',
      connectTimeout: 5000,
      receiveTimeout: 3000,
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
        throw TaskDSException(
            "При создании задачи возникла ошибка. Попробуйте повторить позже.");
      }

      rethrow;
    }

    var result = response.data;
    return TaskDataSourceAnswer(
      result['revision'],
      Task.fromJson(result['element']),
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
        throw NotFoundException(
            'Не удалось получить задачу. Возможно, она была удалена.');
      } else if (e.response!.statusCode != HttpStatus.ok) {
        throw TaskDSException(
            "При получении задачи возникла ошибка. Попробуйте повторить позже.");
      }

      rethrow;
    }

    var result = response.data;
    return TaskDataSourceAnswer(
      result['revision'],
      Task.fromJson(result['element']),
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
        throw NotFoundException(
            'Не удалось изменить задачу. Возможно, она была удалена.');
      } else if (e.response!.statusCode != HttpStatus.ok) {
        throw TaskDSException(
            "При изменении задачи возникла ошибка. Попробуйте повторить позже.");
      }

      rethrow;
    }

    var result = response.data;
    return TaskDataSourceAnswer(
      result['revision'],
      Task.fromJson(result['element']),
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
        throw NotFoundException(
            'Не удалось удалить задачу. Возможно, она уже была удалена.');
      } else if (e.response!.statusCode != HttpStatus.ok) {
        throw TaskDSException(
            "При удалении задачи возникла ошибка. Попробуйте повторить позже.");
      }

      rethrow;
    }

    var result = response.data;
    return TaskDataSourceAnswer(
      result['revision'],
      Task.fromJson(result['element']),
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
        throw TaskDSException(
            "При получении списка задач возникла ошибка. Попробуйте повторить позже.");
      }

      rethrow;
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
