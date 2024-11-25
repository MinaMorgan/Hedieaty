import 'package:flutter/material.dart';
import '/screens/home/home_page.dart';
import '/screens/auth/login_page.dart';
import '/screens/auth/register_page.dart';
import '/screens/event/events_page.dart';
import '/screens/event/add_event_page.dart';
import '/screens/gifts/gifts_page.dart';
import '/screens/gifts/pledged_gifts_page.dart';
import '/screens/profile/profile_page.dart';
import '/screens/profile/update_info_page.dart';

import 'package:firebase_core/firebase_core.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(HedieatyApp());
}

class HedieatyApp extends StatelessWidget {
  const HedieatyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hedieaty',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
        initialRoute: '/login',
        routes: {
          '/home': (context) => HomePage(),
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
          '/events': (context) => EventsPage(),
          '/addEvent': (context) => AddEventPage(),
          '/gifts': (context) => GiftsPage(eventTitle: "eventTitle"),
          '/pledgedGifts': (context) => PledgedGiftsPage(),
          '/profile': (context) => ProfilePage(),
          '/updateInfo': (context) => UpdateInfoPage(),
        },
    );
  }
}

