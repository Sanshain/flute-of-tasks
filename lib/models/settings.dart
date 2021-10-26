import 'package:floor/floor.dart';

import 'dao/tasks_dao.dart';

@entity
class Setting{

    const Setting(this.id, this.name, this.value);
    Setting.init(this.name, {this.id, this.value = "true"});

    @PrimaryKey(autoGenerate: true) final int? id;
    final String name;
    final String value;

    static SettingsManager? objects;
}

