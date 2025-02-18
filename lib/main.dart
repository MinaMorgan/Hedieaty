import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '/screens/home/home_page.dart';
import '/screens/friends/add_friend_page.dart';
import '/screens/auth/login_page.dart';
import '/screens/auth/register_page.dart';
import '/screens/events/events_page.dart';
import '/screens/gifts/gifts_page.dart';
import '/screens/gifts/gift_details_page.dart';
import '/screens/gifts/pledged_gifts_page.dart';
import '/screens/profile/profile_page.dart';
import '/screens/profile/update_info_page.dart';
import '/screens/notifications/notifications_page.dart';

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
          '/addFriend': (context) => AddFriendPage(),
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
          '/events': (context) => EventsPage(),
          '/gifts': (context) => GiftsPage(),
          '/giftDetails': (context) => GiftDetailsPage(),
          '/pledgedGifts': (context) => PledgedGiftsPage(),
          '/profile': (context) => ProfilePage(),
          '/updateInfo': (context) => UpdateInfoPage(),
          '/notifications': (context) => NotificationsPage(),
        },
    );
  }
}

