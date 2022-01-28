// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_sign_up.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSignUp _$UserSignUpFromJson(Map<String, dynamic> json) {
  return UserSignUp(
    name: json['name'] as String?,
    username: json['username'] as String?,
    email: json['email'] as String?,
    password: json['password'] as String?,
    passwordConfirm: json['passwordConfirm'] as String?,
  );
}

Map<String, dynamic> _$UserSignUpToJson(UserSignUp instance) =>
    <String, dynamic>{
      'name': instance.name,
      'username': instance.username,
      'email': instance.email,
      'password': instance.password,
      'passwordConfirm': instance.passwordConfirm,
    };
