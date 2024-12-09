import 'dart:convert';

Appointment appointmentFromJson(String str) => Appointment.fromJson(json.decode(str));

String appointmentToJson(Appointment data) => json.encode(data.toJson());

class Appointment {
  int id;
  int buyerId;
  int sellerId;
  int availabilityId;
  String status; // "pending", "approved", "canceled"
  String? notesToSeller;

  Appointment({
    required this.id,
    required this.buyerId,
    required this.sellerId,
    required this.availabilityId,
    this.status = "pending",
    this.notesToSeller,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
    id: json["id"],
    buyerId: json["buyer_id"],
    sellerId: json["seller_id"],
    availabilityId: json["availability_id"],
    status: json["status"] ?? "pending",
    notesToSeller: json["notes_to_seller"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "buyer_id": buyerId,
    "seller_id": sellerId,
    "availability_id": availabilityId,
    "status": status,
    "notes_to_seller": notesToSeller,
  };

  // void cancel() {
  //   status = "canceled";
  // }
  //
  // void approve() {
  //   status = "approved";
  // }
}
