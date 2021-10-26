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

  SettingsManager? _settingsManagerInstance;

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
            'CREATE TABLE IF NOT EXISTS `Task` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `parent` INTEGER, `place` INTEGER, `title` TEXT NOT NULL, `description` TEXT NOT NULL, `gravity` INTEGER NOT NULL, `isDone` INTEGER NOT NULL, `created` INTEGER NOT NULL, `duration` INTEGER, `deadline` INTEGER, FOREIGN KEY (`place`) REFERENCES `Place` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`parent`) REFERENCES `Task` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Place` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `isActive` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Setting` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `value` TEXT NOT NULL)');

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

  @override
  SettingsManager get settingsManager {
    return _settingsManagerInstance ??=
        _$SettingsManager(database, changeListener);
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
                  'gravity': item.gravity,
                  'isDone': item.isDone ? 1 : 0,
                  'created': _dateTimeConverter.encode(item.created),
                  'duration': item.duration,
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
                  'gravity': item.gravity,
                  'isDone': item.isDone ? 1 : 0,
                  'created': _dateTimeConverter.encode(item.created),
                  'duration': item.duration,
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
                  'gravity': item.gravity,
                  'isDone': item.isDone ? 1 : 0,
                  'created': _dateTimeConverter.encode(item.created),
                  'duration': item.duration,
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
            row['place'] as int?,
            row['gravity'] as int,
            row['duration'] as int?));
  }

  @override
  Future<List<Task>> getTasksFromPlace(int place) async {
    return _queryAdapter.queryList(
        'SELECT Task.* FROM              Task              LEFT JOIN Task as childTask ON Task.id = childTask.parent         WHERE              childTask.id is NULL AND Task.place = ?1',
        mapper: (Map<String, Object?> row) => Task(row['id'] as int?, row['title'] as String, row['description'] as String, (row['isDone'] as int) != 0, _dateTimeConverter.decode(row['created'] as int), _nullableDateTimeConverter.decode(row['deadline'] as int?), row['parent'] as int?, row['place'] as int?, row['gravity'] as int, row['duration'] as int?),
        arguments: [place]);
  }

  @override
  Future<List<Task>> endPointTasks() async {
    return _queryAdapter.queryList(
        'SELECT * FROM Task as endPoint WHERE (SELECT Count(*) FROM Task WHERE parent = endPoint.id) = 0',
        mapper: (Map<String, Object?> row) => Task(
            row['id'] as int?,
            row['title'] as String,
            row['description'] as String,
            (row['isDone'] as int) != 0,
            _dateTimeConverter.decode(row['created'] as int),
            _nullableDateTimeConverter.decode(row['deadline'] as int?),
            row['parent'] as int?,
            row['place'] as int?,
            row['gravity'] as int,
            row['duration'] as int?));
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
            row['gravity'] as int,
            row['duration'] as int?,
            subTasksAmount: row['subTasksAmount'] as int?,
            doneSubTasksAmount: row['doneSubTasksAmount'] as int?
        ));
  }

  @override
  Future<List<Task>> getChildren(int id) async {
    return _queryAdapter.queryList(
        'SELECT            parent_task.*, count(children.id) as subTasksAmount,                       SUM(children.isDone) as doneSubTasksAmount	         FROM            "Task" as parent_task             LEFT OUTER JOIN               "Task" AS children                ON children.parent = parent_task.id         WHERE            parent_task.parent = ?1         GROUP BY parent_task.id;',
        mapper: (Map<String, Object?> row) => Task(
            row['id'] as int?, row['title'] as String, row['description'] as String, (row['isDone'] as int) != 0, _dateTimeConverter.decode(row['created'] as int), _nullableDateTimeConverter.decode(row['deadline'] as int?), row['parent'] as int?, row['place'] as int?, row['gravity'] as int, row['duration'] as int?,
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
            row['place'] as int?,
            row['gravity'] as int,
            row['duration'] as int?),
        arguments: [id]);
  }

  @override
  Future<Task?> findByName(String name) async {
    return _queryAdapter.query('SELECT * FROM Task WHERE title LIKE :name',
        mapper: (Map<String, Object?> row) => Task(
            row['id'] as int?,
            row['title'] as String,
            row['description'] as String,
            (row['isDone'] as int) != 0,
            _dateTimeConverter.decode(row['created'] as int),
            _nullableDateTimeConverter.decode(row['deadline'] as int?),
            row['parent'] as int?,
            row['place'] as int?,
            row['gravity'] as int,
            row['duration'] as int?),
        arguments: [name]);
  }

  @override
  Future<int?> insertItem(Task task) async {
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
      : _queryAdapter = QueryAdapter(database),
        _placeInsertionAdapter = InsertionAdapter(
            database,
            'Place',
            (Place item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'isActive': item.isActive ? 1 : 0
                }),
        _placeUpdateAdapter = UpdateAdapter(
            database,
            'Place',
            ['id'],
            (Place item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'isActive': item.isActive ? 1 : 0
                }),
        _placeDeletionAdapter = DeletionAdapter(
            database,
            'Place',
            ['id'],
            (Place item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'isActive': item.isActive ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Place> _placeInsertionAdapter;

  final UpdateAdapter<Place> _placeUpdateAdapter;

  final DeletionAdapter<Place> _placeDeletionAdapter;

  @override
  Future<List<Place>> all() async {
    return _queryAdapter.queryList('SELECT * FROM Place',
        mapper: (Map<String, Object?> row) => Place(row['id'] as int?,
            row['name'] as String, (row['isActive'] as int) != 0));
  }

  @override
  Future<List<Place>> getAll() async {
    var r =  _queryAdapter.queryList(
        'SELECT              Place.*,              count(Task.id) as tasksAmount         FROM Place                                             LEFT JOIN                  (                     SELECT * FROM Task as Parent WHERE (SELECT Count(*) FROM Task WHERE parent = Parent.id) = 0 AND isDone = 0                 ) as Task             ON                  place.id = Task.place                           GROUP BY Place.id',
        mapper: (Map<String, Object?> row) => Place(row['id'] as int?,
            row['name'] as String, (row['isActive'] as int) != 0,
            tasksAmount: row['tasksAmount'] as int
        ));
    return r;
  }

  @override
  Future<void> insertNew(Place place) async {
    await _placeInsertionAdapter.insert(place, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateItem(Place place) async {
    await _placeUpdateAdapter.update(place, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteItem(Place place) async {
    await _placeDeletionAdapter.delete(place);
  }
}

class _$SettingsManager extends SettingsManager {
  _$SettingsManager(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _settingInsertionAdapter = InsertionAdapter(
            database,
            'Setting',
            (Setting item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'value': item.value
                }),
        _settingUpdateAdapter = UpdateAdapter(
            database,
            'Setting',
            ['id'],
            (Setting item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'value': item.value
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Setting> _settingInsertionAdapter;

  final UpdateAdapter<Setting> _settingUpdateAdapter;

  @override
  Future<List<Setting>> all() async {
    return _queryAdapter.queryList('SELECT * FROM Setting',
        mapper: (Map<String, Object?> row) => Setting(
            row['id'] as int?, row['name'] as String, row['value'] as String));
  }

  @override
  Future<void> insertItem(Setting option) async {
    await _settingInsertionAdapter.insert(option, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateItem(Setting option) async {
    await _settingUpdateAdapter.update(option, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateItems(List<Setting> option) async {
    await _settingUpdateAdapter.updateList(option, OnConflictStrategy.abort);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
final _nullableDateTimeConverter = NullableDateTimeConverter();
