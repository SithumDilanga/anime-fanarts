import 'package:json_annotation/json_annotation.dart';

part 'reaction.g.dart';

@JsonSerializable()
class Reaction {

  String? post;
  int? reaction;

  Reaction({
    required this.post,
    required this.reaction
  });

  factory Reaction.fromJson(Map<String, dynamic> json) => _$ReactionFromJson(json);

  Map<String, dynamic> toJson() => _$ReactionToJson(this);

}