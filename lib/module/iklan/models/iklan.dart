import 'dart:convert';

Iklan iklanFromJson(String str) => Iklan.fromJson(json.decode(str));

String iklanToJson(Iklan data) => json.encode(data.toJson());

class Iklan {
  String id;
  String title;
  String houseUrl;
  String houseTitle;
  String houseAddress;
  String houseImageURL;
  int housePrice;
  DateTime startDate;
  DateTime endDate;
  String seller;
  DateTime createdAt;
  DateTime updatedAt;
  String bannerURL;

  Iklan({
    required this.id,
    required this.title,
    required this.houseUrl,
    required this.houseTitle,
    required this.houseAddress,
    required this.houseImageURL,
    required this.housePrice,
    required this.startDate,
    required this.endDate,
    required this.seller,
    required this.createdAt,
    required this.updatedAt,
    required this.bannerURL,
  });

  factory Iklan.fromJson(Map<String, dynamic> json) => Iklan(
        id: json["id"],
        title: json["title"],
        houseUrl: json["house_url"],
        houseTitle: json["house_title"],
        houseAddress: json["house_address"],
        houseImageURL: json["house_image"],
        housePrice: json["house_price"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        seller: json["seller"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        bannerURL: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "house_url": houseUrl,
        "house_title": houseTitle,
        "house_address": houseAddress,
        "house_image_url": houseImageURL,
        "house_price": housePrice,
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "seller": seller,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "banner_url": bannerURL,
      };
}
