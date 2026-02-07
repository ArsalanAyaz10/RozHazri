// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $WorkersTable extends Workers with TableInfo<$WorkersTable, Worker> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paymentTypeMeta = const VerificationMeta(
    'paymentType',
  );
  @override
  late final GeneratedColumn<String> paymentType = GeneratedColumn<String>(
    'payment_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('DAILY'),
  );
  static const VerificationMeta _rateMeta = const VerificationMeta('rate');
  @override
  late final GeneratedColumn<double> rate = GeneratedColumn<double>(
    'rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    phone,
    paymentType,
    rate,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Worker> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('payment_type')) {
      context.handle(
        _paymentTypeMeta,
        paymentType.isAcceptableOrUnknown(
          data['payment_type']!,
          _paymentTypeMeta,
        ),
      );
    }
    if (data.containsKey('rate')) {
      context.handle(
        _rateMeta,
        rate.isAcceptableOrUnknown(data['rate']!, _rateMeta),
      );
    } else if (isInserting) {
      context.missing(_rateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Worker map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Worker(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      paymentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_type'],
      )!,
      rate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rate'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WorkersTable createAlias(String alias) {
    return $WorkersTable(attachedDatabase, alias);
  }
}

class Worker extends DataClass implements Insertable<Worker> {
  final int id;
  final String name;
  final String? phone;
  final String paymentType;
  final double rate;
  final DateTime createdAt;
  const Worker({
    required this.id,
    required this.name,
    this.phone,
    required this.paymentType,
    required this.rate,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    map['payment_type'] = Variable<String>(paymentType);
    map['rate'] = Variable<double>(rate);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  WorkersCompanion toCompanion(bool nullToAbsent) {
    return WorkersCompanion(
      id: Value(id),
      name: Value(name),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      paymentType: Value(paymentType),
      rate: Value(rate),
      createdAt: Value(createdAt),
    );
  }

  factory Worker.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Worker(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      paymentType: serializer.fromJson<String>(json['paymentType']),
      rate: serializer.fromJson<double>(json['rate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'paymentType': serializer.toJson<String>(paymentType),
      'rate': serializer.toJson<double>(rate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Worker copyWith({
    int? id,
    String? name,
    Value<String?> phone = const Value.absent(),
    String? paymentType,
    double? rate,
    DateTime? createdAt,
  }) => Worker(
    id: id ?? this.id,
    name: name ?? this.name,
    phone: phone.present ? phone.value : this.phone,
    paymentType: paymentType ?? this.paymentType,
    rate: rate ?? this.rate,
    createdAt: createdAt ?? this.createdAt,
  );
  Worker copyWithCompanion(WorkersCompanion data) {
    return Worker(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      paymentType: data.paymentType.present
          ? data.paymentType.value
          : this.paymentType,
      rate: data.rate.present ? data.rate.value : this.rate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Worker(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('paymentType: $paymentType, ')
          ..write('rate: $rate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, phone, paymentType, rate, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Worker &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.paymentType == this.paymentType &&
          other.rate == this.rate &&
          other.createdAt == this.createdAt);
}

class WorkersCompanion extends UpdateCompanion<Worker> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String> paymentType;
  final Value<double> rate;
  final Value<DateTime> createdAt;
  const WorkersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.paymentType = const Value.absent(),
    this.rate = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  WorkersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.phone = const Value.absent(),
    this.paymentType = const Value.absent(),
    required double rate,
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       rate = Value(rate);
  static Insertable<Worker> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? paymentType,
    Expression<double>? rate,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (paymentType != null) 'payment_type': paymentType,
      if (rate != null) 'rate': rate,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  WorkersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? phone,
    Value<String>? paymentType,
    Value<double>? rate,
    Value<DateTime>? createdAt,
  }) {
    return WorkersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      paymentType: paymentType ?? this.paymentType,
      rate: rate ?? this.rate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (paymentType.present) {
      map['payment_type'] = Variable<String>(paymentType.value);
    }
    if (rate.present) {
      map['rate'] = Variable<double>(rate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('paymentType: $paymentType, ')
          ..write('rate: $rate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AttendanceTable extends Attendance
    with TableInfo<$AttendanceTable, AttendanceData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttendanceTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _workerIdMeta = const VerificationMeta(
    'workerId',
  );
  @override
  late final GeneratedColumn<int> workerId = GeneratedColumn<int>(
    'worker_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workers (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workingHoursMeta = const VerificationMeta(
    'workingHours',
  );
  @override
  late final GeneratedColumn<double> workingHours = GeneratedColumn<double>(
    'working_hours',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _overtimeHoursMeta = const VerificationMeta(
    'overtimeHours',
  );
  @override
  late final GeneratedColumn<double> overtimeHours = GeneratedColumn<double>(
    'overtime_hours',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _bonusMeta = const VerificationMeta('bonus');
  @override
  late final GeneratedColumn<double> bonus = GeneratedColumn<double>(
    'bonus',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _deductionMeta = const VerificationMeta(
    'deduction',
  );
  @override
  late final GeneratedColumn<double> deduction = GeneratedColumn<double>(
    'deduction',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _remarksMeta = const VerificationMeta(
    'remarks',
  );
  @override
  late final GeneratedColumn<String> remarks = GeneratedColumn<String>(
    'remarks',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workerId,
    date,
    status,
    workingHours,
    overtimeHours,
    bonus,
    deduction,
    remarks,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attendance';
  @override
  VerificationContext validateIntegrity(
    Insertable<AttendanceData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('worker_id')) {
      context.handle(
        _workerIdMeta,
        workerId.isAcceptableOrUnknown(data['worker_id']!, _workerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_workerIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('working_hours')) {
      context.handle(
        _workingHoursMeta,
        workingHours.isAcceptableOrUnknown(
          data['working_hours']!,
          _workingHoursMeta,
        ),
      );
    }
    if (data.containsKey('overtime_hours')) {
      context.handle(
        _overtimeHoursMeta,
        overtimeHours.isAcceptableOrUnknown(
          data['overtime_hours']!,
          _overtimeHoursMeta,
        ),
      );
    }
    if (data.containsKey('bonus')) {
      context.handle(
        _bonusMeta,
        bonus.isAcceptableOrUnknown(data['bonus']!, _bonusMeta),
      );
    }
    if (data.containsKey('deduction')) {
      context.handle(
        _deductionMeta,
        deduction.isAcceptableOrUnknown(data['deduction']!, _deductionMeta),
      );
    }
    if (data.containsKey('remarks')) {
      context.handle(
        _remarksMeta,
        remarks.isAcceptableOrUnknown(data['remarks']!, _remarksMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AttendanceData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttendanceData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      workerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}worker_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      workingHours: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}working_hours'],
      )!,
      overtimeHours: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}overtime_hours'],
      )!,
      bonus: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bonus'],
      )!,
      deduction: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}deduction'],
      )!,
      remarks: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remarks'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AttendanceTable createAlias(String alias) {
    return $AttendanceTable(attachedDatabase, alias);
  }
}

class AttendanceData extends DataClass implements Insertable<AttendanceData> {
  final int id;
  final int workerId;
  final DateTime date;
  final String status;
  final double workingHours;
  final double overtimeHours;
  final double bonus;
  final double deduction;
  final String? remarks;
  final DateTime createdAt;
  final DateTime updatedAt;
  const AttendanceData({
    required this.id,
    required this.workerId,
    required this.date,
    required this.status,
    required this.workingHours,
    required this.overtimeHours,
    required this.bonus,
    required this.deduction,
    this.remarks,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['worker_id'] = Variable<int>(workerId);
    map['date'] = Variable<DateTime>(date);
    map['status'] = Variable<String>(status);
    map['working_hours'] = Variable<double>(workingHours);
    map['overtime_hours'] = Variable<double>(overtimeHours);
    map['bonus'] = Variable<double>(bonus);
    map['deduction'] = Variable<double>(deduction);
    if (!nullToAbsent || remarks != null) {
      map['remarks'] = Variable<String>(remarks);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AttendanceCompanion toCompanion(bool nullToAbsent) {
    return AttendanceCompanion(
      id: Value(id),
      workerId: Value(workerId),
      date: Value(date),
      status: Value(status),
      workingHours: Value(workingHours),
      overtimeHours: Value(overtimeHours),
      bonus: Value(bonus),
      deduction: Value(deduction),
      remarks: remarks == null && nullToAbsent
          ? const Value.absent()
          : Value(remarks),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AttendanceData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttendanceData(
      id: serializer.fromJson<int>(json['id']),
      workerId: serializer.fromJson<int>(json['workerId']),
      date: serializer.fromJson<DateTime>(json['date']),
      status: serializer.fromJson<String>(json['status']),
      workingHours: serializer.fromJson<double>(json['workingHours']),
      overtimeHours: serializer.fromJson<double>(json['overtimeHours']),
      bonus: serializer.fromJson<double>(json['bonus']),
      deduction: serializer.fromJson<double>(json['deduction']),
      remarks: serializer.fromJson<String?>(json['remarks']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'workerId': serializer.toJson<int>(workerId),
      'date': serializer.toJson<DateTime>(date),
      'status': serializer.toJson<String>(status),
      'workingHours': serializer.toJson<double>(workingHours),
      'overtimeHours': serializer.toJson<double>(overtimeHours),
      'bonus': serializer.toJson<double>(bonus),
      'deduction': serializer.toJson<double>(deduction),
      'remarks': serializer.toJson<String?>(remarks),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AttendanceData copyWith({
    int? id,
    int? workerId,
    DateTime? date,
    String? status,
    double? workingHours,
    double? overtimeHours,
    double? bonus,
    double? deduction,
    Value<String?> remarks = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => AttendanceData(
    id: id ?? this.id,
    workerId: workerId ?? this.workerId,
    date: date ?? this.date,
    status: status ?? this.status,
    workingHours: workingHours ?? this.workingHours,
    overtimeHours: overtimeHours ?? this.overtimeHours,
    bonus: bonus ?? this.bonus,
    deduction: deduction ?? this.deduction,
    remarks: remarks.present ? remarks.value : this.remarks,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AttendanceData copyWithCompanion(AttendanceCompanion data) {
    return AttendanceData(
      id: data.id.present ? data.id.value : this.id,
      workerId: data.workerId.present ? data.workerId.value : this.workerId,
      date: data.date.present ? data.date.value : this.date,
      status: data.status.present ? data.status.value : this.status,
      workingHours: data.workingHours.present
          ? data.workingHours.value
          : this.workingHours,
      overtimeHours: data.overtimeHours.present
          ? data.overtimeHours.value
          : this.overtimeHours,
      bonus: data.bonus.present ? data.bonus.value : this.bonus,
      deduction: data.deduction.present ? data.deduction.value : this.deduction,
      remarks: data.remarks.present ? data.remarks.value : this.remarks,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceData(')
          ..write('id: $id, ')
          ..write('workerId: $workerId, ')
          ..write('date: $date, ')
          ..write('status: $status, ')
          ..write('workingHours: $workingHours, ')
          ..write('overtimeHours: $overtimeHours, ')
          ..write('bonus: $bonus, ')
          ..write('deduction: $deduction, ')
          ..write('remarks: $remarks, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workerId,
    date,
    status,
    workingHours,
    overtimeHours,
    bonus,
    deduction,
    remarks,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttendanceData &&
          other.id == this.id &&
          other.workerId == this.workerId &&
          other.date == this.date &&
          other.status == this.status &&
          other.workingHours == this.workingHours &&
          other.overtimeHours == this.overtimeHours &&
          other.bonus == this.bonus &&
          other.deduction == this.deduction &&
          other.remarks == this.remarks &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AttendanceCompanion extends UpdateCompanion<AttendanceData> {
  final Value<int> id;
  final Value<int> workerId;
  final Value<DateTime> date;
  final Value<String> status;
  final Value<double> workingHours;
  final Value<double> overtimeHours;
  final Value<double> bonus;
  final Value<double> deduction;
  final Value<String?> remarks;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const AttendanceCompanion({
    this.id = const Value.absent(),
    this.workerId = const Value.absent(),
    this.date = const Value.absent(),
    this.status = const Value.absent(),
    this.workingHours = const Value.absent(),
    this.overtimeHours = const Value.absent(),
    this.bonus = const Value.absent(),
    this.deduction = const Value.absent(),
    this.remarks = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AttendanceCompanion.insert({
    this.id = const Value.absent(),
    required int workerId,
    required DateTime date,
    required String status,
    this.workingHours = const Value.absent(),
    this.overtimeHours = const Value.absent(),
    this.bonus = const Value.absent(),
    this.deduction = const Value.absent(),
    this.remarks = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : workerId = Value(workerId),
       date = Value(date),
       status = Value(status);
  static Insertable<AttendanceData> custom({
    Expression<int>? id,
    Expression<int>? workerId,
    Expression<DateTime>? date,
    Expression<String>? status,
    Expression<double>? workingHours,
    Expression<double>? overtimeHours,
    Expression<double>? bonus,
    Expression<double>? deduction,
    Expression<String>? remarks,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workerId != null) 'worker_id': workerId,
      if (date != null) 'date': date,
      if (status != null) 'status': status,
      if (workingHours != null) 'working_hours': workingHours,
      if (overtimeHours != null) 'overtime_hours': overtimeHours,
      if (bonus != null) 'bonus': bonus,
      if (deduction != null) 'deduction': deduction,
      if (remarks != null) 'remarks': remarks,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AttendanceCompanion copyWith({
    Value<int>? id,
    Value<int>? workerId,
    Value<DateTime>? date,
    Value<String>? status,
    Value<double>? workingHours,
    Value<double>? overtimeHours,
    Value<double>? bonus,
    Value<double>? deduction,
    Value<String?>? remarks,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return AttendanceCompanion(
      id: id ?? this.id,
      workerId: workerId ?? this.workerId,
      date: date ?? this.date,
      status: status ?? this.status,
      workingHours: workingHours ?? this.workingHours,
      overtimeHours: overtimeHours ?? this.overtimeHours,
      bonus: bonus ?? this.bonus,
      deduction: deduction ?? this.deduction,
      remarks: remarks ?? this.remarks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (workerId.present) {
      map['worker_id'] = Variable<int>(workerId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (workingHours.present) {
      map['working_hours'] = Variable<double>(workingHours.value);
    }
    if (overtimeHours.present) {
      map['overtime_hours'] = Variable<double>(overtimeHours.value);
    }
    if (bonus.present) {
      map['bonus'] = Variable<double>(bonus.value);
    }
    if (deduction.present) {
      map['deduction'] = Variable<double>(deduction.value);
    }
    if (remarks.present) {
      map['remarks'] = Variable<String>(remarks.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceCompanion(')
          ..write('id: $id, ')
          ..write('workerId: $workerId, ')
          ..write('date: $date, ')
          ..write('status: $status, ')
          ..write('workingHours: $workingHours, ')
          ..write('overtimeHours: $overtimeHours, ')
          ..write('bonus: $bonus, ')
          ..write('deduction: $deduction, ')
          ..write('remarks: $remarks, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WorkersTable workers = $WorkersTable(this);
  late final $AttendanceTable attendance = $AttendanceTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [workers, attendance];
}

typedef $$WorkersTableCreateCompanionBuilder =
    WorkersCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> phone,
      Value<String> paymentType,
      required double rate,
      Value<DateTime> createdAt,
    });
typedef $$WorkersTableUpdateCompanionBuilder =
    WorkersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> phone,
      Value<String> paymentType,
      Value<double> rate,
      Value<DateTime> createdAt,
    });

final class $$WorkersTableReferences
    extends BaseReferences<_$AppDatabase, $WorkersTable, Worker> {
  $$WorkersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AttendanceTable, List<AttendanceData>>
  _attendanceRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.attendance,
    aliasName: $_aliasNameGenerator(db.workers.id, db.attendance.workerId),
  );

  $$AttendanceTableProcessedTableManager get attendanceRefs {
    final manager = $$AttendanceTableTableManager(
      $_db,
      $_db.attendance,
    ).filter((f) => f.workerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_attendanceRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkersTableFilterComposer
    extends Composer<_$AppDatabase, $WorkersTable> {
  $$WorkersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentType => $composableBuilder(
    column: $table.paymentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> attendanceRefs(
    Expression<bool> Function($$AttendanceTableFilterComposer f) f,
  ) {
    final $$AttendanceTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attendance,
      getReferencedColumn: (t) => t.workerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttendanceTableFilterComposer(
            $db: $db,
            $table: $db.attendance,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkersTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkersTable> {
  $$WorkersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentType => $composableBuilder(
    column: $table.paymentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkersTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkersTable> {
  $$WorkersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get paymentType => $composableBuilder(
    column: $table.paymentType,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rate =>
      $composableBuilder(column: $table.rate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> attendanceRefs<T extends Object>(
    Expression<T> Function($$AttendanceTableAnnotationComposer a) f,
  ) {
    final $$AttendanceTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attendance,
      getReferencedColumn: (t) => t.workerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttendanceTableAnnotationComposer(
            $db: $db,
            $table: $db.attendance,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkersTable,
          Worker,
          $$WorkersTableFilterComposer,
          $$WorkersTableOrderingComposer,
          $$WorkersTableAnnotationComposer,
          $$WorkersTableCreateCompanionBuilder,
          $$WorkersTableUpdateCompanionBuilder,
          (Worker, $$WorkersTableReferences),
          Worker,
          PrefetchHooks Function({bool attendanceRefs})
        > {
  $$WorkersTableTableManager(_$AppDatabase db, $WorkersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String> paymentType = const Value.absent(),
                Value<double> rate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => WorkersCompanion(
                id: id,
                name: name,
                phone: phone,
                paymentType: paymentType,
                rate: rate,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> phone = const Value.absent(),
                Value<String> paymentType = const Value.absent(),
                required double rate,
                Value<DateTime> createdAt = const Value.absent(),
              }) => WorkersCompanion.insert(
                id: id,
                name: name,
                phone: phone,
                paymentType: paymentType,
                rate: rate,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({attendanceRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (attendanceRefs) db.attendance],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (attendanceRefs)
                    await $_getPrefetchedData<
                      Worker,
                      $WorkersTable,
                      AttendanceData
                    >(
                      currentTable: table,
                      referencedTable: $$WorkersTableReferences
                          ._attendanceRefsTable(db),
                      managerFromTypedResult: (p0) => $$WorkersTableReferences(
                        db,
                        table,
                        p0,
                      ).attendanceRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.workerId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$WorkersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkersTable,
      Worker,
      $$WorkersTableFilterComposer,
      $$WorkersTableOrderingComposer,
      $$WorkersTableAnnotationComposer,
      $$WorkersTableCreateCompanionBuilder,
      $$WorkersTableUpdateCompanionBuilder,
      (Worker, $$WorkersTableReferences),
      Worker,
      PrefetchHooks Function({bool attendanceRefs})
    >;
typedef $$AttendanceTableCreateCompanionBuilder =
    AttendanceCompanion Function({
      Value<int> id,
      required int workerId,
      required DateTime date,
      required String status,
      Value<double> workingHours,
      Value<double> overtimeHours,
      Value<double> bonus,
      Value<double> deduction,
      Value<String?> remarks,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$AttendanceTableUpdateCompanionBuilder =
    AttendanceCompanion Function({
      Value<int> id,
      Value<int> workerId,
      Value<DateTime> date,
      Value<String> status,
      Value<double> workingHours,
      Value<double> overtimeHours,
      Value<double> bonus,
      Value<double> deduction,
      Value<String?> remarks,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$AttendanceTableReferences
    extends BaseReferences<_$AppDatabase, $AttendanceTable, AttendanceData> {
  $$AttendanceTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorkersTable _workerIdTable(_$AppDatabase db) => db.workers
      .createAlias($_aliasNameGenerator(db.attendance.workerId, db.workers.id));

  $$WorkersTableProcessedTableManager get workerId {
    final $_column = $_itemColumn<int>('worker_id')!;

    final manager = $$WorkersTableTableManager(
      $_db,
      $_db.workers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AttendanceTableFilterComposer
    extends Composer<_$AppDatabase, $AttendanceTable> {
  $$AttendanceTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get workingHours => $composableBuilder(
    column: $table.workingHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get overtimeHours => $composableBuilder(
    column: $table.overtimeHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bonus => $composableBuilder(
    column: $table.bonus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get deduction => $composableBuilder(
    column: $table.deduction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remarks => $composableBuilder(
    column: $table.remarks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkersTableFilterComposer get workerId {
    final $$WorkersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workerId,
      referencedTable: $db.workers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkersTableFilterComposer(
            $db: $db,
            $table: $db.workers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttendanceTableOrderingComposer
    extends Composer<_$AppDatabase, $AttendanceTable> {
  $$AttendanceTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get workingHours => $composableBuilder(
    column: $table.workingHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get overtimeHours => $composableBuilder(
    column: $table.overtimeHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bonus => $composableBuilder(
    column: $table.bonus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get deduction => $composableBuilder(
    column: $table.deduction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remarks => $composableBuilder(
    column: $table.remarks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkersTableOrderingComposer get workerId {
    final $$WorkersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workerId,
      referencedTable: $db.workers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkersTableOrderingComposer(
            $db: $db,
            $table: $db.workers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttendanceTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttendanceTable> {
  $$AttendanceTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get workingHours => $composableBuilder(
    column: $table.workingHours,
    builder: (column) => column,
  );

  GeneratedColumn<double> get overtimeHours => $composableBuilder(
    column: $table.overtimeHours,
    builder: (column) => column,
  );

  GeneratedColumn<double> get bonus =>
      $composableBuilder(column: $table.bonus, builder: (column) => column);

  GeneratedColumn<double> get deduction =>
      $composableBuilder(column: $table.deduction, builder: (column) => column);

  GeneratedColumn<String> get remarks =>
      $composableBuilder(column: $table.remarks, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$WorkersTableAnnotationComposer get workerId {
    final $$WorkersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workerId,
      referencedTable: $db.workers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkersTableAnnotationComposer(
            $db: $db,
            $table: $db.workers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttendanceTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AttendanceTable,
          AttendanceData,
          $$AttendanceTableFilterComposer,
          $$AttendanceTableOrderingComposer,
          $$AttendanceTableAnnotationComposer,
          $$AttendanceTableCreateCompanionBuilder,
          $$AttendanceTableUpdateCompanionBuilder,
          (AttendanceData, $$AttendanceTableReferences),
          AttendanceData,
          PrefetchHooks Function({bool workerId})
        > {
  $$AttendanceTableTableManager(_$AppDatabase db, $AttendanceTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttendanceTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttendanceTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttendanceTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> workerId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<double> workingHours = const Value.absent(),
                Value<double> overtimeHours = const Value.absent(),
                Value<double> bonus = const Value.absent(),
                Value<double> deduction = const Value.absent(),
                Value<String?> remarks = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => AttendanceCompanion(
                id: id,
                workerId: workerId,
                date: date,
                status: status,
                workingHours: workingHours,
                overtimeHours: overtimeHours,
                bonus: bonus,
                deduction: deduction,
                remarks: remarks,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int workerId,
                required DateTime date,
                required String status,
                Value<double> workingHours = const Value.absent(),
                Value<double> overtimeHours = const Value.absent(),
                Value<double> bonus = const Value.absent(),
                Value<double> deduction = const Value.absent(),
                Value<String?> remarks = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => AttendanceCompanion.insert(
                id: id,
                workerId: workerId,
                date: date,
                status: status,
                workingHours: workingHours,
                overtimeHours: overtimeHours,
                bonus: bonus,
                deduction: deduction,
                remarks: remarks,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AttendanceTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (workerId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.workerId,
                                referencedTable: $$AttendanceTableReferences
                                    ._workerIdTable(db),
                                referencedColumn: $$AttendanceTableReferences
                                    ._workerIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AttendanceTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AttendanceTable,
      AttendanceData,
      $$AttendanceTableFilterComposer,
      $$AttendanceTableOrderingComposer,
      $$AttendanceTableAnnotationComposer,
      $$AttendanceTableCreateCompanionBuilder,
      $$AttendanceTableUpdateCompanionBuilder,
      (AttendanceData, $$AttendanceTableReferences),
      AttendanceData,
      PrefetchHooks Function({bool workerId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WorkersTableTableManager get workers =>
      $$WorkersTableTableManager(_db, _db.workers);
  $$AttendanceTableTableManager get attendance =>
      $$AttendanceTableTableManager(_db, _db.attendance);
}
