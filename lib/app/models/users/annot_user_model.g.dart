// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'annot_user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AnnotatedUserModelAdapter extends TypeAdapter<AnnotatedUserModel> {
  @override
  final int typeId = 0;

  @override
  AnnotatedUserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnnotatedUserModel(
      id: fields[0] as String?,
      fullName: fields[1] as String?,
      phone: fields[2] as String?,
      address: fields[3] as String?,
      email: fields[4] as String?,
      role: fields[5] as String?,
      createdAt: fields[6] as DateTime?,
      updatedAt: fields[7] as DateTime?,
      v: fields[8] as int?,
      plan: fields[9] as AnnotatedPlan?,
      userModelId: fields[10] as String?,
      token: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AnnotatedUserModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fullName)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.address)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.role)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt)
      ..writeByte(8)
      ..write(obj.v)
      ..writeByte(9)
      ..write(obj.plan)
      ..writeByte(10)
      ..write(obj.userModelId)
      ..writeByte(11)
      ..write(obj.token);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnnotatedUserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AnnotatedPlanAdapter extends TypeAdapter<AnnotatedPlan> {
  @override
  final int typeId = 1;

  @override
  AnnotatedPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnnotatedPlan(
      id: fields[0] as String?,
      plan: fields[1] as String?,
      discount: fields[2] as double?,
      description: (fields[3] as List?)?.cast<String>(),
      v: fields[4] as int?,
      planId: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AnnotatedPlan obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.plan)
      ..writeByte(2)
      ..write(obj.discount)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.v)
      ..writeByte(5)
      ..write(obj.planId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnnotatedPlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
