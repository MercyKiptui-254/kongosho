import 'package:moor_flutter/moor_flutter.dart';
import 'package:moor/moor.dart';
import 'package:moor/ffi.dart';

part 'moor_database.g.dart';

// This needs to be a top-level method because it's run on a background isolate
DatabaseConnection backgroundConnection() {
  // construct the database. You can also wrap the VmDatabase in a "LazyDatabase" if you need to run
  // work before the database opens.
  final database = FlutterQueryExecutor.inDatabaseFolder(
    path: 'trial.sqlite', //TODO:change to db.sqlite if errors come
    // Good for debugging - prints SQL in the console
    logStatements: true,
  ) ;
  return DatabaseConnection.fromExecutor(database);
}

//@DataClassName('BolusRecord')
class BolusRecords extends Table {
  IntColumn get id => integer().autoIncrement()();

  RealColumn get bolusAmount => real()();

  DateTimeColumn get timeStamp => dateTime()();
}

//@DataClassName('BasalRecord')
class BasalRecords extends Table {
  IntColumn get id => integer().autoIncrement()();

  RealColumn get basalAmount => real()();

  DateTimeColumn get timeStamp => dateTime()();
}

// this annotation tells moor to prepare a database class that uses the tables we just defined.
@UseMoor(
    tables: [BolusRecords, BasalRecords],
    daos: [BolusRecordDao, BasalRecordDao])
class AppDatabase extends _$AppDatabase {
  //constructor that works for mobile:
  AppDatabase()
  // Specify the location of the database file
      : super(FlutterQueryExecutor.inDatabaseFolder(
    path: 'trial.sqlite', //TODO:change to db.sqlite if errors come
    // Good for debugging - prints SQL in the console
    logStatements: true,
  ));
// this is the new constructor
  AppDatabase.connect(DatabaseConnection connection) : super.connect(connection);
  // Bump this when changing tables and columns.
  // Migrations will be covered in the next part.
  @override
  int get schemaVersion => 1;
}

@UseDao(tables: [BolusRecords])
class BolusRecordDao extends DatabaseAccessor<AppDatabase>
    with _$BolusRecordDaoMixin {
  final AppDatabase db;

  // Called by the AppDatabase class
  BolusRecordDao(this.db) : super(db);

  // All tables have getters in the generated class - we can select the users table
  Future<List<BolusRecord>> getAllBolusRecords() => select(bolusRecords).get();

  // Moor supports Streams which emit elements when the watched data changes
  Stream<List<BolusRecord>> watchAllBolusRecords() =>
      select(bolusRecords).watch();

  // Get an individual row by their id
  Future<BolusRecord> getBolusRecord(int id) =>
      (select(bolusRecords)
        ..where((bolusRecord) => bolusRecord.id.equals(id)))
          .getSingle();

  // Add a record into the database
  Future insertBolusRecord(Insertable<BolusRecord> bolusRecord) =>
      into(bolusRecords).insert(bolusRecord);

  // Updates a User with a matching primary key
  Future updateBolusRecord(Insertable<BolusRecord> bolusRecord) =>
      update(bolusRecords).replace(bolusRecord);

  // Remove a row from the db
  Future deleteBolusRecord(BolusRecord bolusRecord) =>
      delete(bolusRecords).delete(bolusRecord);
}

@UseDao(tables: [BasalRecords])
class BasalRecordDao extends DatabaseAccessor<AppDatabase>
    with _$BasalRecordDaoMixin {
  final AppDatabase db;

  // Called by the AppDatabase class
  BasalRecordDao(this.db) : super(db);

  // All tables have getters in the generated class - we can select the users table
  Future<List<BasalRecord>> getAllBasalRecords() => select(basalRecords).get();

  // Moor supports Streams which emit elements when the watched data changes
  Stream<List<BasalRecord>> watchAllBasalRecords() =>
      select(basalRecords).watch();

  // Get an individual row by their id
  Future<BasalRecord> getBasalRecord(int id) =>
      (select(basalRecords)
        ..where((basalRecord) => basalRecord.id.equals(id)))
          .getSingle();

  // Add a record into the database
  Future insertBasalRecord(Insertable<BasalRecord> basalRecord) =>
      into(basalRecords).insert(basalRecord);

  // Updates a User with a matching primary key
  Future updateBasalRecord(Insertable<BasalRecord> basalRecord) =>
      update(basalRecords).replace(basalRecord);

  // Remove a row from the db
  Future deleteBasalRecord(BasalRecord basalRecord) =>
      delete(basalRecords).delete(basalRecord);
}


