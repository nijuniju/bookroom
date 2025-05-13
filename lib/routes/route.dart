import 'package:flutter/material.dart';
import '../screens/dashboard.dart';
import '../screens/book_room.dart';
import '../screens/booking_list.dart';

class AppRoutes {
  static const String dashboard = '/dashboard';
  static const String bookRoom = '/book-room';
  static const String bookingList = '/booking-list';

  static final routes = <String, WidgetBuilder>{
    dashboard: (context) => DashboardScreen(),
    bookRoom: (context) => BookRoomScreen(),
    bookingList: (context) => BookingListScreen(),
  };
}