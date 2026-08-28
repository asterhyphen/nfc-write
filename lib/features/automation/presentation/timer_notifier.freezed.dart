// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timer_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TimerState {

 int get duration; int get remainingSeconds; bool get isRunning; bool get isPaused; bool get isFinished; String get label;
/// Create a copy of TimerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimerStateCopyWith<TimerState> get copyWith => _$TimerStateCopyWithImpl<TimerState>(this as TimerState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimerState&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.remainingSeconds, remainingSeconds) || other.remainingSeconds == remainingSeconds)&&(identical(other.isRunning, isRunning) || other.isRunning == isRunning)&&(identical(other.isPaused, isPaused) || other.isPaused == isPaused)&&(identical(other.isFinished, isFinished) || other.isFinished == isFinished)&&(identical(other.label, label) || other.label == label));
}


@override
int get hashCode => Object.hash(runtimeType,duration,remainingSeconds,isRunning,isPaused,isFinished,label);

@override
String toString() {
  return 'TimerState(duration: $duration, remainingSeconds: $remainingSeconds, isRunning: $isRunning, isPaused: $isPaused, isFinished: $isFinished, label: $label)';
}


}

/// @nodoc
abstract mixin class $TimerStateCopyWith<$Res>  {
  factory $TimerStateCopyWith(TimerState value, $Res Function(TimerState) _then) = _$TimerStateCopyWithImpl;
@useResult
$Res call({
 int duration, int remainingSeconds, bool isRunning, bool isPaused, bool isFinished, String label
});




}
/// @nodoc
class _$TimerStateCopyWithImpl<$Res>
    implements $TimerStateCopyWith<$Res> {
  _$TimerStateCopyWithImpl(this._self, this._then);

  final TimerState _self;
  final $Res Function(TimerState) _then;

/// Create a copy of TimerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? duration = null,Object? remainingSeconds = null,Object? isRunning = null,Object? isPaused = null,Object? isFinished = null,Object? label = null,}) {
  return _then(_self.copyWith(
duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,remainingSeconds: null == remainingSeconds ? _self.remainingSeconds : remainingSeconds // ignore: cast_nullable_to_non_nullable
as int,isRunning: null == isRunning ? _self.isRunning : isRunning // ignore: cast_nullable_to_non_nullable
as bool,isPaused: null == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool,isFinished: null == isFinished ? _self.isFinished : isFinished // ignore: cast_nullable_to_non_nullable
as bool,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TimerState].
extension TimerStatePatterns on TimerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimerState value)  $default,){
final _that = this;
switch (_that) {
case _TimerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimerState value)?  $default,){
final _that = this;
switch (_that) {
case _TimerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int duration,  int remainingSeconds,  bool isRunning,  bool isPaused,  bool isFinished,  String label)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimerState() when $default != null:
return $default(_that.duration,_that.remainingSeconds,_that.isRunning,_that.isPaused,_that.isFinished,_that.label);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int duration,  int remainingSeconds,  bool isRunning,  bool isPaused,  bool isFinished,  String label)  $default,) {final _that = this;
switch (_that) {
case _TimerState():
return $default(_that.duration,_that.remainingSeconds,_that.isRunning,_that.isPaused,_that.isFinished,_that.label);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int duration,  int remainingSeconds,  bool isRunning,  bool isPaused,  bool isFinished,  String label)?  $default,) {final _that = this;
switch (_that) {
case _TimerState() when $default != null:
return $default(_that.duration,_that.remainingSeconds,_that.isRunning,_that.isPaused,_that.isFinished,_that.label);case _:
  return null;

}
}

}

/// @nodoc


class _TimerState implements TimerState {
  const _TimerState({required this.duration, required this.remainingSeconds, required this.isRunning, required this.isPaused, required this.isFinished, required this.label});
  

@override final  int duration;
@override final  int remainingSeconds;
@override final  bool isRunning;
@override final  bool isPaused;
@override final  bool isFinished;
@override final  String label;

/// Create a copy of TimerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimerStateCopyWith<_TimerState> get copyWith => __$TimerStateCopyWithImpl<_TimerState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimerState&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.remainingSeconds, remainingSeconds) || other.remainingSeconds == remainingSeconds)&&(identical(other.isRunning, isRunning) || other.isRunning == isRunning)&&(identical(other.isPaused, isPaused) || other.isPaused == isPaused)&&(identical(other.isFinished, isFinished) || other.isFinished == isFinished)&&(identical(other.label, label) || other.label == label));
}


@override
int get hashCode => Object.hash(runtimeType,duration,remainingSeconds,isRunning,isPaused,isFinished,label);

@override
String toString() {
  return 'TimerState(duration: $duration, remainingSeconds: $remainingSeconds, isRunning: $isRunning, isPaused: $isPaused, isFinished: $isFinished, label: $label)';
}


}

/// @nodoc
abstract mixin class _$TimerStateCopyWith<$Res> implements $TimerStateCopyWith<$Res> {
  factory _$TimerStateCopyWith(_TimerState value, $Res Function(_TimerState) _then) = __$TimerStateCopyWithImpl;
@override @useResult
$Res call({
 int duration, int remainingSeconds, bool isRunning, bool isPaused, bool isFinished, String label
});




}
/// @nodoc
class __$TimerStateCopyWithImpl<$Res>
    implements _$TimerStateCopyWith<$Res> {
  __$TimerStateCopyWithImpl(this._self, this._then);

  final _TimerState _self;
  final $Res Function(_TimerState) _then;

/// Create a copy of TimerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? duration = null,Object? remainingSeconds = null,Object? isRunning = null,Object? isPaused = null,Object? isFinished = null,Object? label = null,}) {
  return _then(_TimerState(
duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,remainingSeconds: null == remainingSeconds ? _self.remainingSeconds : remainingSeconds // ignore: cast_nullable_to_non_nullable
as int,isRunning: null == isRunning ? _self.isRunning : isRunning // ignore: cast_nullable_to_non_nullable
as bool,isPaused: null == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool,isFinished: null == isFinished ? _self.isFinished : isFinished // ignore: cast_nullable_to_non_nullable
as bool,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
