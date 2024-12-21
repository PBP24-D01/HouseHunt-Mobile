// To parse this JSON data, do
//
//     final auction = auctionFromJson(jsonString);

import 'dart:convert';

Auction auctionFromJson(String str) => Auction.fromJson(json.decode(str));

String auctionToJson(Auction data) => json.encode(data.toJson());

class Auction {
    String id;
    String title;
    String houseUrl;
    String houseTitle;
    String houseAddress;
    String houseImage;
    int housePrice;
    String startDate;
    String endDate;
    int startingPrice;
    int currentPrice;
    dynamic highestBuyer;
    String seller;
    String sellerId;
    DateTime createdAt;
    DateTime updatedAt;
    bool isActive;
    bool isExpired;

    Auction({
        required this.id,
        required this.title,
        required this.houseUrl,
        required this.houseTitle,
        required this.houseAddress,
        required this.houseImage,
        required this.housePrice,
        required this.startDate,
        required this.endDate,
        required this.startingPrice,
        required this.currentPrice,
        required this.highestBuyer,
        required this.seller,
        required this.sellerId,
        required this.createdAt,
        required this.updatedAt,
        required this.isActive,
        required this.isExpired,
    });

    factory Auction.fromJson(Map<String, dynamic> json) => Auction(
        id: json["id"],
        title: json["title"],
        houseUrl: json["house_url"],
        houseTitle: json["house_title"],
        houseAddress: json["house_address"],
        houseImage: json["house_image"],
        housePrice: json["house_price"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        startingPrice: json["starting_price"],
        currentPrice: json["current_price"],
        highestBuyer: json["highest_buyer"],
        seller: json["seller"],
        sellerId: json["seller_id"].toString(),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        isActive: json["is_active"],
        isExpired: json["is_expired"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "house_url": houseUrl,
        "house_title": houseTitle,
        "house_address": houseAddress,
        "house_image": houseImage,
        "house_price": housePrice,
        "start_date": startDate,
        "end_date": endDate,
        "starting_price": startingPrice,
        "current_price": currentPrice,
        "highest_buyer": highestBuyer,
        "seller": seller,
        "seller_id": sellerId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "is_active": isActive,
        "is_expired": isExpired,
    };
}
