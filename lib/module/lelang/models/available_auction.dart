// To parse this JSON data, do
//
//     final availableAuction = availableAuctionFromJson(jsonString);

import 'dart:convert';

AvailableAuction availableAuctionFromJson(String str) => AvailableAuction.fromJson(json.decode(str));

String availableAuctionToJson(AvailableAuction data) => json.encode(data.toJson());

class AvailableAuction {
    String id;
    String title;

    AvailableAuction({
        required this.id,
        required this.title,
    });

    factory AvailableAuction.fromJson(Map<String, dynamic> json) => AvailableAuction(
        id: json["id"].toString(),
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
    };
}