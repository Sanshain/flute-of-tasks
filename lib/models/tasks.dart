import 'package:floor/floor.dart';

@entity
class Task {

    Task(this.id, this.title, this.description, this.isDone, this.created, this.deadline);

    Task.init(this.title, {this.id, this.description = ''}){
        created = DateTime.now();
        isDone = false;
    }

//    @primaryKey
    @PrimaryKey(autoGenerate: true)
    final int? id;

    String title;
    String description;
    late bool isDone;

//    DateTime get deadLine => _deadline; DateTime _deadline;
//    set (DateTime _dl) {
//        isDone = false;
//        _deadline = _dl;
//    }

    late final DateTime created;
    DateTime? deadline;

    @override
    bool operator ==(Object other) {
        var isEqual = identical(this, other);
        return isEqual || other is Task && runtimeType == other.runtimeType && id == other.id;
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
