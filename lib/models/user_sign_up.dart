import 'package:json_annotation/json_annotation.dart';

part 'user_sign_up.g.dart';

@JsonSerializable()
class UserSignUp {

  String? name;
  String? username;
  String? email;
  String? password;
  String? passwordConfirm;

  UserSignUp({
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    required this.passwordConfirm
  });

  factory UserSignUp.fromJson(Map<String, dynamic> json) => _$UserSignUpFromJson(json);

  Map<String, dynamic> toJson() => _$UserSignUpToJson(this);

}