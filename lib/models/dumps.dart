import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sanshain_tasks/models/tasks.dart';


mixin ISerializable{
    Map<String, dynamic> toJson();
    // ISerializable fromJson(Map<String, dynamic> json);
}

@Deprecated('fromJSON является static, а в dart нельзя полиморфно работать со статическими методами')
class Dump<T extends ISerializable>{
    late final String name;
    Dump({required this.name});

    void save(List<T> objects) async {

        final directory = (await getExternalStorageDirectory())?.path;
        // var tasks = (await Task.tasks?.all())?.where((t) => t.isDone == false);
        var data = jsonEncode(objects.map((e) => e.toJson()).toList());
        File('$directory/tasks.json').writeAsString(data);
    }

    Future<List<T>?> read() async {

    }
}