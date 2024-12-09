// To parse this JSON data, do
//
//     final buyer = buyerFromJson(jsonString);

import 'dart:convert';

Buyer buyerFromJson(String str) => Buyer.fromJson(json.decode(str));

String buyerToJson(Buyer data) => json.encode(data.toJson());

class Buyer {
    int id;
    String username;
    String email;
    String phoneNumber;
    bool isBuyer;
    String preferredPaymentMethod;

    Buyer({
        required this.id,
        required this.username,
        required this.email,
        required this.phoneNumber,
        required this.isBuyer,
        required this.preferredPaymentMethod,
    });

    factory Buyer.fromJson(Map<String, dynamic> json) => Buyer(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        isBuyer: json["is_buyer"],
        preferredPaymentMethod: json["preferred_payment_method"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "phone_number": phoneNumber,
        "is_buyer": isBuyer,
        "preferred_payment_method": preferredPaymentMethod,
    };
}