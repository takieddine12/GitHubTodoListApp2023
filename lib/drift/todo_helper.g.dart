// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_helper.dart';

// ignore_for_file: type=lint
class Tasks extends Table with TableInfo<Tasks, Task> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Tasks(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _hourMeta = const VerificationMeta('hour');
  late final GeneratedColumn<String> hour = GeneratedColumn<String>(
      'hour', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _hourFormatMeta =
      const VerificationMeta('hourFormat');
  late final GeneratedColumn<String> hourFormat = GeneratedColumn<String>(
      'hourFormat', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  @override
  List<GeneratedColumn> get $columns => [id, title, date, hour, hourFormat];
  @override
  String get aliasedName => _alias ?? 'tasks';
  @override
  String get actualTableName => 'tasks';
  @override
  VerificationContext validateIntegrity(Insertable<Task> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    if (data.containsKey('hour')) {
      context.handle(
          _hourMeta, hour.isAcceptableOrUnknown(data['hour']!, _hourMeta));
    }
    if (data.containsKey('hourFormat')) {
      context.handle(
          _hourFormatMeta,
          hourFormat.isAcceptableOrUnknown(
              data['hourFormat']!, _hourFormatMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Task(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date']),
      hour: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hour']),
      hourFormat: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hourFormat']),
    );
  }

  @override
  Tasks createAlias(String alias) {
    return Tasks(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Task extends DataClass implements Insertable<Task> {
  final int id;
  final String? title;
  final String? date;
  final String? hour;
  final String? hourFormat;
  const Task(
      {required this.id, this.title, this.date, this.hour, this.hourFormat});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<String>(date);
    }
    if (!nullToAbsent || hour != null) {
      map['hour'] = Variable<String>(hour);
    }
    if (!nullToAbsent || hourFormat != null) {
      map['hourFormat'] = Variable<String>(hourFormat);
    }
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      hour: hour == null && nullToAbsent ? const Value.absent() : Value(hour),
      hourFormat: hourFormat == null && nullToAbsent
          ? const Value.absent()
          : Value(hourFormat),
    );
  }

  factory Task.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String?>(json['title']),
      date: serializer.fromJson<String?>(json['date']),
      hour: serializer.fromJson<String?>(json['hour']),
      hourFormat: serializer.fromJson<String?>(json['hourFormat']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String?>(title),
      'date': serializer.toJson<String?>(date),
      'hour': serializer.toJson<String?>(hour),
      'hourFormat': serializer.toJson<String?>(hourFormat),
    };
  }

  Task copyWith(
          {int? id,
          Value<String?> title = const Value.absent(),
          Value<String?> date = const Value.absent(),
          Value<String?> hour = const Value.absent(),
          Value<String?> hourFormat = const Value.absent()}) =>
      Task(
        id: id ?? this.id,
        title: title.present ? title.value : this.title,
        date: date.present ? date.value : this.date,
        hour: hour.present ? hour.value : this.hour,
        hourFormat: hourFormat.present ? hourFormat.value : this.hourFormat,
      );
  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('date: $date, ')
          ..write('hour: $hour, ')
          ..write('hourFormat: $hourFormat')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, date, hour, hourFormat);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.title == this.title &&
          other.date == this.date &&
          other.hour == this.hour &&
          other.hourFormat == this.hourFormat);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<int> id;
  final Value<String?> title;
  final Value<String?> date;
  final Value<String?> hour;
  final Value<String?> hourFormat;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.date = const Value.absent(),
    this.hour = const Value.absent(),
    this.hourFormat = const Value.absent(),
  });
  TasksCompanion.insert({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.date = const Value.absent(),
    this.hour = const Value.absent(),
    this.hourFormat = const Value.absent(),
  });
  static Insertable<Task> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? date,
    Expression<String>? hour,
    Expression<String>? hourFormat,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (date != null) 'date': date,
      if (hour != null) 'hour': hour,
      if (hourFormat != null) 'hourFormat': hourFormat,
    });
  }

  TasksCompanion copyWith(
      {Value<int>? id,
      Value<String?>? title,
      Value<String?>? date,
      Value<String?>? hour,
      Value<String?>? hourFormat}) {
    return TasksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      hour: hour ?? this.hour,
      hourFormat: hourFormat ?? this.hourFormat,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (hour.present) {
      map['hour'] = Variable<String>(hour.value);
    }
    if (hourFormat.present) {
      map['hourFormat'] = Variable<String>(hourFormat.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('date: $date, ')
          ..write('hour: $hour, ')
          ..write('hourFormat: $hourFormat')
          ..write(')'))
        .toString();
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(e);
  late final Tasks tasks = Tasks(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [tasks];
}
