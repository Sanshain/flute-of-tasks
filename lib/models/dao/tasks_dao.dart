
import 'package:floor/floor.dart';
import 'package:some_app/models/tasks.dart';

@dao
abstract class TaskDao {

    @Query('SELECT * FROM Task')
    Future<List<Task>> all();

    @Query('SELECT * FROM Task WHERE id = :id')
    Future<Task?> findById(int id);
//    Stream<Task?> findById(int id);

    @insert
    Future<void> insertItem(Task task);

    @delete
    Future<void> deleteItem(Task task);

    @update
    Future<void> updateItem(Task task);
}