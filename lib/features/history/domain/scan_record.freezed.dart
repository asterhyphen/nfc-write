// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scan_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScanRecord {

 String get id; DateTime get scannedAt; String get tagType; String get content; bool get isFavorite; String? get profileName;
/// Create a copy of ScanRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScanRecordCopyWith<ScanRecord> get copyWith => _$ScanRecordCopyWithImpl<ScanRecord>(this as ScanRecord, _$identity);

  /// Serializes this ScanRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScanRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.scannedAt, scannedAt) || other.scannedAt == scannedAt)&&(identical(other.tagType, tagType) || other.tagType == tagType)&&(identical(other.content, content) || other.content == content)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.profileName, profileName) || other.profileName == profileName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,scannedAt,tagType,content,isFavorite,profileName);

@override
String toString() {
  return 'ScanRecord(id: $id, scannedAt: $scannedAt, tagType: $tagType, content: $content, isFavorite: $isFavorite, profileName: $profileName)';
}


}

/// @nodoc
abstract mixin class $ScanRecordCopyWith<$Res>  {
  factory $ScanRecordCopyWith(ScanRecord value, $Res Function(ScanRecord) _then) = _$ScanRecordCopyWithImpl;
@useResult
$Res call({
 String id, DateTime scannedAt, String tagType, String content, bool isFavorite, String? profileName
});




}
/// @nodoc
class _$ScanRecordCopyWithImpl<$Res>
    implements $ScanRecordCopyWith<$Res> {
  _$ScanRecordCopyWithImpl(this._self, this._then);

  final ScanRecord _self;
  final $Res Function(ScanRecord) _then;

/// Create a copy of ScanRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? scannedAt = null,Object? tagType = null,Object? content = null,Object? isFavorite = null,Object? profileName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,scannedAt: null == scannedAt ? _self.scannedAt : scannedAt // ignore: cast_nullable_to_non_nullable
as DateTime,tagType: null == tagType ? _self.tagType : tagType // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,profileName: freezed == profileName ? _self.profileName : profileName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ScanRecord].
extension ScanRecordPatterns on ScanRecord {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScanRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScanRecord() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScanRecord value)  $default,){
final _that = this;
switch (_that) {
case _ScanRecord():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScanRecord value)?  $default,){
final _that = this;
switch (_that) {
case _ScanRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime scannedAt,  String tagType,  String content,  bool isFavorite,  String? profileName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScanRecord() when $default != null:
return $default(_that.id,_that.scannedAt,_that.tagType,_that.content,_that.isFavorite,_that.profileName);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime scannedAt,  String tagType,  String content,  bool isFavorite,  String? profileName)  $default,) {final _that = this;
switch (_that) {
case _ScanRecord():
return $default(_that.id,_that.scannedAt,_that.tagType,_that.content,_that.isFavorite,_that.profileName);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime scannedAt,  String tagType,  String content,  bool isFavorite,  String? profileName)?  $default,) {final _that = this;
switch (_that) {
case _ScanRecord() when $default != null:
return $default(_that.id,_that.scannedAt,_that.tagType,_that.content,_that.isFavorite,_that.profileName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScanRecord implements ScanRecord {
  const _ScanRecord({required this.id, required this.scannedAt, required this.tagType, required this.content, this.isFavorite = false, this.profileName});
  factory _ScanRecord.fromJson(Map<String, dynamic> json) => _$ScanRecordFromJson(json);

@override final  String id;
@override final  DateTime scannedAt;
@override final  String tagType;
@override final  String content;
@override@JsonKey() final  bool isFavorite;
@override final  String? profileName;

/// Create a copy of ScanRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScanRecordCopyWith<_ScanRecord> get copyWith => __$ScanRecordCopyWithImpl<_ScanRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScanRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScanRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.scannedAt, scannedAt) || other.scannedAt == scannedAt)&&(identical(other.tagType, tagType) || other.tagType == tagType)&&(identical(other.content, content) || other.content == content)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.profileName, profileName) || other.profileName == profileName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,scannedAt,tagType,content,isFavorite,profileName);

@override
String toString() {
  return 'ScanRecord(id: $id, scannedAt: $scannedAt, tagType: $tagType, content: $content, isFavorite: $isFavorite, profileName: $profileName)';
}


}

/// @nodoc
abstract mixin class _$ScanRecordCopyWith<$Res> implements $ScanRecordCopyWith<$Res> {
  factory _$ScanRecordCopyWith(_ScanRecord value, $Res Function(_ScanRecord) _then) = __$ScanRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime scannedAt, String tagType, String content, bool isFavorite, String? profileName
});




}
/// @nodoc
class __$ScanRecordCopyWithImpl<$Res>
    implements _$ScanRecordCopyWith<$Res> {
  __$ScanRecordCopyWithImpl(this._self, this._then);

  final _ScanRecord _self;
  final $Res Function(_ScanRecord) _then;

/// Create a copy of ScanRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? scannedAt = null,Object? tagType = null,Object? content = null,Object? isFavorite = null,Object? profileName = freezed,}) {
  return _then(_ScanRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,scannedAt: null == scannedAt ? _self.scannedAt : scannedAt // ignore: cast_nullable_to_non_nullable
as DateTime,tagType: null == tagType ? _self.tagType : tagType // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,profileName: freezed == profileName ? _self.profileName : profileName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
