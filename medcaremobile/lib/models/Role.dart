
import 'Permission.dart';

class Role {
  String? name;
  String? description;
  List<Permission>? permissionsList;

  Role({this.name, this.description, this.permissionsList});

  Role copyWith({String? name, String? description, List<
      Permission>? permissionsList}) =>
      Role(name: name ?? this.name,
          description: description ?? this.description,
          permissionsList: permissionsList ?? this.permissionsList);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["name"] = name;
    map["description"] = description;
    if (permissionsList != null) {
      map["permissions"] = permissionsList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  Role.fromJson(dynamic json){
    name = json["name"];
    description = json["description"];
    if (json["permissions"] != null) {
      permissionsList = [];
      json["permissions"].forEach((v) {
        permissionsList?.add(Permission.fromJson(v));
      });
    }
  }
}