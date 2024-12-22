// To parse this JSON data, do
//
//     final showReply = showReplyFromJson(jsonString);

import 'dart:convert';

List<ShowReply> showReplyFromJson(String str) => List<ShowReply>.from(json.decode(str).map((x) => ShowReply.fromJson(x)));

String showReplyToJson(List<ShowReply> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ShowReply {
    String model;
    String pk;
    Fields fields;

    ShowReply({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory ShowReply.fromJson(Map<String, dynamic> json) => ShowReply(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String parentComment;
    String name;
    String body;
    DateTime created;

    Fields({
        required this.parentComment,
        required this.name,
        required this.body,
        required this.created,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        parentComment: json["parent_comment"],
        name: json["name"],
        body: json["body"],
        created: DateTime.parse(json["created"]),
    );

    Map<String, dynamic> toJson() => {
        "parent_comment": parentComment,
        "name": name,
        "body": body,
        "created": created.toIso8601String(),
    };
}


class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
