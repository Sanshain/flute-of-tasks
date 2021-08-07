import 'package:get/get.dart';
import 'package:some_app/models/tasks.dart';

class Controller extends GetxController{
//    var count = 0.obs;
//    increment() => count++;
//    RxList<Task> tasks = [].obs;

// (GetStorage().read<List<int>?>('listInt') ?? []).obs

    RxList<Task> tasks = RxList<Task>();
//    setTasks(_tasks) => tasks = _tasks;
    setTasks(_tasks) {
        tasks.insertAll(0, _tasks);
//        tasks.setAll(0, _tasks);
//        tasks = _tasks;
    }

    @override
    void onInit() {
        super.onInit();
        print('object $tasks');
    }
}