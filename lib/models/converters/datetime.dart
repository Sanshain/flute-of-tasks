import 'package:floor/floor.dart';

class DateTimeConverter extends TypeConverter<DateTime, int> {
    @override
    DateTime decode(int databaseValue) {
        return DateTime.fromMillisecondsSinceEpoch(databaseValue);
    }

    @override
    int encode(DateTime value) {
        return value.millisecondsSinceEpoch;
    }
}


class NullableDateTimeConverter extends TypeConverter<DateTime?, int?> {
    @override
    DateTime? decode(int? databaseValue) {
        return (databaseValue ?? -1) >= 0 ? DateTime.fromMillisecondsSinceEpoch(databaseValue ?? -1) : null;
    }

    @override
    int encode(DateTime? value) {
        return value?.millisecondsSinceEpoch ?? -1;
    }
}