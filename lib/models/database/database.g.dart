// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  TaskDao? _taskDaoInstance;

  Places? _placesHandlerInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Task` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `parent` INTEGER, `place` INTEGER, `title` TEXT NOT NULL, `description` TEXT NOT NULL, `isDone` INTEGER NOT NULL, `created` INTEGER NOT NULL, `deadline` INTEGER, FOREIGN KEY (`place`) REFERENCES `Place` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`parent`) REFERENCES `Task` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Place` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `isActive` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TaskDao get taskDao {
    return _taskDaoInstance ??= _$TaskDao(database, changeListener);
  }

  @override
  Places get placesHandler {
    return _placesHandlerInstance ??= _$Places(database, changeListener);
  }
}

class _$TaskDao extends TaskDao {
  _$TaskDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _taskInsertionAdapter = InsertionAdapter(
            database,
            'Task',
            (Task item) => <String, Object?>{
                  'id': item.id,
                  'parent': item.parent,
                  'place': item.place,
                  'title': item.title,
                  'description': item.description,
                  'isDone': item.isDone ? 1 : 0,
                  'created': _dateTimeConverter.encode(item.created),
                  'deadline': _nullableDateTimeConverter.encode(item.deadline)
                }),
        _taskUpdateAdapter = UpdateAdapter(
            database,
            'Task',
            ['id'],
            (Task item) => <String, Object?>{
                  'id': item.id,
                  'parent': item.parent,
                  'place': item.place,
                  'title': item.title,
                  'description': item.description,
                  'isDone': item.isDone ? 1 : 0,
                  'created': _dateTimeConverter.encode(item.created),
                  'deadline': _nullableDateTimeConverter.encode(item.deadline)
                }),
        _taskDeletionAdapter = DeletionAdapter(
            database,
            'Task',
            ['id'],
            (Task item) => <String, Object?>{
                  'id': item.id,
                  'parent': item.parent,
                  'place': item.place,
                  'title': item.title,
                  'description': item.description,
                  'isDone': item.isDone ? 1 : 0,
                  'created': _dateTimeConverter.encode(item.created),
                  'deadline': _nullableDateTimeConverter.encode(item.deadline)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Task> _taskInsertionAdapter;

  final UpdateAdapter<Task> _taskUpdateAdapter;

  final DeletionAdapter<Task> _taskDeletionAdapter;

  @override
  Future<List<Task>> all() async {
    return _queryAdapter.queryList('SELECT * FROM Task',
        mapper: (Map<String, Object?> row) => Task(
            row['id'] as int?,
            row['title'] as String,
            row['description'] as String,
            (row['isDone'] as int) != 0,
            _dateTimeConverter.decode(row['created'] as int),
            _nullableDateTimeConverter.decode(row['deadline'] as int?),
            row['parent'] as int?,
            row['place'] as int?));
  }

  @override
  Future<List<Task>> getTasksFromPlace(int place) async {
    return _queryAdapter.queryList(
        'SELECT EndPointTasks.* FROM              Task as EndPointTasks              LEFT JOIN Task as child ON EndPointTasks.id = child.parent         WHERE              child.id is NULL AND EndPointTasks.place = ?1',
        mapper: (Map<String, Object?> row) => Task(row['id'] as int?, row['title'] as String, row['description'] as String, (row['isDone'] as int) != 0, _dateTimeConverter.decode(row['created'] as int), _nullableDateTimeConverter.decode(row['deadline'] as int?), row['parent'] as int?, row['place'] as int?),
        arguments: [place]);
  }

  @override
  Future<List<Task>> endPointTasks() async {
    return _queryAdapter.queryList(
        'SELECT * FROM Task as EndPointTask WHERE (SELECT Count(*) FROM Task WHERE parent = EndPointTask.id) = 0',
        mapper: (Map<String, Object?> row) => Task(
            row['id'] as int?,
            row['title'] as String,
            row['description'] as String,
            (row['isDone'] as int) != 0,
            _dateTimeConverter.decode(row['created'] as int),
            _nullableDateTimeConverter.decode(row['deadline'] as int?),
            row['parent'] as int?,
            row['place'] as int?));
  }

  @override
  Future<List<Task>> readWChildren() async {
    return _queryAdapter.queryList(
        'SELECT            parent_task.*, count(children.id) as subTasksAmount,            SUM(children.isDone) as doneSubTasksAmount	         FROM            "Task" as parent_task             LEFT OUTER JOIN               "Task" AS children                ON children.parent = parent_task.id         WHERE            parent_task.parent is NULL         GROUP BY parent_task.id;',
        mapper: (Map<String, Object?> row) => Task(
            row['id'] as int?,
            row['title'] as String,
            row['description'] as String,
            (row['isDone'] as int) != 0,
            _dateTimeConverter.decode(row['created'] as int),
            _nullableDateTimeConverter.decode(row['deadline'] as int?),
            row['parent'] as int?,
            row['place'] as int?,
            subTasksAmount: row['subTasksAmount'] as int?,
            doneSubTasksAmount: row['doneSubTasksAmount'] as int?
        ));
  }

  @override
  Future<List<Task>> getChildren(int id) async {
    return _queryAdapter.queryList(
        'SELECT            parent_task.*, count(children.id) as subTasksAmount,                       SUM(children.isDone) as doneSubTasksAmount	         FROM            "Task" as parent_task             LEFT OUTER JOIN               "Task" AS children                ON children.parent = parent_task.id         WHERE            parent_task.parent = ?1         GROUP BY parent_task.id;',
        mapper: (Map<String, Object?> row) => Task(
            row['id'] as int?, row['title'] as String, row['description'] as String, (row['isDone'] as int) != 0, _dateTimeConverter.decode(row['created'] as int), _nullableDateTimeConverter.decode(row['deadline'] as int?), row['parent'] as int?, row['place'] as int?,
            subTasksAmount: row['subTasksAmount'] as int?,
            doneSubTasksAmount: row['doneSubTasksAmount'] as int?
        ),
        arguments: [id]);
  }

  @override
  Future<Task?> findById(int id) async {
    return _queryAdapter.query('SELECT * FROM Task WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Task(
            row['id'] as int?,
            row['title'] as String,
            row['description'] as String,
            (row['isDone'] as int) != 0,
            _dateTimeConverter.decode(row['created'] as int),
            _nullableDateTimeConverter.decode(row['deadline'] as int?),
            row['parent'] as int?,
            row['place'] as int?),
        arguments: [id]);
  }

  @override
  Future<void> insertItem(Task task) async {
    await _taskInsertionAdapter.insert(task, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateItem(Task task) async {
    await _taskUpdateAdapter.update(task, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateTasks(List<Task> task) async {
    await _taskUpdateAdapter.updateList(task, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteItem(Task task) async {
    await _taskDeletionAdapter.delete(task);
  }
}

class _$Places extends Places {
  _$Places(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  @override
  Future<List<Task>> all() async {
    return _queryAdapter.queryList('SELECT * FROM Place',
        mapper: (Map<String, Object?> row) => Task(
            row['id'] as int?,
            row['title'] as String,
            row['description'] as String,
            (row['isDone'] as int) != 0,
            _dateTimeConverter.decode(row['created'] as int),
            _nullableDateTimeConverter.decode(row['deadline'] as int?),
            row['parent'] as int?,
            row['place'] as int?));
  }

  @override
  Future<List<Task>> getAll() async {
    return _queryAdapter.queryList('SELECT * FROM Place',
        mapper: (Map<String, Object?> row) => Task(
            row['id'] as int?,
            row['title'] as String,
            row['description'] as String,
            (row['isDone'] as int) != 0,
            _dateTimeConverter.decode(row['created'] as int),
            _nullableDateTimeConverter.decode(row['deadline'] as int?),
            row['parent'] as int?,
            row['place'] as int?));
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
final _nullableDateTimeConverter = NullableDateTimeConverter();
