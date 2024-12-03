// To parse this JSON data, do
//
//     final seller = sellerFromJson(jsonString);

import 'dart:convert';

Seller sellerFromJson(String str) => Seller.fromJson(json.decode(str));

String sellerToJson(Seller data) => json.encode(data.toJson());

class Seller {
    int id;
    String username;
    String email;
    String phoneNumber;
    bool isBuyer;
    String companyName;
    String companyAddress;

    Seller({
        required this.id,
        required this.username,
        required this.email,
        required this.phoneNumber,
        required this.isBuyer,
        required this.companyName,
        required this.companyAddress,
    });

    factory Seller.fromJson(Map<String, dynamic> json) => Seller(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        isBuyer: json["is_buyer"],
        companyName: json["company_name"],
        companyAddress: json["company_address"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "phone_number": phoneNumber,
        "is_buyer": isBuyer,
        "company_name": companyName,
        "company_address": companyAddress,
    };
}