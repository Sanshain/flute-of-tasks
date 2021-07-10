class Task {
    Task(this.title, {this.description = ''}){
        created = DateTime.now();
    }

    String title;
    String description;
    bool isDone = false;

//    DateTime get deadLine => _deadline; DateTime _deadline;
//    set (DateTime _dl) {
//        isDone = false;
//        _deadline = _dl;
//    }

    late DateTime created;
    late DateTime deadline;
}

