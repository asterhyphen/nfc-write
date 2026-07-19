// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'automation_action.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
AutomationAction _$AutomationActionFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'openUrl':
          return OpenUrlAction.fromJson(
            json
          );
                case 'showNotification':
          return ShowNotificationAction.fromJson(
            json
          );
                case 'launchApp':
          return LaunchAppAction.fromJson(
            json
          );
                case 'setBrightness':
          return SetBrightnessAction.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'AutomationAction',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$AutomationAction {



  /// Serializes this AutomationAction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AutomationAction);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AutomationAction()';
}


}

/// @nodoc
class $AutomationActionCopyWith<$Res>  {
$AutomationActionCopyWith(AutomationAction _, $Res Function(AutomationAction) __);
}


/// Adds pattern-matching-related methods to [AutomationAction].
extension AutomationActionPatterns on AutomationAction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( OpenUrlAction value)?  openUrl,TResult Function( ShowNotificationAction value)?  showNotification,TResult Function( LaunchAppAction value)?  launchApp,TResult Function( SetBrightnessAction value)?  setBrightness,required TResult orElse(),}){
final _that = this;
switch (_that) {
case OpenUrlAction() when openUrl != null:
return openUrl(_that);case ShowNotificationAction() when showNotification != null:
return showNotification(_that);case LaunchAppAction() when launchApp != null:
return launchApp(_that);case SetBrightnessAction() when setBrightness != null:
return setBrightness(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( OpenUrlAction value)  openUrl,required TResult Function( ShowNotificationAction value)  showNotification,required TResult Function( LaunchAppAction value)  launchApp,required TResult Function( SetBrightnessAction value)  setBrightness,}){
final _that = this;
switch (_that) {
case OpenUrlAction():
return openUrl(_that);case ShowNotificationAction():
return showNotification(_that);case LaunchAppAction():
return launchApp(_that);case SetBrightnessAction():
return setBrightness(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( OpenUrlAction value)?  openUrl,TResult? Function( ShowNotificationAction value)?  showNotification,TResult? Function( LaunchAppAction value)?  launchApp,TResult? Function( SetBrightnessAction value)?  setBrightness,}){
final _that = this;
switch (_that) {
case OpenUrlAction() when openUrl != null:
return openUrl(_that);case ShowNotificationAction() when showNotification != null:
return showNotification(_that);case LaunchAppAction() when launchApp != null:
return launchApp(_that);case SetBrightnessAction() when setBrightness != null:
return setBrightness(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String url)?  openUrl,TResult Function( String title,  String body)?  showNotification,TResult Function( String packageName)?  launchApp,TResult Function( double level)?  setBrightness,required TResult orElse(),}) {final _that = this;
switch (_that) {
case OpenUrlAction() when openUrl != null:
return openUrl(_that.url);case ShowNotificationAction() when showNotification != null:
return showNotification(_that.title,_that.body);case LaunchAppAction() when launchApp != null:
return launchApp(_that.packageName);case SetBrightnessAction() when setBrightness != null:
return setBrightness(_that.level);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String url)  openUrl,required TResult Function( String title,  String body)  showNotification,required TResult Function( String packageName)  launchApp,required TResult Function( double level)  setBrightness,}) {final _that = this;
switch (_that) {
case OpenUrlAction():
return openUrl(_that.url);case ShowNotificationAction():
return showNotification(_that.title,_that.body);case LaunchAppAction():
return launchApp(_that.packageName);case SetBrightnessAction():
return setBrightness(_that.level);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String url)?  openUrl,TResult? Function( String title,  String body)?  showNotification,TResult? Function( String packageName)?  launchApp,TResult? Function( double level)?  setBrightness,}) {final _that = this;
switch (_that) {
case OpenUrlAction() when openUrl != null:
return openUrl(_that.url);case ShowNotificationAction() when showNotification != null:
return showNotification(_that.title,_that.body);case LaunchAppAction() when launchApp != null:
return launchApp(_that.packageName);case SetBrightnessAction() when setBrightness != null:
return setBrightness(_that.level);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class OpenUrlAction implements AutomationAction {
  const OpenUrlAction({required this.url, final  String? $type}): $type = $type ?? 'openUrl';
  factory OpenUrlAction.fromJson(Map<String, dynamic> json) => _$OpenUrlActionFromJson(json);

 final  String url;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of AutomationAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpenUrlActionCopyWith<OpenUrlAction> get copyWith => _$OpenUrlActionCopyWithImpl<OpenUrlAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OpenUrlActionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpenUrlAction&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url);

@override
String toString() {
  return 'AutomationAction.openUrl(url: $url)';
}


}

/// @nodoc
abstract mixin class $OpenUrlActionCopyWith<$Res> implements $AutomationActionCopyWith<$Res> {
  factory $OpenUrlActionCopyWith(OpenUrlAction value, $Res Function(OpenUrlAction) _then) = _$OpenUrlActionCopyWithImpl;
@useResult
$Res call({
 String url
});




}
/// @nodoc
class _$OpenUrlActionCopyWithImpl<$Res>
    implements $OpenUrlActionCopyWith<$Res> {
  _$OpenUrlActionCopyWithImpl(this._self, this._then);

  final OpenUrlAction _self;
  final $Res Function(OpenUrlAction) _then;

/// Create a copy of AutomationAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? url = null,}) {
  return _then(OpenUrlAction(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class ShowNotificationAction implements AutomationAction {
  const ShowNotificationAction({required this.title, required this.body, final  String? $type}): $type = $type ?? 'showNotification';
  factory ShowNotificationAction.fromJson(Map<String, dynamic> json) => _$ShowNotificationActionFromJson(json);

 final  String title;
 final  String body;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of AutomationAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShowNotificationActionCopyWith<ShowNotificationAction> get copyWith => _$ShowNotificationActionCopyWithImpl<ShowNotificationAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShowNotificationActionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShowNotificationAction&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,body);

@override
String toString() {
  return 'AutomationAction.showNotification(title: $title, body: $body)';
}


}

/// @nodoc
abstract mixin class $ShowNotificationActionCopyWith<$Res> implements $AutomationActionCopyWith<$Res> {
  factory $ShowNotificationActionCopyWith(ShowNotificationAction value, $Res Function(ShowNotificationAction) _then) = _$ShowNotificationActionCopyWithImpl;
@useResult
$Res call({
 String title, String body
});




}
/// @nodoc
class _$ShowNotificationActionCopyWithImpl<$Res>
    implements $ShowNotificationActionCopyWith<$Res> {
  _$ShowNotificationActionCopyWithImpl(this._self, this._then);

  final ShowNotificationAction _self;
  final $Res Function(ShowNotificationAction) _then;

/// Create a copy of AutomationAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? title = null,Object? body = null,}) {
  return _then(ShowNotificationAction(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class LaunchAppAction implements AutomationAction {
  const LaunchAppAction({required this.packageName, final  String? $type}): $type = $type ?? 'launchApp';
  factory LaunchAppAction.fromJson(Map<String, dynamic> json) => _$LaunchAppActionFromJson(json);

 final  String packageName;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of AutomationAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LaunchAppActionCopyWith<LaunchAppAction> get copyWith => _$LaunchAppActionCopyWithImpl<LaunchAppAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LaunchAppActionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LaunchAppAction&&(identical(other.packageName, packageName) || other.packageName == packageName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,packageName);

@override
String toString() {
  return 'AutomationAction.launchApp(packageName: $packageName)';
}


}

/// @nodoc
abstract mixin class $LaunchAppActionCopyWith<$Res> implements $AutomationActionCopyWith<$Res> {
  factory $LaunchAppActionCopyWith(LaunchAppAction value, $Res Function(LaunchAppAction) _then) = _$LaunchAppActionCopyWithImpl;
@useResult
$Res call({
 String packageName
});




}
/// @nodoc
class _$LaunchAppActionCopyWithImpl<$Res>
    implements $LaunchAppActionCopyWith<$Res> {
  _$LaunchAppActionCopyWithImpl(this._self, this._then);

  final LaunchAppAction _self;
  final $Res Function(LaunchAppAction) _then;

/// Create a copy of AutomationAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? packageName = null,}) {
  return _then(LaunchAppAction(
packageName: null == packageName ? _self.packageName : packageName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class SetBrightnessAction implements AutomationAction {
  const SetBrightnessAction({required this.level, final  String? $type}): $type = $type ?? 'setBrightness';
  factory SetBrightnessAction.fromJson(Map<String, dynamic> json) => _$SetBrightnessActionFromJson(json);

 final  double level;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of AutomationAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetBrightnessActionCopyWith<SetBrightnessAction> get copyWith => _$SetBrightnessActionCopyWithImpl<SetBrightnessAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SetBrightnessActionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetBrightnessAction&&(identical(other.level, level) || other.level == level));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,level);

@override
String toString() {
  return 'AutomationAction.setBrightness(level: $level)';
}


}

/// @nodoc
abstract mixin class $SetBrightnessActionCopyWith<$Res> implements $AutomationActionCopyWith<$Res> {
  factory $SetBrightnessActionCopyWith(SetBrightnessAction value, $Res Function(SetBrightnessAction) _then) = _$SetBrightnessActionCopyWithImpl;
@useResult
$Res call({
 double level
});




}
/// @nodoc
class _$SetBrightnessActionCopyWithImpl<$Res>
    implements $SetBrightnessActionCopyWith<$Res> {
  _$SetBrightnessActionCopyWithImpl(this._self, this._then);

  final SetBrightnessAction _self;
  final $Res Function(SetBrightnessAction) _then;

/// Create a copy of AutomationAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? level = null,}) {
  return _then(SetBrightnessAction(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$AutomationProfile {

 String get id; String get name; List<AutomationAction> get actions; bool get isFavorite;
/// Create a copy of AutomationProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AutomationProfileCopyWith<AutomationProfile> get copyWith => _$AutomationProfileCopyWithImpl<AutomationProfile>(this as AutomationProfile, _$identity);

  /// Serializes this AutomationProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AutomationProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.actions, actions)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(actions),isFavorite);

@override
String toString() {
  return 'AutomationProfile(id: $id, name: $name, actions: $actions, isFavorite: $isFavorite)';
}


}

/// @nodoc
abstract mixin class $AutomationProfileCopyWith<$Res>  {
  factory $AutomationProfileCopyWith(AutomationProfile value, $Res Function(AutomationProfile) _then) = _$AutomationProfileCopyWithImpl;
@useResult
$Res call({
 String id, String name, List<AutomationAction> actions, bool isFavorite
});




}
/// @nodoc
class _$AutomationProfileCopyWithImpl<$Res>
    implements $AutomationProfileCopyWith<$Res> {
  _$AutomationProfileCopyWithImpl(this._self, this._then);

  final AutomationProfile _self;
  final $Res Function(AutomationProfile) _then;

/// Create a copy of AutomationProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? actions = null,Object? isFavorite = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,actions: null == actions ? _self.actions : actions // ignore: cast_nullable_to_non_nullable
as List<AutomationAction>,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AutomationProfile].
extension AutomationProfilePatterns on AutomationProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AutomationProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AutomationProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AutomationProfile value)  $default,){
final _that = this;
switch (_that) {
case _AutomationProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AutomationProfile value)?  $default,){
final _that = this;
switch (_that) {
case _AutomationProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  List<AutomationAction> actions,  bool isFavorite)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AutomationProfile() when $default != null:
return $default(_that.id,_that.name,_that.actions,_that.isFavorite);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  List<AutomationAction> actions,  bool isFavorite)  $default,) {final _that = this;
switch (_that) {
case _AutomationProfile():
return $default(_that.id,_that.name,_that.actions,_that.isFavorite);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  List<AutomationAction> actions,  bool isFavorite)?  $default,) {final _that = this;
switch (_that) {
case _AutomationProfile() when $default != null:
return $default(_that.id,_that.name,_that.actions,_that.isFavorite);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AutomationProfile implements AutomationProfile {
  const _AutomationProfile({required this.id, required this.name, required final  List<AutomationAction> actions, this.isFavorite = false}): _actions = actions;
  factory _AutomationProfile.fromJson(Map<String, dynamic> json) => _$AutomationProfileFromJson(json);

@override final  String id;
@override final  String name;
 final  List<AutomationAction> _actions;
@override List<AutomationAction> get actions {
  if (_actions is EqualUnmodifiableListView) return _actions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_actions);
}

@override@JsonKey() final  bool isFavorite;

/// Create a copy of AutomationProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AutomationProfileCopyWith<_AutomationProfile> get copyWith => __$AutomationProfileCopyWithImpl<_AutomationProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AutomationProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AutomationProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._actions, _actions)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_actions),isFavorite);

@override
String toString() {
  return 'AutomationProfile(id: $id, name: $name, actions: $actions, isFavorite: $isFavorite)';
}


}

/// @nodoc
abstract mixin class _$AutomationProfileCopyWith<$Res> implements $AutomationProfileCopyWith<$Res> {
  factory _$AutomationProfileCopyWith(_AutomationProfile value, $Res Function(_AutomationProfile) _then) = __$AutomationProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, List<AutomationAction> actions, bool isFavorite
});




}
/// @nodoc
class __$AutomationProfileCopyWithImpl<$Res>
    implements _$AutomationProfileCopyWith<$Res> {
  __$AutomationProfileCopyWithImpl(this._self, this._then);

  final _AutomationProfile _self;
  final $Res Function(_AutomationProfile) _then;

/// Create a copy of AutomationProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? actions = null,Object? isFavorite = null,}) {
  return _then(_AutomationProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,actions: null == actions ? _self._actions : actions // ignore: cast_nullable_to_non_nullable
as List<AutomationAction>,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
