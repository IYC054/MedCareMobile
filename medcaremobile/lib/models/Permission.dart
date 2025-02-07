class Permission {
  String? name;
  String? description;

  Permission({this.name, this.description});

  Permission copyWith({String? name, String? description}) =>
      Permission(name: name ?? this.name,
          description: description ?? this.description);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["name"] = name;
    map["description"] = description;
    return map;
  }

  Permission.fromJson(dynamic json){
    name = json["name"];
    description = json["description"];
  }
}