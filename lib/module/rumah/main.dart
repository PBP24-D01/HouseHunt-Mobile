import 'package:flutter/material.dart';

class House {
  final String judul;
  final String deskripsi;
  final int harga;
  final String lokasi;
  final String gambar;
  final int kamarTidur;
  final int kamarMandi;
  final bool isAvailable;
  final String seller;

  House({
    required this.judul,
    required this.deskripsi,
    required this.harga,
    required this.lokasi,
    required this.gambar,
    required this.kamarTidur,
    required this.kamarMandi,
    required this.isAvailable,
    required this.seller,
  });

  factory House.fromJson(Map<String, dynamic> json) {
    return House(
      judul: json['judul'],
      deskripsi: json['deskripsi'],
      harga: json['harga'],
      lokasi: json['lokasi'],
      gambar: json['gambar'],
      kamarTidur: json['kamar_tidur'],
      kamarMandi: json['kamar_mandi'],
      isAvailable: json['is_available'],
      seller: json['seller'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'judul': judul,
      'deskripsi': deskripsi,
      'harga': harga,
      'lokasi': lokasi,
      'gambar': gambar,
      'kamar_tidur': kamarTidur,
      'kamar_mandi': kamarMandi,
      'is_available': isAvailable,
      'seller': seller,
    };
  }
}

void main() {
  runApp(rumah());
}

class rumah extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HouseListPage(),
    );
  }
}

class HouseListPage extends StatefulWidget {
  @override
  _HouseListPageState createState() => _HouseListPageState();
}

class _HouseListPageState extends State<HouseListPage> {
  final List<House> houses = [
    // dummy houses made by chat gbt
    House(
      judul: 'Beautiful House 1',
      deskripsi: 'This is a beautiful house with 3 bedrooms and 2 bathrooms.',
      harga: 1000000,
      lokasi: 'Location 1',
      gambar: 'https://example.com/house.jpg',
      kamarTidur: 3,
      kamarMandi: 2,
      isAvailable: true,
      seller: 'Seller 1',
    ),
    House(
      judul: 'Modern House 2',
      deskripsi: 'A modern house with a spacious garden and pool.',
      harga: 2000000,
      lokasi: 'Location 2',
      gambar: 'https://example.com/house.jpg',
      kamarTidur: 4,
      kamarMandi: 3,
      isAvailable: true,
      seller: 'Seller 2',
    ),
  ];

  String? selectedPriceRange;
  String? selectedLocation;
  String? selectedBedrooms;
  String? selectedBathrooms;
  bool selectedAvailability = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Landing Page or something'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // filters
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(labelText: 'Rentang Harga'),
                        value: selectedPriceRange,
                        items: const [
                          DropdownMenuItem(
                              value: '', child: Text('Semua Harga')),
                          DropdownMenuItem(
                              value: '0-500000000',
                              child: Text('Dibawah 500 Juta')),
                          DropdownMenuItem(
                              value: '500000000-1000000000',
                              child: Text('500 Juta - 1 Miliar')),
                          DropdownMenuItem(
                              value: '1000000000-2000000000',
                              child: Text('1 Miliar - 2 Miliar')),
                          DropdownMenuItem(
                              value: '2000000000-999999999999',
                              child: Text('Diatas 2 Miliar')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedPriceRange = value;
                          });
                        },
                      ),
                      // ini yg bagian ini gw minta chatgpt btw
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(labelText: 'Lokasi'),
                        value: selectedLocation,
                        items: const [
                          DropdownMenuItem(value: '', child: Text('Semua')),
                          DropdownMenuItem(
                              value: 'Babelan', child: Text('Babelan')),
                          DropdownMenuItem(
                              value: 'Bantar Gebang',
                              child: Text('Bantar Gebang')),
                          DropdownMenuItem(
                              value: 'Bekasi', child: Text('Bekasi')),
                          DropdownMenuItem(
                              value: 'Bekasi Barat',
                              child: Text('Bekasi Barat')),
                          DropdownMenuItem(
                              value: 'Bekasi Kota', child: Text('Bekasi Kota')),
                          DropdownMenuItem(
                              value: 'Bekasi Timur',
                              child: Text('Bekasi Timur')),
                          DropdownMenuItem(
                              value: 'Bekasi Utara',
                              child: Text('Bekasi Utara')),
                          DropdownMenuItem(
                              value: 'Bintara', child: Text('Bintara')),
                          DropdownMenuItem(
                              value: 'Caman', child: Text('Caman')),
                          DropdownMenuItem(
                              value: 'Cibitung', child: Text('Cibitung')),
                          DropdownMenuItem(
                              value: 'Cibubur', child: Text('Cibubur')),
                          DropdownMenuItem(
                              value: 'Cikarang', child: Text('Cikarang')),
                          DropdownMenuItem(
                              value: 'Cikarang Selatan',
                              child: Text('Cikarang Selatan')),
                          DropdownMenuItem(
                              value: 'Cikunir', child: Text('Cikunir')),
                          DropdownMenuItem(
                              value: 'Cimuning', child: Text('Cimuning')),
                          DropdownMenuItem(
                              value: 'Duren Jaya', child: Text('Duren Jaya')),
                          DropdownMenuItem(
                              value: 'Duta Harapan',
                              child: Text('Duta Harapan')),
                          DropdownMenuItem(
                              value: 'Galaxy', child: Text('Galaxy')),
                          DropdownMenuItem(
                              value: 'Golden City', child: Text('Golden City')),
                          DropdownMenuItem(
                              value: 'Grand Wisata',
                              child: Text('Grand Wisata')),
                          DropdownMenuItem(
                              value: 'Harapan Baru',
                              child: Text('Harapan Baru')),
                          DropdownMenuItem(
                              value: 'Harapan Indah',
                              child: Text('Harapan Indah')),
                          DropdownMenuItem(
                              value: 'Harapan Jaya',
                              child: Text('Harapan Jaya')),
                          DropdownMenuItem(
                              value: 'Harapan Mulya',
                              child: Text('Harapan Mulya')),
                          DropdownMenuItem(
                              value: 'Jababeka', child: Text('Jababeka')),
                          DropdownMenuItem(
                              value: 'Jaka Sampurna',
                              child: Text('Jaka Sampurna')),
                          DropdownMenuItem(
                              value: 'Jatibening', child: Text('Jatibening')),
                          DropdownMenuItem(
                              value: 'Jati Asih', child: Text('Jati Asih')),
                          DropdownMenuItem(
                              value: 'Jati Cempaka',
                              child: Text('Jati Cempaka')),
                          DropdownMenuItem(
                              value: 'Jati Luhur', child: Text('Jati Luhur')),
                          DropdownMenuItem(
                              value: 'Jati Mekar', child: Text('Jati Mekar')),
                          DropdownMenuItem(
                              value: 'Jatiwarna', child: Text('Jatiwarna')),
                          DropdownMenuItem(
                              value: 'Jatikramat', child: Text('Jatikramat')),
                          DropdownMenuItem(
                              value: 'Jatimakmur', child: Text('Jatimakmur')),
                          DropdownMenuItem(
                              value: 'Jatimurni', child: Text('Jatimurni')),
                          DropdownMenuItem(
                              value: 'Jatiraden', child: Text('Jatiraden')),
                          DropdownMenuItem(
                              value: 'Jatiranggon', child: Text('Jatiranggon')),
                          DropdownMenuItem(
                              value: 'Jatisampurna',
                              child: Text('Jatisampurna')),
                          DropdownMenuItem(
                              value: 'Jatiwaringin',
                              child: Text('Jatiwaringin')),
                          DropdownMenuItem(
                              value: 'Kaliabang', child: Text('Kaliabang')),
                          DropdownMenuItem(
                              value: 'Karang Satria',
                              child: Text('Karang Satria')),
                          DropdownMenuItem(
                              value: 'Kayuringin Jaya',
                              child: Text('Kayuringin Jaya')),
                          DropdownMenuItem(
                              value: 'Kebalen', child: Text('Kebalen')),
                          DropdownMenuItem(
                              value: 'Kemang Pratama',
                              child: Text('Kemang Pratama')),
                          DropdownMenuItem(
                              value: 'Komsen', child: Text('Komsen')),
                          DropdownMenuItem(
                              value: 'Kranji', child: Text('Kranji')),
                          DropdownMenuItem(
                              value: 'Margahayu', child: Text('Margahayu')),
                          DropdownMenuItem(
                              value: 'Medan Satria',
                              child: Text('Medan Satria')),
                          DropdownMenuItem(
                              value: 'Mustika Jaya',
                              child: Text('Mustika Jaya')),
                          DropdownMenuItem(
                              value: 'Mustikasari', child: Text('Mustikasari')),
                          DropdownMenuItem(
                              value: 'Narongong', child: Text('Narongong')),
                          DropdownMenuItem(
                              value: 'Pekayon', child: Text('Pekayon')),
                          DropdownMenuItem(
                              value: 'Pedurenan', child: Text('Pedurenan')),
                          DropdownMenuItem(
                              value: 'Pejuang', child: Text('Pejuang')),
                          DropdownMenuItem(
                              value: 'Perwira', child: Text('Perwira')),
                          DropdownMenuItem(
                              value: 'Pondok Gede', child: Text('Pondok Gede')),
                          DropdownMenuItem(
                              value: 'Pondok Melati',
                              child: Text('Pondok Melati')),
                          DropdownMenuItem(
                              value: 'Pondok Ungu', child: Text('Pondok Ungu')),
                          DropdownMenuItem(
                              value: 'Rawalumbu', child: Text('Rawalumbu')),
                          DropdownMenuItem(
                              value: 'Satria Jaya', child: Text('Satria Jaya')),
                          DropdownMenuItem(
                              value: 'Serang Baru', child: Text('Serang Baru')),
                          DropdownMenuItem(value: 'Setu', child: Text('Setu')),
                          DropdownMenuItem(
                              value: 'Summarecon', child: Text('Summarecon')),
                          DropdownMenuItem(
                              value: 'Tambun Selatan',
                              child: Text('Tambun Selatan')),
                          DropdownMenuItem(
                              value: 'Tambung Utara',
                              child: Text('Tambung Utara')),
                          DropdownMenuItem(
                              value: 'Tanah Tinggi',
                              child: Text('Tanah Tinggi')),
                          DropdownMenuItem(
                              value: 'Tarumajaya', child: Text('Tarumajaya')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedLocation = value;
                          });
                        },
                      ),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(labelText: 'Kamar Tidur'),
                        value: selectedBedrooms,
                        items: const [
                          DropdownMenuItem(value: '', child: Text('Semua')),
                          DropdownMenuItem(value: '1', child: Text('1')),
                          DropdownMenuItem(value: '2', child: Text('2')),
                          DropdownMenuItem(value: '3', child: Text('3')),
                          DropdownMenuItem(value: '4+', child: Text('4+')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedBedrooms = value;
                          });
                        },
                      ),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(labelText: 'Kamar Mandi'),
                        value: selectedBathrooms,
                        items: const [
                          DropdownMenuItem(value: '', child: Text('Semua')),
                          DropdownMenuItem(value: '1', child: Text('1')),
                          DropdownMenuItem(value: '2', child: Text('2')),
                          DropdownMenuItem(value: '3+', child: Text('3+')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedBathrooms = value;
                          });
                        },
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: selectedAvailability,
                            onChanged: (value) {
                              setState(() {
                                selectedAvailability = value!;
                              });
                            },
                          ),
                          const Text('Tersedia'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Search Houses'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // House Listings
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: houses.length,
              itemBuilder: (context, index) {
                return HouseCard(house: houses[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HouseCard extends StatelessWidget {
  final House house;

  const HouseCard({super.key, required this.house});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(house.gambar),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              house.judul,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(house.deskripsi),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Harga: ${house.harga}'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Lokasi: ${house.lokasi}'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Kamar Tidur: ${house.kamarTidur}'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Kamar Mandi: ${house.kamarMandi}'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Available: ${house.isAvailable ? "Yes" : "No"}'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Seller: ${house.seller}'),
          ),
        ],
      ),
    );
  }
}
