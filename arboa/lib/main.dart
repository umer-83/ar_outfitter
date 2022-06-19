import 'package:ar_outfitter/pages/splash_screen.dart';
import 'package:ar_outfitter/pages/viewSizes.dart';
import 'package:flutter/material.dart';
import 'ArMeasureScreen.dart';
import 'package:ar_outfitter/utils/data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'pages/profile.dart';
import 'pages/signup.dart';
import 'pages/login.dart';
import 'pages/home.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  
  await dotenv.load(fileName: '.env');
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return const Routes();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class Routes extends StatefulWidget {
  const Routes({Key key}) : super(key: key);

  @override
  _RoutesState createState() => _RoutesState();
}

class _RoutesState extends State<Routes> {
  List<ServiceCardData> allData;
  bool _initialized = false;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    setDataToList();
    initializeFlutterFire();
  }

  void initializeFlutterFire() async {
    try {
      //Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  void setDataToList() {
    List<ServiceCardData> dummyList = [];
    for (int i = 0; i < data.length; i++) {
      final ServiceCardData item = ServiceCardData.fromListToCardData(data[i]);
      dummyList.add(item);
    }

    setState(() {
      allData = dummyList;
    });
  }

  void addNewItemToList(ServiceCardData newServiceItem) {
    setState(() {
      allData = [...allData, newServiceItem];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Augmented Reality Based Outfitter Application',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Poppins',
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/home': (context) => HomePage(
            title: 'Augmented Reality Based Outfitter Application',
            data: allData),
        '/size': (context) => ArMeasurementScreen(),
        '/details': (context) => AdvancedTilePage(),
        '/addService': (context) => ServiceAddPage(
            initialized: _initialized,
            error: _error,
            addNewService: addNewItemToList),
      },
    );
  }
}
