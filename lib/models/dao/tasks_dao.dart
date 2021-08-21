
import 'package:floor/floor.dart';
import 'package:some_app/models/tasks.dart';

@dao
abstract class TaskDao {

    @Query("SELECT * FROM Task")
    Future<List<Task>> all();


    @Query("""
        SELECT EndPointTasks.* FROM 
            Task as EndPointTasks 
            LEFT JOIN Task as child ON EndPointTasks.id = child.parent
        WHERE 
            child.id is NULL AND EndPointTasks.place = :place
    """)
//    @Query("SELECT * FROM Task WHERE place = :place")
    Future<List<Task>> getTasksFromPlace(int place);


    @Query("SELECT * FROM Task as EndPointTask WHERE (SELECT Count(*) FROM Task WHERE parent = EndPointTask.id) = 0")
    Future<List<Task>> endPointTasks();


    // todo rename to rootTasks:
    @Query("""
        SELECT
           parent_task.*, count(children.id) as subTasksAmount,
           SUM(children.isDone) as doneSubTasksAmount	
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
           parent_task.*, count(children.id) as subTasksAmount,           
           SUM(children.isDone) as doneSubTasksAmount	
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



@dao
abstract class Places {
    @Query('SELECT * FROM Place')
    Future<List<Place>> all();

    /// todo annotate to count of active tasks:
    @Query('''        
        SELECT 
            Place.*, 
            count(Task.id) as tasksAmount
        FROM Place 
            LEFT JOIN (SELECT * FROM Task WHERE isDone = 1) as Task ON place.id = Task.place 
        GROUP BY Place.id    
    ''')
    Future<List<Place>> getAll();

    @insert Future<void> insertNew(Place place);
    @update Future<void> updateItem(Place place);
    @delete Future<void> deleteItem(Place place);
}


