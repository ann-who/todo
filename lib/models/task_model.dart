// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:uuid/uuid.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

enum Importance {
  @JsonValue('low')
  low,
  @JsonValue('basic')
  basic,
  @JsonValue('important')
  important,
}

extension ImportanceExtension on Importance {
  static Importance fromString(String importance) =>
      Importance.values.firstWhere(
          (element) => element.toString().split('.').last == importance);
}

@freezed
class Task with _$Task {
  const factory Task({
    required String id,
    required String text,
    required Importance importance,
    required int deadline,
    required bool done,
    String? color,
    @JsonKey(name: 'created_at') required int createdAt,
    @JsonKey(name: 'changed_at') required int changedAt,
    @JsonKey(name: 'last_updated_by') required String lastUpdatedBy,
  }) = _Task;

  factory Task.full({
    required String text,
    Importance importance = Importance.basic,
    int deadline = -1,
    bool done = false,
    String? color,
  }) {
    var unixTime = DateTime.now().millisecondsSinceEpoch;
    return Task(
      id: const Uuid().v4(),
      text: text,
      importance: importance,
      deadline: deadline,
      done: done,
      createdAt: unixTime,
      changedAt: unixTime,
      color: color,
      lastUpdatedBy: 'dev-phone', //! TODO fix uuid
    );
  }

  factory Task.minimal(String text) {
    var unixTime = DateTime.now().millisecondsSinceEpoch;
    return Task(
      id: const Uuid().v4(),
      text: text,
      importance: Importance.basic,
      deadline: -1,
      done: false,
      createdAt: unixTime,
      changedAt: unixTime,
      lastUpdatedBy: 'dev-phone', //! TODO fix uuid
    );
  }

  factory Task.fromJson(Map<String, Object?> json) => _$TaskFromJson(json);
}
