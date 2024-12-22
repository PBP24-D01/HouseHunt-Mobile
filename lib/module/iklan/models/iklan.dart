import 'dart:convert';

Iklan iklanFromJson(String str) => Iklan.fromJson(json.decode(str));
List<Iklan> iklanFromListJson(String str) => List<Iklan>.from(json.decode(str).map((x) => Iklan.fromJson(x)));
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

  factory Iklan.fromJson(Map<String, dynamic> json) {
    return Iklan(
      id: json['id'] ?? '', // Provide a default value if null
      title: json['title'] ?? 'No Title', // Default title
      houseUrl: json['houseUrl'] ?? '', // Default URL
      houseTitle: json['houseTitle'] ?? '', // Default house title
      houseAddress: json['houseAddress'] ?? 'Unknown Address', // Default address
      houseImageURL: json['houseImageURL'] ?? '', // Default image URL
      housePrice: json['housePrice'] ?? 0, // Default price
      startDate: DateTime.tryParse(json['startDate'] ?? '') ?? DateTime.now(), // Default to now if parsing fails
      endDate: DateTime.tryParse(json['endDate'] ?? '') ?? DateTime.now().add(Duration(days: 30)), // Default to 30 days from now
      seller: json['seller'] ?? 'Unknown Seller', // Default seller
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(), // Default to now
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(), // Default to now
      bannerURL: json['bannerURL'] ?? '', // Default banner URL
    );
  }

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