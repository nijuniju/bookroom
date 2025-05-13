class form_booking {
  final String Nama;
  final String Tujuan;
  final String Lokasi;
  final String Deskripsi; // ✅ Tambahkan field ini
  final DateTime Start;
  final Duration Estimasi;
  final String Timestamp;

  form_booking({
    required this.Timestamp,
    required this.Nama,
    required this.Tujuan,
    required this.Lokasi,
    required this.Deskripsi, // ✅ Tambahkan di konstruktor
    required this.Start,
    required this.Estimasi,
  });

  form_booking.fromJson(Map<String, dynamic> json)
      : Timestamp = json['Timestamp'],
        Nama = json['Nama'],
        Tujuan = json['Tujuan'],
        Lokasi = json['Lokasi'],
        Deskripsi = json['Deskripsi'], // ✅ Tambahkan di fromJson
        Start = DateTime.parse(json['Start']),
        Estimasi = Duration(minutes: json['Estimasi']);

  Map<String, dynamic> toJson() => {
        'Timestamp': Timestamp,
        'Nama': Nama,
        'Tujuan': Tujuan,
        'Lokasi': Lokasi,
        'Deskripsi': Deskripsi, // ✅ Tambahkan di toJson
        'Start': Start.toIso8601String(),
        'Estimasi': Estimasi.inMinutes,
      };

  String formattedDuration() {
    int hours = Estimasi.inHours;
    int minutes = Estimasi.inMinutes % 60;

    if (hours > 0) {
      return "$hours jam $minutes menit";
    } else {
      return "$minutes menit";
    }
  }
}