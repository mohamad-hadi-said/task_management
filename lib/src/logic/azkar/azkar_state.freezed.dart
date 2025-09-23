// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'azkar_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AzkarState {

 bool get loading; bool get error; String? get errorMessage; List<AzkarModel> get azkar; int get currentCount; AzkarModel? get currentZeker; DateTime? get dateTime;
/// Create a copy of AzkarState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AzkarStateCopyWith<AzkarState> get copyWith => _$AzkarStateCopyWithImpl<AzkarState>(this as AzkarState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AzkarState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.error, error) || other.error == error)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other.azkar, azkar)&&(identical(other.currentCount, currentCount) || other.currentCount == currentCount)&&(identical(other.currentZeker, currentZeker) || other.currentZeker == currentZeker)&&(identical(other.dateTime, dateTime) || other.dateTime == dateTime));
}


@override
int get hashCode => Object.hash(runtimeType,loading,error,errorMessage,const DeepCollectionEquality().hash(azkar),currentCount,currentZeker,dateTime);

@override
String toString() {
  return 'AzkarState(loading: $loading, error: $error, errorMessage: $errorMessage, azkar: $azkar, currentCount: $currentCount, currentZeker: $currentZeker, dateTime: $dateTime)';
}


}

/// @nodoc
abstract mixin class $AzkarStateCopyWith<$Res>  {
  factory $AzkarStateCopyWith(AzkarState value, $Res Function(AzkarState) _then) = _$AzkarStateCopyWithImpl;
@useResult
$Res call({
 bool loading, bool error, String? errorMessage, List<AzkarModel> azkar, int currentCount, AzkarModel? currentZeker, DateTime? dateTime
});




}
/// @nodoc
class _$AzkarStateCopyWithImpl<$Res>
    implements $AzkarStateCopyWith<$Res> {
  _$AzkarStateCopyWithImpl(this._self, this._then);

  final AzkarState _self;
  final $Res Function(AzkarState) _then;

/// Create a copy of AzkarState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loading = null,Object? error = null,Object? errorMessage = freezed,Object? azkar = null,Object? currentCount = null,Object? currentZeker = freezed,Object? dateTime = freezed,}) {
  return _then(_self.copyWith(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,azkar: null == azkar ? _self.azkar : azkar // ignore: cast_nullable_to_non_nullable
as List<AzkarModel>,currentCount: null == currentCount ? _self.currentCount : currentCount // ignore: cast_nullable_to_non_nullable
as int,currentZeker: freezed == currentZeker ? _self.currentZeker : currentZeker // ignore: cast_nullable_to_non_nullable
as AzkarModel?,dateTime: freezed == dateTime ? _self.dateTime : dateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AzkarState].
extension AzkarStatePatterns on AzkarState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AzkarState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AzkarState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AzkarState value)  $default,){
final _that = this;
switch (_that) {
case _AzkarState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AzkarState value)?  $default,){
final _that = this;
switch (_that) {
case _AzkarState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loading,  bool error,  String? errorMessage,  List<AzkarModel> azkar,  int currentCount,  AzkarModel? currentZeker,  DateTime? dateTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AzkarState() when $default != null:
return $default(_that.loading,_that.error,_that.errorMessage,_that.azkar,_that.currentCount,_that.currentZeker,_that.dateTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loading,  bool error,  String? errorMessage,  List<AzkarModel> azkar,  int currentCount,  AzkarModel? currentZeker,  DateTime? dateTime)  $default,) {final _that = this;
switch (_that) {
case _AzkarState():
return $default(_that.loading,_that.error,_that.errorMessage,_that.azkar,_that.currentCount,_that.currentZeker,_that.dateTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loading,  bool error,  String? errorMessage,  List<AzkarModel> azkar,  int currentCount,  AzkarModel? currentZeker,  DateTime? dateTime)?  $default,) {final _that = this;
switch (_that) {
case _AzkarState() when $default != null:
return $default(_that.loading,_that.error,_that.errorMessage,_that.azkar,_that.currentCount,_that.currentZeker,_that.dateTime);case _:
  return null;

}
}

}

/// @nodoc


class _AzkarState implements AzkarState {
   _AzkarState({this.loading = false, this.error = false, this.errorMessage, final  List<AzkarModel> azkar = const [], this.currentCount = 0, this.currentZeker, this.dateTime}): _azkar = azkar;
  

@override@JsonKey() final  bool loading;
@override@JsonKey() final  bool error;
@override final  String? errorMessage;
 final  List<AzkarModel> _azkar;
@override@JsonKey() List<AzkarModel> get azkar {
  if (_azkar is EqualUnmodifiableListView) return _azkar;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_azkar);
}

@override@JsonKey() final  int currentCount;
@override final  AzkarModel? currentZeker;
@override final  DateTime? dateTime;

/// Create a copy of AzkarState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AzkarStateCopyWith<_AzkarState> get copyWith => __$AzkarStateCopyWithImpl<_AzkarState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AzkarState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.error, error) || other.error == error)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other._azkar, _azkar)&&(identical(other.currentCount, currentCount) || other.currentCount == currentCount)&&(identical(other.currentZeker, currentZeker) || other.currentZeker == currentZeker)&&(identical(other.dateTime, dateTime) || other.dateTime == dateTime));
}


@override
int get hashCode => Object.hash(runtimeType,loading,error,errorMessage,const DeepCollectionEquality().hash(_azkar),currentCount,currentZeker,dateTime);

@override
String toString() {
  return 'AzkarState(loading: $loading, error: $error, errorMessage: $errorMessage, azkar: $azkar, currentCount: $currentCount, currentZeker: $currentZeker, dateTime: $dateTime)';
}


}

/// @nodoc
abstract mixin class _$AzkarStateCopyWith<$Res> implements $AzkarStateCopyWith<$Res> {
  factory _$AzkarStateCopyWith(_AzkarState value, $Res Function(_AzkarState) _then) = __$AzkarStateCopyWithImpl;
@override @useResult
$Res call({
 bool loading, bool error, String? errorMessage, List<AzkarModel> azkar, int currentCount, AzkarModel? currentZeker, DateTime? dateTime
});




}
/// @nodoc
class __$AzkarStateCopyWithImpl<$Res>
    implements _$AzkarStateCopyWith<$Res> {
  __$AzkarStateCopyWithImpl(this._self, this._then);

  final _AzkarState _self;
  final $Res Function(_AzkarState) _then;

/// Create a copy of AzkarState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loading = null,Object? error = null,Object? errorMessage = freezed,Object? azkar = null,Object? currentCount = null,Object? currentZeker = freezed,Object? dateTime = freezed,}) {
  return _then(_AzkarState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,azkar: null == azkar ? _self._azkar : azkar // ignore: cast_nullable_to_non_nullable
as List<AzkarModel>,currentCount: null == currentCount ? _self.currentCount : currentCount // ignore: cast_nullable_to_non_nullable
as int,currentZeker: freezed == currentZeker ? _self.currentZeker : currentZeker // ignore: cast_nullable_to_non_nullable
as AzkarModel?,dateTime: freezed == dateTime ? _self.dateTime : dateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
