// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nfc_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NfcTemplate {

 String get id; String get title; String get description; String get category; String get payloadType; String get defaultPayload; String get iconName; bool get isCustom;
/// Create a copy of NfcTemplate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NfcTemplateCopyWith<NfcTemplate> get copyWith => _$NfcTemplateCopyWithImpl<NfcTemplate>(this as NfcTemplate, _$identity);

  /// Serializes this NfcTemplate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NfcTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.payloadType, payloadType) || other.payloadType == payloadType)&&(identical(other.defaultPayload, defaultPayload) || other.defaultPayload == defaultPayload)&&(identical(other.iconName, iconName) || other.iconName == iconName)&&(identical(other.isCustom, isCustom) || other.isCustom == isCustom));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,category,payloadType,defaultPayload,iconName,isCustom);

@override
String toString() {
  return 'NfcTemplate(id: $id, title: $title, description: $description, category: $category, payloadType: $payloadType, defaultPayload: $defaultPayload, iconName: $iconName, isCustom: $isCustom)';
}


}

/// @nodoc
abstract mixin class $NfcTemplateCopyWith<$Res>  {
  factory $NfcTemplateCopyWith(NfcTemplate value, $Res Function(NfcTemplate) _then) = _$NfcTemplateCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, String category, String payloadType, String defaultPayload, String iconName, bool isCustom
});




}
/// @nodoc
class _$NfcTemplateCopyWithImpl<$Res>
    implements $NfcTemplateCopyWith<$Res> {
  _$NfcTemplateCopyWithImpl(this._self, this._then);

  final NfcTemplate _self;
  final $Res Function(NfcTemplate) _then;

/// Create a copy of NfcTemplate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? category = null,Object? payloadType = null,Object? defaultPayload = null,Object? iconName = null,Object? isCustom = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,payloadType: null == payloadType ? _self.payloadType : payloadType // ignore: cast_nullable_to_non_nullable
as String,defaultPayload: null == defaultPayload ? _self.defaultPayload : defaultPayload // ignore: cast_nullable_to_non_nullable
as String,iconName: null == iconName ? _self.iconName : iconName // ignore: cast_nullable_to_non_nullable
as String,isCustom: null == isCustom ? _self.isCustom : isCustom // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [NfcTemplate].
extension NfcTemplatePatterns on NfcTemplate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NfcTemplate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NfcTemplate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NfcTemplate value)  $default,){
final _that = this;
switch (_that) {
case _NfcTemplate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NfcTemplate value)?  $default,){
final _that = this;
switch (_that) {
case _NfcTemplate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  String category,  String payloadType,  String defaultPayload,  String iconName,  bool isCustom)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NfcTemplate() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.category,_that.payloadType,_that.defaultPayload,_that.iconName,_that.isCustom);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  String category,  String payloadType,  String defaultPayload,  String iconName,  bool isCustom)  $default,) {final _that = this;
switch (_that) {
case _NfcTemplate():
return $default(_that.id,_that.title,_that.description,_that.category,_that.payloadType,_that.defaultPayload,_that.iconName,_that.isCustom);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  String category,  String payloadType,  String defaultPayload,  String iconName,  bool isCustom)?  $default,) {final _that = this;
switch (_that) {
case _NfcTemplate() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.category,_that.payloadType,_that.defaultPayload,_that.iconName,_that.isCustom);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NfcTemplate implements NfcTemplate {
  const _NfcTemplate({required this.id, required this.title, required this.description, required this.category, required this.payloadType, required this.defaultPayload, required this.iconName, this.isCustom = false});
  factory _NfcTemplate.fromJson(Map<String, dynamic> json) => _$NfcTemplateFromJson(json);

@override final  String id;
@override final  String title;
@override final  String description;
@override final  String category;
@override final  String payloadType;
@override final  String defaultPayload;
@override final  String iconName;
@override@JsonKey() final  bool isCustom;

/// Create a copy of NfcTemplate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NfcTemplateCopyWith<_NfcTemplate> get copyWith => __$NfcTemplateCopyWithImpl<_NfcTemplate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NfcTemplateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NfcTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.payloadType, payloadType) || other.payloadType == payloadType)&&(identical(other.defaultPayload, defaultPayload) || other.defaultPayload == defaultPayload)&&(identical(other.iconName, iconName) || other.iconName == iconName)&&(identical(other.isCustom, isCustom) || other.isCustom == isCustom));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,category,payloadType,defaultPayload,iconName,isCustom);

@override
String toString() {
  return 'NfcTemplate(id: $id, title: $title, description: $description, category: $category, payloadType: $payloadType, defaultPayload: $defaultPayload, iconName: $iconName, isCustom: $isCustom)';
}


}

/// @nodoc
abstract mixin class _$NfcTemplateCopyWith<$Res> implements $NfcTemplateCopyWith<$Res> {
  factory _$NfcTemplateCopyWith(_NfcTemplate value, $Res Function(_NfcTemplate) _then) = __$NfcTemplateCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, String category, String payloadType, String defaultPayload, String iconName, bool isCustom
});




}
/// @nodoc
class __$NfcTemplateCopyWithImpl<$Res>
    implements _$NfcTemplateCopyWith<$Res> {
  __$NfcTemplateCopyWithImpl(this._self, this._then);

  final _NfcTemplate _self;
  final $Res Function(_NfcTemplate) _then;

/// Create a copy of NfcTemplate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? category = null,Object? payloadType = null,Object? defaultPayload = null,Object? iconName = null,Object? isCustom = null,}) {
  return _then(_NfcTemplate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,payloadType: null == payloadType ? _self.payloadType : payloadType // ignore: cast_nullable_to_non_nullable
as String,defaultPayload: null == defaultPayload ? _self.defaultPayload : defaultPayload // ignore: cast_nullable_to_non_nullable
as String,iconName: null == iconName ? _self.iconName : iconName // ignore: cast_nullable_to_non_nullable
as String,isCustom: null == isCustom ? _self.isCustom : isCustom // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
