import 'package:flutter/material.dart';
import '../models/form_booking.dart';

class BookingForm extends StatefulWidget {
  final void Function(form_booking) onSubmit;

  const BookingForm({super.key, required this.onSubmit});

  @override
  State<BookingForm> createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final _namaController = TextEditingController();
  final _tujuanController = TextEditingController();
  final _deskripsiController = TextEditingController();

  String? _selectedLokasi;
  DateTime? _startDateTime;
  Duration _estimasi = const Duration(hours: 1);
  bool _isExpanded = true;

  final List<String> lokasiList = [
    'Ruang Meeting Office Legok - 3A (RMB) ~ Kapasitas 20 Orang',
    'Ruang Meeting Manajemen - 3A (RMM) ~ Kapasitas 7 Orang',
    'Ruang Meeting Office Legok - 12A (RMA) ~ Kapasitas 7 Orang',
    'Ruang Meeting Office VRI (RMV) ~ Kapasitas 9 Orang',
    'Ruang Meeting Office Tekno - K3 (RMK) ~ Kapasitas 7 Orang',
    'Ruang Meeting Office The Breeze (RMO) ~ Kapasitas 8 Orang',
    'Ruang Meeting Office Nganjuk (RMN) ~ Kapasitas 10 Orang',
  ];

  void _submit() {
    if (_startDateTime == null ||
        _namaController.text.isEmpty ||
        _selectedLokasi == null ||
        _tujuanController.text.isEmpty ||
        _deskripsiController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi semua kolom dan pilih waktu mulai.')),
      );
      return;
    }

    final booking = form_booking(
      Timestamp: DateTime.now().toIso8601String(),
      Nama: _namaController.text,
      Lokasi: _selectedLokasi!,
      Start: _startDateTime!,
      Estimasi: _estimasi,
      Tujuan: _tujuanController.text,
      Deskripsi: _deskripsiController.text,
    );

    widget.onSubmit(booking);

    // Clear form
    _namaController.clear();
    _tujuanController.clear();
    _deskripsiController.clear();
    _selectedLokasi = null;
    _startDateTime = null;
    _estimasi = const Duration(hours: 1);
    setState(() {});
  }

  void _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );

    if (time == null) return;

    setState(() {
      _startDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.all(12),
      child: ExpansionTile(
        initiallyExpanded: _isExpanded,
        onExpansionChanged: (expanded) {
          setState(() => _isExpanded = expanded);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Form Booking",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _namaController,
                  decoration: const InputDecoration(labelText: 'Nama'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Lokasi Ruang Meeting'),
                  value: _selectedLokasi,
                  items: lokasiList.map((lokasi) {
                    return DropdownMenuItem(
                      value: lokasi,
                      child: Text(lokasi),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedLokasi = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _tujuanController,
                  decoration: const InputDecoration(labelText: 'Tujuan Meeting'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _deskripsiController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi Meeting',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _startDateTime == null
                            ? 'Pilih waktu mulai'
                            : 'Mulai: ${_startDateTime.toString().substring(0, 16)}',
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _pickDateTime,
                      icon: const Icon(Icons.calendar_today),
                      label: const Text("Pilih Waktu"),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text("Estimasi: "),
                    const SizedBox(width: 10),
                    DropdownButton<int>(
                      value: _estimasi.inMinutes,
                      items: [30, 60, 90, 120]
                          .map((min) => DropdownMenuItem(
                                value: min,
                                child: Text("$min menit"),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _estimasi = Duration(minutes: val);
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.send),
                    label: const Text('Submit Booking'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}