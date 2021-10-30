
import 'package:floor/floor.dart';
import 'package:sanshain_tasks/models/tasks.dart';

import '../settings.dart';

@dao
abstract class TaskDao {

    @Query("SELECT * FROM Task")
    Future<List<Task>> all();

    /// get end point tasks
    @Query("""
        SELECT Task.* FROM 
            Task 
            LEFT JOIN Task as childTask ON Task.id = childTask.parent
        WHERE 
            childTask.id is NULL AND Task.place = :place
    """)
//    @Query("SELECT * FROM Task WHERE place = :place")
    Future<List<Task>> getTasksFromPlace(int place);


    @Query("SELECT * FROM Task as endPoint WHERE (SELECT Count(*) FROM Task WHERE parent = endPoint.id) = 0")
    Future<List<Task>> endPointTasks();


    // todo rename to rootTasks:
    /// get root tasks
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

    // Stream<Task?> findById(int id);
    @Query('SELECT * FROM Task WHERE id = :id') Future<Task?> findById(int id);

    @Query('SELECT * FROM Task WHERE title LIKE :name') Future<Task?> findByName(String name);

    @insert Future<int?> insertItem(Task task);  // int?

    @insert Future<void> insertItems(List<Task> tasks);

    @delete Future<void> deleteItem(Task task);

    @update Future<void> updateItem(Task task);

    @update Future<void> updateTasks(List<Task> task);
}



@dao
abstract class Places {

    @Query('SELECT * FROM Place') Future<List<Place>> all();

    /// todo annotate to count of active tasks:
    /// LEFT JOIN (SELECT * FROM Task WHERE isDone = 0) as Task ON place.id = Task.place
    @Query('''        
        SELECT 
            Place.*, 
            count(Task.id) as tasksAmount
        FROM Place                                
            LEFT JOIN 
                (
                    SELECT * FROM Task as Parent WHERE (SELECT Count(*) FROM Task WHERE parent = Parent.id) = 0 AND isDone = 0
                ) as Task
            ON 
                place.id = Task.place                  
        GROUP BY Place.id    
    ''')
    Future<List<Place>> getAll();

    @insert Future<void> insertItems(List<Place> place);
    @insert Future<void> insertNew(Place place);  // returning?
    @update Future<void> updateItem(Place place);
    @delete Future<void> deleteItem(Place place);
}


@dao
abstract class SettingsManager {

    @Query('SELECT * FROM Setting') Future<List<Setting>> all();
    @insert Future<void> insertItem(Setting option);
    @update Future<void> updateItem(Setting option);
    @update Future<void> updateItems(List<Setting> option);
}