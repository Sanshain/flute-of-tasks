
import 'package:floor/floor.dart';
import 'package:some_app/models/tasks.dart';

@dao
abstract class TaskDao {

    @Query('SELECT * FROM Task')
    Future<List<Task>> all();

    @Query("""
        SELECT
           parent_task.*, count(children.id) as subTasksAmount
        FROM
           "Task" as parent_task 
           LEFT OUTER JOIN
              "Task" AS children 
              ON children.parent = parent_task.id
        WHERE
           parent_task.parent is NULL
        GROUP BY parent_task.id;    
    """)
    Future<List<Task>> readWChildren();

    @Query("""
        SELECT
           parent_task.*, count(children.id) as subTasksAmount
        FROM
           "Task" as parent_task 
           LEFT OUTER JOIN
              "Task" AS children 
              ON children.parent = parent_task.id
        WHERE
           parent_task.parent = :id
        GROUP BY parent_task.id;    
    """)
    Future<List<Task>> getChildren(int id);

    @Query('SELECT * FROM Task WHERE id = :id')
    Future<Task?> findById(int id);
//    Stream<Task?> findById(int id);

    @insert
    Future<void> insertItem(Task task);

    @delete
    Future<void> deleteItem(Task task);

    @update
    Future<void> updateItem(Task task);

    @update
    Future<void> updateTasks(List<Task> task);
}