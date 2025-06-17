// lib/main.dart
import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'services/auth_service.dart';
import 'pages/home_page.dart';
import 'pages/order_history_page.dart';
import 'pages/qris_barcode_page.dart';
import 'pages/confirm_pulsa_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService _authService = AuthService();
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pulsa App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[700],
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ),
      // Ubah home menjadi HomePage langsung
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/order-history': (context) => OrderHistoryPage(),
        '/qris': (context) => QRISBarcodePage(),
      },
      
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/confirm-pulsa':
            final args = settings.arguments as Map<String, String>;
            return MaterialPageRoute(
              builder: (context) => ConfirmPulsaPage(
                nomorHp: args['nomorHp']!,
                nominal: args['nominal']!,
              ),
            );
          default:
            return null;
        }
      },
      
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text('Error'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Halaman tidak ditemukan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Route: ${settings.name}',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/home',
                        (route) => false,
                      );
                    },
                    child: Text('Kembali ke Home'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String orderHistory = '/order-history';
  static const String qris = '/qris';
  static const String confirmPulsa = '/confirm-pulsa';
  
  static void toLogin(BuildContext context) {
    Navigator.of(context).pushNamed(login);
  }
  
  static void toHome(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(home);
  }
  
  static void toOrderHistory(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(orderHistory);
  }
  
  static void toQRIS(BuildContext context) {
    Navigator.of(context).pushNamed(qris);
  }
  
  static void toConfirmPulsa(BuildContext context, String nomorHp, String nominal) {
    Navigator.of(context).pushNamed(
      confirmPulsa,
      arguments: {
        'nomorHp': nomorHp,
        'nominal': nominal,
      },
    );
  }
}