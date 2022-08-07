// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: type=lint
class ToDoProperties extends DataClass implements Insertable<ToDoProperties> {
  final String id;
  final String title;
  final String importance;
  final int deadline;
  final bool done;
  final String? color;
  final int createdAt;
  final int changedAt;
  final String lastUpdatedBy;
  ToDoProperties(
      {required this.id,
      required this.title,
      required this.importance,
      required this.deadline,
      required this.done,
      this.color,
      required this.createdAt,
      required this.changedAt,
      required this.lastUpdatedBy});
  factory ToDoProperties.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return ToDoProperties(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
      importance: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}importance'])!,
      deadline: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}deadline'])!,
      done: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}done'])!,
      color: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}color']),
      createdAt: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at'])!,
      changedAt: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}changed_at'])!,
      lastUpdatedBy: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}last_updated_by'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['importance'] = Variable<String>(importance);
    map['deadline'] = Variable<int>(deadline);
    map['done'] = Variable<bool>(done);
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String?>(color);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['changed_at'] = Variable<int>(changedAt);
    map['last_updated_by'] = Variable<String>(lastUpdatedBy);
    return map;
  }

  TaskTableCompanion toCompanion(bool nullToAbsent) {
    return TaskTableCompanion(
      id: Value(id),
      title: Value(title),
      importance: Value(importance),
      deadline: Value(deadline),
      done: Value(done),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
      createdAt: Value(createdAt),
      changedAt: Value(changedAt),
      lastUpdatedBy: Value(lastUpdatedBy),
    );
  }

  factory ToDoProperties.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ToDoProperties(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      importance: serializer.fromJson<String>(json['importance']),
      deadline: serializer.fromJson<int>(json['deadline']),
      done: serializer.fromJson<bool>(json['done']),
      color: serializer.fromJson<String?>(json['color']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      changedAt: serializer.fromJson<int>(json['changedAt']),
      lastUpdatedBy: serializer.fromJson<String>(json['lastUpdatedBy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'importance': serializer.toJson<String>(importance),
      'deadline': serializer.toJson<int>(deadline),
      'done': serializer.toJson<bool>(done),
      'color': serializer.toJson<String?>(color),
      'createdAt': serializer.toJson<int>(createdAt),
      'changedAt': serializer.toJson<int>(changedAt),
      'lastUpdatedBy': serializer.toJson<String>(lastUpdatedBy),
    };
  }

  ToDoProperties copyWith(
          {String? id,
          String? title,
          String? importance,
          int? deadline,
          bool? done,
          String? color,
          int? createdAt,
          int? changedAt,
          String? lastUpdatedBy}) =>
      ToDoProperties(
        id: id ?? this.id,
        title: title ?? this.title,
        importance: importance ?? this.importance,
        deadline: deadline ?? this.deadline,
        done: done ?? this.done,
        color: color ?? this.color,
        createdAt: createdAt ?? this.createdAt,
        changedAt: changedAt ?? this.changedAt,
        lastUpdatedBy: lastUpdatedBy ?? this.lastUpdatedBy,
      );
  @override
  String toString() {
    return (StringBuffer('ToDoProperties(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('importance: $importance, ')
          ..write('deadline: $deadline, ')
          ..write('done: $done, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt, ')
          ..write('changedAt: $changedAt, ')
          ..write('lastUpdatedBy: $lastUpdatedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, importance, deadline, done, color,
      createdAt, changedAt, lastUpdatedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ToDoProperties &&
          other.id == this.id &&
          other.title == this.title &&
          other.importance == this.importance &&
          other.deadline == this.deadline &&
          other.done == this.done &&
          other.color == this.color &&
          other.createdAt == this.createdAt &&
          other.changedAt == this.changedAt &&
          other.lastUpdatedBy == this.lastUpdatedBy);
}

class TaskTableCompanion extends UpdateCompanion<ToDoProperties> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> importance;
  final Value<int> deadline;
  final Value<bool> done;
  final Value<String?> color;
  final Value<int> createdAt;
  final Value<int> changedAt;
  final Value<String> lastUpdatedBy;
  const TaskTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.importance = const Value.absent(),
    this.deadline = const Value.absent(),
    this.done = const Value.absent(),
    this.color = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.changedAt = const Value.absent(),
    this.lastUpdatedBy = const Value.absent(),
  });
  TaskTableCompanion.insert({
    required String id,
    required String title,
    required String importance,
    required int deadline,
    required bool done,
    this.color = const Value.absent(),
    required int createdAt,
    required int changedAt,
    required String lastUpdatedBy,
  })  : id = Value(id),
        title = Value(title),
        importance = Value(importance),
        deadline = Value(deadline),
        done = Value(done),
        createdAt = Value(createdAt),
        changedAt = Value(changedAt),
        lastUpdatedBy = Value(lastUpdatedBy);
  static Insertable<ToDoProperties> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? importance,
    Expression<int>? deadline,
    Expression<bool>? done,
    Expression<String?>? color,
    Expression<int>? createdAt,
    Expression<int>? changedAt,
    Expression<String>? lastUpdatedBy,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (importance != null) 'importance': importance,
      if (deadline != null) 'deadline': deadline,
      if (done != null) 'done': done,
      if (color != null) 'color': color,
      if (createdAt != null) 'created_at': createdAt,
      if (changedAt != null) 'changed_at': changedAt,
      if (lastUpdatedBy != null) 'last_updated_by': lastUpdatedBy,
    });
  }

  TaskTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? importance,
      Value<int>? deadline,
      Value<bool>? done,
      Value<String?>? color,
      Value<int>? createdAt,
      Value<int>? changedAt,
      Value<String>? lastUpdatedBy}) {
    return TaskTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      importance: importance ?? this.importance,
      deadline: deadline ?? this.deadline,
      done: done ?? this.done,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      changedAt: changedAt ?? this.changedAt,
      lastUpdatedBy: lastUpdatedBy ?? this.lastUpdatedBy,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (importance.present) {
      map['importance'] = Variable<String>(importance.value);
    }
    if (deadline.present) {
      map['deadline'] = Variable<int>(deadline.value);
    }
    if (done.present) {
      map['done'] = Variable<bool>(done.value);
    }
    if (color.present) {
      map['color'] = Variable<String?>(color.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (changedAt.present) {
      map['changed_at'] = Variable<int>(changedAt.value);
    }
    if (lastUpdatedBy.present) {
      map['last_updated_by'] = Variable<String>(lastUpdatedBy.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('importance: $importance, ')
          ..write('deadline: $deadline, ')
          ..write('done: $done, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt, ')
          ..write('changedAt: $changedAt, ')
          ..write('lastUpdatedBy: $lastUpdatedBy')
          ..write(')'))
        .toString();
  }
}

class $TaskTableTable extends TaskTable
    with TableInfo<$TaskTableTable, ToDoProperties> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskTableTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String?> id = GeneratedColumn<String?>(
      'id', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String?> title = GeneratedColumn<String?>(
      'title', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _importanceMeta = const VerificationMeta('importance');
  @override
  late final GeneratedColumn<String?> importance = GeneratedColumn<String?>(
      'importance', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _deadlineMeta = const VerificationMeta('deadline');
  @override
  late final GeneratedColumn<int?> deadline = GeneratedColumn<int?>(
      'deadline', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _doneMeta = const VerificationMeta('done');
  @override
  late final GeneratedColumn<bool?> done = GeneratedColumn<bool?>(
      'done', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: true,
      defaultConstraints: 'CHECK (done IN (0, 1))');
  final VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String?> color = GeneratedColumn<String?>(
      'color', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int?> createdAt = GeneratedColumn<int?>(
      'created_at', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _changedAtMeta = const VerificationMeta('changedAt');
  @override
  late final GeneratedColumn<int?> changedAt = GeneratedColumn<int?>(
      'changed_at', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _lastUpdatedByMeta =
      const VerificationMeta('lastUpdatedBy');
  @override
  late final GeneratedColumn<String?> lastUpdatedBy = GeneratedColumn<String?>(
      'last_updated_by', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        importance,
        deadline,
        done,
        color,
        createdAt,
        changedAt,
        lastUpdatedBy
      ];
  @override
  String get aliasedName => _alias ?? 'task_table';
  @override
  String get actualTableName => 'task_table';
  @override
  VerificationContext validateIntegrity(Insertable<ToDoProperties> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('importance')) {
      context.handle(
          _importanceMeta,
          importance.isAcceptableOrUnknown(
              data['importance']!, _importanceMeta));
    } else if (isInserting) {
      context.missing(_importanceMeta);
    }
    if (data.containsKey('deadline')) {
      context.handle(_deadlineMeta,
          deadline.isAcceptableOrUnknown(data['deadline']!, _deadlineMeta));
    } else if (isInserting) {
      context.missing(_deadlineMeta);
    }
    if (data.containsKey('done')) {
      context.handle(
          _doneMeta, done.isAcceptableOrUnknown(data['done']!, _doneMeta));
    } else if (isInserting) {
      context.missing(_doneMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('changed_at')) {
      context.handle(_changedAtMeta,
          changedAt.isAcceptableOrUnknown(data['changed_at']!, _changedAtMeta));
    } else if (isInserting) {
      context.missing(_changedAtMeta);
    }
    if (data.containsKey('last_updated_by')) {
      context.handle(
          _lastUpdatedByMeta,
          lastUpdatedBy.isAcceptableOrUnknown(
              data['last_updated_by']!, _lastUpdatedByMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedByMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ToDoProperties map(Map<String, dynamic> data, {String? tablePrefix}) {
    return ToDoProperties.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $TaskTableTable createAlias(String alias) {
    return $TaskTableTable(attachedDatabase, alias);
  }
}

abstract class _$ToDoDatabase extends GeneratedDatabase {
  _$ToDoDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $TaskTableTable taskTable = $TaskTableTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [taskTable];
}
