// To parse this JSON data, do
//
//     final showSeller = showSellerFromJson(jsonString);

import 'dart:convert';

List<ShowSeller> showSellerFromJson(String str) => List<ShowSeller>.from(json.decode(str).map((x) => ShowSeller.fromJson(x)));

String showSellerToJson(List<ShowSeller> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ShowSeller {
    String model;
    int pk;
    Fields fields;

    ShowSeller({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory ShowSeller.fromJson(Map<String, dynamic> json) => ShowSeller(
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
    int user;
    String companyName;
    String companyAddress;
    double stars;

    Fields({
        required this.user,
        required this.companyName,
        required this.companyAddress,
        required this.stars,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        companyName: json["company_name"],
        companyAddress: json["company_address"],
        stars: json["stars"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "company_name": companyName,
        "company_address": companyAddress,
        "stars": stars,
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
