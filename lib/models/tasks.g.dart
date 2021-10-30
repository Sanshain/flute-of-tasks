// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Place _$PlaceFromJson(Map<String, dynamic> json) {
  return Place(
    json['id'] as int?,
    json['name'] as String,
    json['isActive'] as bool,
    tasksAmount: json['tasksAmount'] as int,
  )..activeTasks = (json['activeTasks'] as List<dynamic>)
      .map((e) => Task.fromJson(e as Map<String, dynamic>))
      .toList();
}

Map<String, dynamic> _$PlaceToJson(Place instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isActive': instance.isActive,
      'activeTasks': instance.activeTasks,
      'tasksAmount': instance.tasksAmount,
    };

Task _$TaskFromJson(Map<String, dynamic> json) {
  return Task(
    json['id'] as int?,
    json['title'] as String,
    json['description'] as String,
    json['isDone'] as bool,
    DateTime.parse(json['created'] as String),
    json['deadline'] == null
        ? null
        : DateTime.parse(json['deadline'] as String),
    json['parent'] as int?,
    json['place'] as int?,
    json['gravity'] as int,
    json['duration'] as int?,
    subTasksAmount: json['subTasksAmount'] as int?,
    doneSubTasksAmount: json['doneSubTasksAmount'] as int?,
  )..parentName = json['parentName'] as String?;
}

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'parent': instance.parent,
      'place': instance.place,
      'title': instance.title,
      'description': instance.description,
      'gravity': instance.gravity,
      'isDone': instance.isDone,
      'created': instance.created.toIso8601String(),
      'duration': instance.duration,
      'deadline': instance.deadline?.toIso8601String(),
      'parentName': instance.parentName,
      'subTasksAmount': instance.subTasksAmount,
      'doneSubTasksAmount': instance.doneSubTasksAmount,
    };
