import 'package:json_annotation/json_annotation.dart';

part 'ip_model.g.dart';

@JsonSerializable()
class IpModel {
  String ip;

  IpModel(this.ip);

  factory IpModel.fromJson(Map<String, dynamic> json) =>
      _$IpModelFromJson(json);

  Map<String, dynamic> toJson() => _$IpModelToJson(this);
}
