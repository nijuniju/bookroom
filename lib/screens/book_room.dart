import 'package:flutter/material.dart';
import '../models/form_booking.dart';
import '../widget/form_widget.dart';
import '../screens/booking_list.dart'; // opsional kalau kamu pakai

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<form_booking> bookings = [];

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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Meeting Dashboard'),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            BookingForm(onSubmit: addBooking),
            const SizedBox(height: 24),
            Text("Meeting On-going", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            if (onGoingBookings.isEmpty)
              const Text('Tidak ada meeting yang sedang berlangsung.'),
            ...onGoingBookings.map((booking) => BookingCard(booking: booking)),
          ],
        ),
      ),
    );
  }
}