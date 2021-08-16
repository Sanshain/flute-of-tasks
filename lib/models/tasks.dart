import 'package:floor/floor.dart';

import 'dao/tasks_dao.dart';
import 'database/database.dart';

@entity
class Place{

    static Places? objects;
//    static TaskDao? tasksHand;

    Place(this.id, this.name, this.isActive);
    Place.init(this.name, {this.id, this.isActive = true});

    @PrimaryKey(autoGenerate: true)
    final int? id;
    final String name;
    final bool isActive;

    @ignore List<Task> activeTasks = <Task>[];

    Future<List<Task>?> get tasks async {
        if (Task.tasks != null){
            var _tasks = await Task.tasks?.getTasksFromPlace(id!);
            return _tasks;
        }
        else {
            throw Exception('static field database is not defined');
        }
    }
}


//@entity
@Entity(
    foreignKeys: [
        ForeignKey(
            childColumns: ['place'],
            parentColumns: ['id'],
            entity: Place,
        ),
        ForeignKey(
            childColumns: ['parent'],
            parentColumns: ['id'],
            entity: Task,
        )
    ],
)
class Task {

    static TaskDao? tasks;

    Task(this.id, this.title, this.description, this.isDone, this.created, this.deadline, this.parent, this.place, {
        this.subTasksAmount,
        this.doneSubTasksAmount
    });

    Task.init(this.title, {this.id, this.description = '', this.parent, this.place}){
        created = DateTime.now();
        isDone = false;
    }

//    @primaryKey
    @PrimaryKey(autoGenerate: true) final int? id;
    final int? parent;
    final int? place;

    String title;
    String description;
    late bool isDone;
    late final DateTime created;
    DateTime? deadline;

    @ignore String? parentName;
    @ignore int? subTasksAmount;    //    @ColumnInfo(name: '')
    @ignore int? doneSubTasksAmount;
    int get activeSubTasksAmount => (subTasksAmount ?? 0) - (doneSubTasksAmount ?? 0);

    //TODO:
//    Place? get actionPlace => this.place

    Future<List<Task>?> get children async {
        if (tasks != null){
            var _tasks = await tasks?.getChildren(id!);
            return _tasks;
        }
        else {
          throw Exception('static field database is not defined');
        }
    }


    @override
    bool operator ==(Object other) {
        var isEqual = identical(this, other);
        return isEqual || other is Task && runtimeType == other.runtimeType && id == other.id && title == other.title;
    }

    @override int get hashCode => id.hashCode ^ title.hashCode;
    @override String toString() => 'Task {id: $id, message: $title, isDone: $isDone}';

}



//class Task {
//    Task(this.title, {this.description = ''}){
//        created = DateTime.now();
//    }
//
//    String title;
//    String description;
//    bool isDone = false;
//
////    DateTime get deadLine => _deadline; DateTime _deadline;
////    set (DateTime _dl) {
////        isDone = false;
////        _deadline = _dl;
////    }
//
//    late DateTime created;
//    late DateTime deadline;
//}
