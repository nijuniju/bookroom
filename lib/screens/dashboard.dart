import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/form_booking.dart';
import '../widget/form_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<form_booking> bookings = [];

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('uid', isEqualTo: user.uid)
        .get();

    final loadedBookings = snapshot.docs.map<form_booking>((doc) {
     final data = doc.data();
      return form_booking(
      Nama: data['Nama'] ?? '',
      Tujuan: data['Tujuan'] ?? '',
      Lokasi: data['Lokasi'] ?? '',
      Deskripsi: data['Deskripsi'] ?? '',
      Start: DateTime.parse(data['Start']),
      Estimasi: Duration(minutes: data['Estimasi']),
      Timestamp: doc.id,
  );
}).toList();


    setState(() => bookings = loadedBookings);
  }

  void addBooking(form_booking booking) {
    setState(() => bookings.add(booking));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Booking berhasil disimpan!'),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final onGoingBookings = bookings.where((b) {
      final end = b.Start.add(b.Estimasi);
      return DateTime.now().isAfter(b.Start) && DateTime.now().isBefore(end);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF5E4F34),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  SizedBox(height: 20),
                  Text(
                    'DASHBOARD',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 5,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 4,
                          color: Colors.black45,
                          offset: Offset(5, 5),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Pantau jadwal meeting Anda di sini',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg_meeting.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // overlay gelap
          Container(
            color: Colors.black.withOpacity(0.4),
          ),
          // konten
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: Colors.white.withOpacity(0.95),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: BookingForm(onSubmit: addBooking),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  "📍 Meeting On-going",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 4,
                        color: Colors.black26,
                        offset: Offset(1, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                if (onGoingBookings.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    alignment: Alignment.center,
                    child: const Text(
                      '⏳ Tidak ada meeting yang sedang berlangsung.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ...onGoingBookings.map(
                  (booking) => Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    color: Colors.white.withOpacity(0.95),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        booking.Nama,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text('Tujuan: ${booking.Tujuan}'),
                          const SizedBox(height: 2),
                          Text(
                            '${DateFormat.Hm().format(booking.Start)} - ${DateFormat.Hm().format(booking.Start.add(booking.Estimasi))}',
                            style: const TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}