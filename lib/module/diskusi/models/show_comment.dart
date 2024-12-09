// To parse this JSON data, do
//
//     final showComment = showCommentFromJson(jsonString);

import 'dart:convert';

List<ShowComment> showCommentFromJson(String str) => List<ShowComment>.from(json.decode(str).map((x) => ShowComment.fromJson(x)));

String showCommentToJson(List<ShowComment> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ShowComment {
    String model;
    String pk;
    Fields fields;

    ShowComment({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory ShowComment.fromJson(Map<String, dynamic> json) => ShowComment(
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
    int author;
    int star;
    int seller;
    String name;
    String body;
    DateTime created;

    Fields({
        required this.author,
        required this.star,
        required this.seller,
        required this.name,
        required this.body,
        required this.created,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        author: json["author"],
        star: json["star"],
        seller: json["seller"],
        name: json["name"],
        body: json["body"],
        created: DateTime.parse(json["created"]),
    );

    Map<String, dynamic> toJson() => {
        "author": author,
        "star": star,
        "seller": seller,
        "name": name,
        "body": body,
        "created": created.toIso8601String(),
    };
}
