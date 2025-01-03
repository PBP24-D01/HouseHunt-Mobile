class House {
  final int id;
  final String title;
  final String description;
  final int price;
  final String location;
  final int bedrooms;
  final int bathrooms;
  bool isAvailable;
  final String? imageUrl;

  House({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.location,
    required this.bedrooms,
    required this.bathrooms,
    required this.isAvailable,
    this.imageUrl,
  });

  factory House.fromJson(Map<String, dynamic> json) {
    String? imageUrl = json['gambar'];
    if (imageUrl != null && !imageUrl.startsWith('http')) {
      imageUrl = 'http://localhost:8000/$imageUrl';
    }
    return House(
      id: json['id'] ?? 0,
      title: json['judul'] ?? '',
      description: json['deskripsi'] ?? '',
      price: json['harga'] ?? 0,
      location: json['lokasi'] ?? '',
      bedrooms: json['kamar_tidur'] ?? 0,
      bathrooms: json['kamar_mandi'] ?? 0,
      isAvailable: json['is_available'] ?? false,
      imageUrl: imageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': title,
      'deskripsi': description,
      'harga': price,
      'lokasi': location,
      'kamar_tidur': bedrooms,
      'kamar_mandi': bathrooms,
      'is_available': isAvailable,
      'gambar': imageUrl,
    };
  }
}
