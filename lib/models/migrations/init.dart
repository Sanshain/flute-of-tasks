import 'package:floor/floor.dart';

// create migration
final migration_1To2 = Migration(1, 2, (database) async {
    await database.execute('''
            ALTER TABLE "Task" 
                ADD COLUMN "parent" INT REFERENCES "Task"("id") DEFERRABLE INITIALLY DEFERRED;        
        ''');
});