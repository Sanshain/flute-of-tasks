import 'package:collection/src/iterable_extensions.dart';
import 'package:get/get.dart';
import 'package:sanshain_tasks/models/tasks.dart';


class Controller extends GetxController {


    RxMap<String, String> settings = RxMap();

    RxList<Place> places = RxList();
    RxList<Task> tasks = RxList<Task>(); // (GetStorage().read<List<int>?>('listInt') ?? []).obs
    RxList<Task> archive = RxList<Task>();

    var maxImportance = 0.obs;


    void initPlaces(List<Place> _places) => places.insertAll(0, _places);

    Place appendPlace(Place _place) {
        places.add(_place); // запись в бд
        return _place;
    }

    setTasks(_tasks) => tasks.insertAll(0, _tasks);


    /// читаем данные с базы
    @override void onInit() {
        super.onInit();

        Place.objects?.all().then((_places) => places.insertAll(0, _places));
        Task.tasks?.readWChildren().then((_tasks) => tasks.insertAll(0, _tasks.where((task) => task.isDone == false))); // addAll ~ insertAll
        Task.tasks?.all().then((_tasks) => archive.insertAll(0, _tasks.where((task) {
            task.parentName = _tasks
                .where((t) => task.parent == t.id)
                .firstOrNull
                ?.title;
            return task.isDone && _tasks
                .where((t) => task.id == t.parent)
                .isEmpty;
        })));

        maxImportance = tasks
            .reduce((a, b) => a.gravity > b.gravity ? a : b)
            .gravity
            .obs;
    }

}


//    var count = 0.obs;
//    increment() => count++;