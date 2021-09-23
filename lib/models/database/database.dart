import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sanshain_tasks/models/converters/datetime.dart';
import 'package:sanshain_tasks/models/dao/tasks_dao.dart';
import 'package:sanshain_tasks/models/tasks.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart'; // the generated code will be there

@TypeConverters([DateTimeConverter, NullableDateTimeConverter])
@Database(version: 1, entities: [Task, Place])
abstract class AppDatabase extends FloorDatabase {
    TaskDao get taskDao;
    Places get placesHandler;
}