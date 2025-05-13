import 'package:flutter/material.dart';
import '../models/form_booking.dart';
import 'package:intl/intl.dart';

class BookingCard extends StatelessWidget {
  final form_booking booking;

  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final end = booking.Start.add(booking.Estimasi);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.meeting_room_rounded),
        title: Text(booking.Nama),
        subtitle: Text('${booking.Lokasi} | ${DateFormat.Hm().format(booking.Start)} - ${DateFormat.Hm().format(end)}'),
        trailing: Text(booking.formattedDuration()),
      ),
    );
  }
}
