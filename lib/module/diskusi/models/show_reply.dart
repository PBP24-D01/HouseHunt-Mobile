// To parse this JSON data, do
//
//     final showReply = showReplyFromJson(jsonString);

import 'dart:convert';

List<ShowReply> showReplyFromJson(String str) => List<ShowReply>.from(json.decode(str).map((x) => ShowReply.fromJson(x)));

String showReplyToJson(List<ShowReply> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ShowReply {
    Model model;
    String pk;
    Fields fields;

    ShowReply({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory ShowReply.fromJson(Map<String, dynamic> json) => ShowReply(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String parentComment;
    Name name;
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
        name: nameValues.map[json["name"]]!,
        body: json["body"],
        created: DateTime.parse(json["created"]),
    );

    Map<String, dynamic> toJson() => {
        "parent_comment": parentComment,
        "name": nameValues.reverse[name],
        "body": body,
        "created": created.toIso8601String(),
    };
}

enum Name {
    BUDI,
    BUDI_ARI
}

final nameValues = EnumValues({
    "budi": Name.BUDI,
    "budi ari": Name.BUDI_ARI
});

enum Model {
    DISKUSI_REPLY
}

final modelValues = EnumValues({
    "diskusi.reply": Model.DISKUSI_REPLY
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
