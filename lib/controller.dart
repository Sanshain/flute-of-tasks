import 'package:collection/src/iterable_extensions.dart';
import 'package:get/get.dart';
import 'package:sanshain_tasks/models/database/database.dart';
import 'package:sanshain_tasks/models/tasks.dart';

import 'models/dao/tasks_dao.dart';
import 'models/settings.dart';


class Controller extends GetxController {

    static AppDatabase? storage;


    ///
    /// fields:
    ///

    RxMap<String, String> settings = RxMap();

    RxList<Setting> options = RxList();
    RxList<Place> places = RxList();
    RxList<Task> tasks = RxList<Task>(); // (GetStorage().read<List<int>?>('listInt') ?? []).obs
    RxList<Task> archive = RxList<Task>();

    var maxImportance = 0.obs;

    ///
    /// methods:
    ///

    void initPlaces(List<Place> _places) => places.insertAll(0, _places);
    void setTasks(_tasks) => tasks.insertAll(0, _tasks);

    Place appendPlace(Place _place) {
        places.add(_place); // запись в бд
        return _place;
    }

    ///
    /// constructor: (читаем данные с базы)
    ///

    @override void onInit() async {
        super.onInit();

        Place.objects?.getAll().then((_places) => places.insertAll(0, _places));

//        Task.tasks?.readWChildren().then((_tasks) => tasks.insertAll(0, _tasks.where((task) => task.isDone == false))); // addAll ~ insertAll
        var _tasks = await Task.tasks?.readWChildren();
        tasks.insertAll(0, (_tasks)?.where((task) => task.isDone == false) ?? []); // addAll ~ insertAll

        Task.tasks?.all().then((_tasks) => archive.insertAll(0, _tasks.where((task) {
            task.parentName = _tasks
                .where((t) => task.parent == t.id)
                .firstOrNull
                ?.title;
            return task.isDone && _tasks
                .where((t) => task.id == t.parent)
                .isEmpty;
        })));

        maxImportance = (tasks.isEmpty
            ? 0
            : tasks.reduce((a, b) => a.gravity > b.gravity ? a : b).gravity
        ).obs;

        settings['view_time'] = true.toString();

        Setting.objects = storage?.settingsManager;
        Setting.objects?.all().then((options) {
           options = options;
           for (var option in options){
               settings[option.name] = option.value;
           }
        });
    }

}















//    var count = 0.obs;
//    increment() => count++;