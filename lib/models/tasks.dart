import 'package:floor/floor.dart';

@entity
class Task {

    Task(this.title, {this.description = ''}){
        created = DateTime.now();
    }

//    @primaryKey
    @PrimaryKey(autoGenerate: true)
    late final int id;

    String title;
    String description;
    bool isDone = false;

//    DateTime get deadLine => _deadline; DateTime _deadline;
//    set (DateTime _dl) {
//        isDone = false;
//        _deadline = _dl;
//    }

    late final DateTime created;
    late DateTime deadline;

    @override
    bool operator ==(Object other) {
        var isEqual = identical(this, other);
        return isEqual || other is Task && runtimeType == other.runtimeType && id == other.id;
    }

    @override int get hashCode => id.hashCode ^ title.hashCode;
    @override String toString() => 'Task{id: $id, message: $title}';

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
