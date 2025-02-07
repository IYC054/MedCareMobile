
import 'Account.dart';

class Feedback {
  num? id;
  String? message;
  String? createdat;
  Account? account;

  Feedback({this.id, this.message, this.createdat, this.account});

  Feedback copyWith(
      {num? id, String? message, String? createdat, Account? account}) =>
      Feedback(id: id ?? this.id,
          message: message ?? this.message,
          createdat: createdat ?? this.createdat,
          account: account ?? this.account);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["id"] = id;
    map["message"] = message;
    map["createdAt"] = createdat;
    if (account != null) {
      map["account"] = account?.toJson();
    }
    return map;
  }

  Feedback.fromJson(dynamic json){
    id = json["id"];
    message = json["message"];
    createdat = json["createdAt"];
    account =
    json["account"] != null ? Account.fromJson(json["account"]) : null;
  }
}