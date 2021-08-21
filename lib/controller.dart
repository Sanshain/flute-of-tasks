import 'package:get/get.dart';
import 'package:some_app/models/tasks.dart';

class Controller extends GetxController{
    //    var count = 0.obs;
    //    increment() => count++;

    RxMap<String, String> settings = RxMap();

    RxList<Place> places = RxList();
    var maxImportance = 0.obs;
    RxList<Task> tasks = RxList<Task>();    // (GetStorage().read<List<int>?>('listInt') ?? []).obs


    void initPlaces(List<Place> _places) => places.insertAll(0, _places);
    Place appendPlace(Place _place) { places.add(_place); return _place; }

    setTasks(_tasks) => tasks.insertAll(0, _tasks);

//    @override
//    void onInit() {
//        super.onInit();
//        // читаем данные с базы?
//        Place.objects?.all().then((_places) {
//            places.insertAll(0, _places);
//        });
//    }

}