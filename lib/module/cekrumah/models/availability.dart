import 'dart:convert';


Availability availabilityFromJson(String str) => Availability.fromJson(json.decode(str));

String availabilityToJson(Availability data) => json.encode(data.toJson());

class Availability {
  int id;
  int sellerId;
  int houseId;
  DateTime availableDate;
  String startTime; // Stored as "HH:mm" string
  String endTime;   // Stored as "HH:mm" string
  bool isAvailable;

  Availability({
    required this.id,
    required this.sellerId,
    required this.houseId,
    required this.availableDate,
    required this.startTime,
    required this.endTime,
    this.isAvailable = true,
  });

  factory Availability.fromJson(Map<String, dynamic> json) => Availability(
    id: json["id"],
    sellerId: json["seller_id"],
    houseId: json["house_id"],
    availableDate: DateTime.parse(json["available_date"]),
    startTime: json["start_time"],
    endTime: json["end_time"],
    isAvailable: json["is_available"] ?? true,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "seller_id": sellerId,
    "house_id": houseId,
    "available_date": availableDate.toIso8601String(),
    "start_time": startTime,
    "end_time": endTime,
    "is_available": isAvailable,
  };

//   // Validation method
//   String? validate() {
//     final start = TimeOfDay.fromString(startTime);
//     final end = TimeOfDay.fromString(endTime);
//
//     if (end.hour < start.hour || (end.hour == start.hour && end.minute <= start.minute)) {
//       return "End time must be after start time.";
//     }
//     return null; // No validation error
//   }
// }
//
// class TimeOfDay {
//   final int hour;
//   final int minute;
//
//   TimeOfDay(this.hour, this.minute);
//
//   factory TimeOfDay.fromString(String time) {
//     final parts = time.split(":").map(int.parse).toList();
//     return TimeOfDay(parts[0], parts[1]);
//   }
}
