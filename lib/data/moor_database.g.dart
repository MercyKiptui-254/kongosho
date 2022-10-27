// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class BolusRecord extends DataClass implements Insertable<BolusRecord> {
  final int id;
  final double bolusAmount;
  final DateTime timeStamp;
  BolusRecord(
      {@required this.id,
      @required this.bolusAmount,
      @required this.timeStamp});
  factory BolusRecord.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final doubleType = db.typeSystem.forDartType<double>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return BolusRecord(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      bolusAmount: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}bolus_amount']),
      timeStamp: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}time_stamp']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || bolusAmount != null) {
      map['bolus_amount'] = Variable<double>(bolusAmount);
    }
    if (!nullToAbsent || timeStamp != null) {
      map['time_stamp'] = Variable<DateTime>(timeStamp);
    }
    return map;
  }

  BolusRecordsCompanion toCompanion(bool nullToAbsent) {
    return BolusRecordsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      bolusAmount: bolusAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(bolusAmount),
      timeStamp: timeStamp == null && nullToAbsent
          ? const Value.absent()
          : Value(timeStamp),
    );
  }

  factory BolusRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return BolusRecord(
      id: serializer.fromJson<int>(json['id']),
      bolusAmount: serializer.fromJson<double>(json['bolusAmount']),
      timeStamp: serializer.fromJson<DateTime>(json['timeStamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bolusAmount': serializer.toJson<double>(bolusAmount),
      'timeStamp': serializer.toJson<DateTime>(timeStamp),
    };
  }

  BolusRecord copyWith({int id, double bolusAmount, DateTime timeStamp}) =>
      BolusRecord(
        id: id ?? this.id,
        bolusAmount: bolusAmount ?? this.bolusAmount,
        timeStamp: timeStamp ?? this.timeStamp,
      );
  @override
  String toString() {
    return (StringBuffer('BolusRecord(')
          ..write('id: $id, ')
          ..write('bolusAmount: $bolusAmount, ')
          ..write('timeStamp: $timeStamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf(
      $mrjc(id.hashCode, $mrjc(bolusAmount.hashCode, timeStamp.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is BolusRecord &&
          other.id == this.id &&
          other.bolusAmount == this.bolusAmount &&
          other.timeStamp == this.timeStamp);
}

class BolusRecordsCompanion extends UpdateCompanion<BolusRecord> {
  final Value<int> id;
  final Value<double> bolusAmount;
  final Value<DateTime> timeStamp;
  const BolusRecordsCompanion({
    this.id = const Value.absent(),
    this.bolusAmount = const Value.absent(),
    this.timeStamp = const Value.absent(),
  });
  BolusRecordsCompanion.insert({
    this.id = const Value.absent(),
    @required double bolusAmount,
    @required DateTime timeStamp,
  })  : bolusAmount = Value(bolusAmount),
        timeStamp = Value(timeStamp);
  static Insertable<BolusRecord> custom({
    Expression<int> id,
    Expression<double> bolusAmount,
    Expression<DateTime> timeStamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bolusAmount != null) 'bolus_amount': bolusAmount,
      if (timeStamp != null) 'time_stamp': timeStamp,
    });
  }

  BolusRecordsCompanion copyWith(
      {Value<int> id, Value<double> bolusAmount, Value<DateTime> timeStamp}) {
    return BolusRecordsCompanion(
      id: id ?? this.id,
      bolusAmount: bolusAmount ?? this.bolusAmount,
      timeStamp: timeStamp ?? this.timeStamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bolusAmount.present) {
      map['bolus_amount'] = Variable<double>(bolusAmount.value);
    }
    if (timeStamp.present) {
      map['time_stamp'] = Variable<DateTime>(timeStamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BolusRecordsCompanion(')
          ..write('id: $id, ')
          ..write('bolusAmount: $bolusAmount, ')
          ..write('timeStamp: $timeStamp')
          ..write(')'))
        .toString();
  }
}

class $BolusRecordsTable extends BolusRecords
    with TableInfo<$BolusRecordsTable, BolusRecord> {
  final GeneratedDatabase _db;
  final String _alias;
  $BolusRecordsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _bolusAmountMeta =
      const VerificationMeta('bolusAmount');
  GeneratedRealColumn _bolusAmount;
  @override
  GeneratedRealColumn get bolusAmount =>
      _bolusAmount ??= _constructBolusAmount();
  GeneratedRealColumn _constructBolusAmount() {
    return GeneratedRealColumn(
      'bolus_amount',
      $tableName,
      false,
    );
  }

  final VerificationMeta _timeStampMeta = const VerificationMeta('timeStamp');
  GeneratedDateTimeColumn _timeStamp;
  @override
  GeneratedDateTimeColumn get timeStamp => _timeStamp ??= _constructTimeStamp();
  GeneratedDateTimeColumn _constructTimeStamp() {
    return GeneratedDateTimeColumn(
      'time_stamp',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, bolusAmount, timeStamp];
  @override
  $BolusRecordsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'bolus_records';
  @override
  final String actualTableName = 'bolus_records';
  @override
  VerificationContext validateIntegrity(Insertable<BolusRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('bolus_amount')) {
      context.handle(
          _bolusAmountMeta,
          bolusAmount.isAcceptableOrUnknown(
              data['bolus_amount'], _bolusAmountMeta));
    } else if (isInserting) {
      context.missing(_bolusAmountMeta);
    }
    if (data.containsKey('time_stamp')) {
      context.handle(_timeStampMeta,
          timeStamp.isAcceptableOrUnknown(data['time_stamp'], _timeStampMeta));
    } else if (isInserting) {
      context.missing(_timeStampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BolusRecord map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return BolusRecord.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $BolusRecordsTable createAlias(String alias) {
    return $BolusRecordsTable(_db, alias);
  }
}

class BasalRecord extends DataClass implements Insertable<BasalRecord> {
  final int id;
  final double basalAmount;
  final DateTime timeStamp;
  BasalRecord(
      {@required this.id,
      @required this.basalAmount,
      @required this.timeStamp});
  factory BasalRecord.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final doubleType = db.typeSystem.forDartType<double>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return BasalRecord(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      basalAmount: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}basal_amount']),
      timeStamp: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}time_stamp']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || basalAmount != null) {
      map['basal_amount'] = Variable<double>(basalAmount);
    }
    if (!nullToAbsent || timeStamp != null) {
      map['time_stamp'] = Variable<DateTime>(timeStamp);
    }
    return map;
  }

  BasalRecordsCompanion toCompanion(bool nullToAbsent) {
    return BasalRecordsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      basalAmount: basalAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(basalAmount),
      timeStamp: timeStamp == null && nullToAbsent
          ? const Value.absent()
          : Value(timeStamp),
    );
  }

  factory BasalRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return BasalRecord(
      id: serializer.fromJson<int>(json['id']),
      basalAmount: serializer.fromJson<double>(json['basalAmount']),
      timeStamp: serializer.fromJson<DateTime>(json['timeStamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'basalAmount': serializer.toJson<double>(basalAmount),
      'timeStamp': serializer.toJson<DateTime>(timeStamp),
    };
  }

  BasalRecord copyWith({int id, double basalAmount, DateTime timeStamp}) =>
      BasalRecord(
        id: id ?? this.id,
        basalAmount: basalAmount ?? this.basalAmount,
        timeStamp: timeStamp ?? this.timeStamp,
      );
  @override
  String toString() {
    return (StringBuffer('BasalRecord(')
          ..write('id: $id, ')
          ..write('basalAmount: $basalAmount, ')
          ..write('timeStamp: $timeStamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf(
      $mrjc(id.hashCode, $mrjc(basalAmount.hashCode, timeStamp.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is BasalRecord &&
          other.id == this.id &&
          other.basalAmount == this.basalAmount &&
          other.timeStamp == this.timeStamp);
}

class BasalRecordsCompanion extends UpdateCompanion<BasalRecord> {
  final Value<int> id;
  final Value<double> basalAmount;
  final Value<DateTime> timeStamp;
  const BasalRecordsCompanion({
    this.id = const Value.absent(),
    this.basalAmount = const Value.absent(),
    this.timeStamp = const Value.absent(),
  });
  BasalRecordsCompanion.insert({
    this.id = const Value.absent(),
    @required double basalAmount,
    @required DateTime timeStamp,
  })  : basalAmount = Value(basalAmount),
        timeStamp = Value(timeStamp);
  static Insertable<BasalRecord> custom({
    Expression<int> id,
    Expression<double> basalAmount,
    Expression<DateTime> timeStamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (basalAmount != null) 'basal_amount': basalAmount,
      if (timeStamp != null) 'time_stamp': timeStamp,
    });
  }

  BasalRecordsCompanion copyWith(
      {Value<int> id, Value<double> basalAmount, Value<DateTime> timeStamp}) {
    return BasalRecordsCompanion(
      id: id ?? this.id,
      basalAmount: basalAmount ?? this.basalAmount,
      timeStamp: timeStamp ?? this.timeStamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (basalAmount.present) {
      map['basal_amount'] = Variable<double>(basalAmount.value);
    }
    if (timeStamp.present) {
      map['time_stamp'] = Variable<DateTime>(timeStamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BasalRecordsCompanion(')
          ..write('id: $id, ')
          ..write('basalAmount: $basalAmount, ')
          ..write('timeStamp: $timeStamp')
          ..write(')'))
        .toString();
  }
}

class $BasalRecordsTable extends BasalRecords
    with TableInfo<$BasalRecordsTable, BasalRecord> {
  final GeneratedDatabase _db;
  final String _alias;
  $BasalRecordsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _basalAmountMeta =
      const VerificationMeta('basalAmount');
  GeneratedRealColumn _basalAmount;
  @override
  GeneratedRealColumn get basalAmount =>
      _basalAmount ??= _constructBasalAmount();
  GeneratedRealColumn _constructBasalAmount() {
    return GeneratedRealColumn(
      'basal_amount',
      $tableName,
      false,
    );
  }

  final VerificationMeta _timeStampMeta = const VerificationMeta('timeStamp');
  GeneratedDateTimeColumn _timeStamp;
  @override
  GeneratedDateTimeColumn get timeStamp => _timeStamp ??= _constructTimeStamp();
  GeneratedDateTimeColumn _constructTimeStamp() {
    return GeneratedDateTimeColumn(
      'time_stamp',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, basalAmount, timeStamp];
  @override
  $BasalRecordsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'basal_records';
  @override
  final String actualTableName = 'basal_records';
  @override
  VerificationContext validateIntegrity(Insertable<BasalRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('basal_amount')) {
      context.handle(
          _basalAmountMeta,
          basalAmount.isAcceptableOrUnknown(
              data['basal_amount'], _basalAmountMeta));
    } else if (isInserting) {
      context.missing(_basalAmountMeta);
    }
    if (data.containsKey('time_stamp')) {
      context.handle(_timeStampMeta,
          timeStamp.isAcceptableOrUnknown(data['time_stamp'], _timeStampMeta));
    } else if (isInserting) {
      context.missing(_timeStampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BasalRecord map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return BasalRecord.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $BasalRecordsTable createAlias(String alias) {
    return $BasalRecordsTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  _$AppDatabase.connect(DatabaseConnection c) : super.connect(c);
  $BolusRecordsTable _bolusRecords;
  $BolusRecordsTable get bolusRecords =>
      _bolusRecords ??= $BolusRecordsTable(this);
  $BasalRecordsTable _basalRecords;
  $BasalRecordsTable get basalRecords =>
      _basalRecords ??= $BasalRecordsTable(this);
  BolusRecordDao _bolusRecordDao;
  BolusRecordDao get bolusRecordDao =>
      _bolusRecordDao ??= BolusRecordDao(this as AppDatabase);
  BasalRecordDao _basalRecordDao;
  BasalRecordDao get basalRecordDao =>
      _basalRecordDao ??= BasalRecordDao(this as AppDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [bolusRecords, basalRecords];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$BolusRecordDaoMixin on DatabaseAccessor<AppDatabase> {
  $BolusRecordsTable get bolusRecords => attachedDatabase.bolusRecords;
}
mixin _$BasalRecordDaoMixin on DatabaseAccessor<AppDatabase> {
  $BasalRecordsTable get basalRecords => attachedDatabase.basalRecords;
}
