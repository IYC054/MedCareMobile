import 'Feedback.dart';
import 'Role.dart';

class Account {
  num? id;
  String? email;
  String? name;
  String? password;
  String? phone;
  String? gender;
  String? birthdate;
  List<Role>? roleList;
  String? avatar;
  String? lastfeedbacktime;
  List<Feedback>? feedbacksList;

  Account(
      {this.id, this.email, this.name, this.password, this.phone, this.gender, this.birthdate, this.roleList, this.avatar, this.lastfeedbacktime, this.feedbacksList});

  Account copyWith(
      {num? id, String? email, String? name, String? password, String? phone, String? gender, String? birthdate, List<
          Role>? roleList, String? avatar, String? lastfeedbacktime, List<
          Feedback>? feedbacksList}) =>
      Account(id: id ?? this.id,
          email: email ?? this.email,
          name: name ?? this.name,
          password: password ?? this.password,
          phone: phone ?? this.phone,
          gender: gender ?? this.gender,
          birthdate: birthdate ?? this.birthdate,
          roleList: roleList ?? this.roleList,
          avatar: avatar ?? this.avatar,
          lastfeedbacktime: lastfeedbacktime ?? this.lastfeedbacktime,
          feedbacksList: feedbacksList ?? this.feedbacksList);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["id"] = id;
    map["email"] = email;
    map["name"] = name;
    map["password"] = password;
    map["phone"] = phone;
    map["gender"] = gender;
    map["birthdate"] = birthdate;
    if (roleList != null) {
      map["role"] = roleList?.map((v) => v.toJson()).toList();
    }
    map["avatar"] = avatar;
    map["lastFeedbackTime"] = lastfeedbacktime;
    if (feedbacksList != null) {
      map["feedbacks"] = feedbacksList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  Account.fromJson(dynamic json){
    id = json["id"];
    email = json["email"];
    name = json["name"];
    password = json["password"];
    phone = json["phone"];
    gender = json["gender"];
    birthdate = json["birthdate"];
    if (json["role"] != null) {
      roleList = [];
      json["role"].forEach((v) {
        roleList?.add(Role.fromJson(v));
      });
    }
    avatar = json["avatar"];
    lastfeedbacktime = json["lastFeedbackTime"];
    if (json["feedbacks"] != null) {
      feedbacksList = [];
      json["feedbacks"].forEach((v) {
        feedbacksList?.add(Feedback.fromJson(v));
      });
    }
  }
}