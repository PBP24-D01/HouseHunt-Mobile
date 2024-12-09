// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
    List<Wishlist> wishlists;

    Product({
        required this.wishlists,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        wishlists: List<Wishlist>.from(json["wishlists"].map((x) => Wishlist.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "wishlists": List<dynamic>.from(wishlists.map((x) => x.toJson())),
    };
}

class Wishlist {
    int id;
    int rumahId;
    String judul;
    String deskripsi;
    int harga;
    String lokasi;
    String gambar;
    int kamarTidur;
    int kamarMandi;
    String prioritas;

    Wishlist({
        required this.id,
        required this.rumahId,
        required this.judul,
        required this.deskripsi,
        required this.harga,
        required this.lokasi,
        required this.gambar,
        required this.kamarTidur,
        required this.kamarMandi,
        required this.prioritas,
    });

    factory Wishlist.fromJson(Map<String, dynamic> json) => Wishlist(
        id: json["id"],
        rumahId: json["rumah_id"],
        judul: json["judul"],
        deskripsi: json["deskripsi"],
        harga: json["harga"],
        lokasi: json["lokasi"],
        gambar: json["gambar"],
        kamarTidur: json["kamar_tidur"],
        kamarMandi: json["kamar_mandi"],
        prioritas: json["prioritas"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "rumah_id": rumahId,
        "judul": judul,
        "deskripsi": deskripsi,
        "harga": harga,
        "lokasi": lokasi,
        "gambar": gambar,
        "kamar_tidur": kamarTidur,
        "kamar_mandi": kamarMandi,
        "prioritas": prioritas,
    };
}
