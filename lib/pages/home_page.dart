import 'package:flutter/material.dart';
import 'pulsa_page.dart';
import 'kuota_page.dart';
import 'air_page.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Tambahkan AppBar dengan tombol login
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // Menghilangkan tombol back
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                );
              },
              icon: Icon(
                Icons.login,
                color: Color(0xFFE64C3C),
                size: 28,
              ),
              tooltip: 'Login',
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFFCF2F2)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top section with "TOP UP APP" header
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16),
                margin: EdgeInsets.only(top: 20, left: 30, right: 30), // Dikurangi top margin karena ada AppBar
                decoration: BoxDecoration(
                  color: Color(0xFFE29797),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 3,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'TOP UP APP',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
              
              // Container for the menu buttons
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                padding: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
                decoration: BoxDecoration(
                  color: Color(0xFFE7B8B8),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // PULSA button
                    _buildMenuButton(
                      context,
                      'PULSA',
                      Icons.smartphone,
                      () => Navigator.push(context, MaterialPageRoute(builder: (_) => PulsaPage())),
                    ),
                    
                    // Gap between buttons
                    SizedBox(height: 20),
                    
                    // KUOTA button
                    _buildMenuButton(
                      context,
                      'KUOTA',
                      Icons.wifi,
                      () => Navigator.push(context, MaterialPageRoute(builder: (_) => KuotaPage())),
                    ),
                    
                    // Gap between buttons
                    SizedBox(height: 20),
                    
                    // PESANAN SIAP ANTAR button
                    _buildMenuButton(
                      context,
                      'PESANAN SIAP ANTAR',
                      Icons.delivery_dining,
                      () => Navigator.push(context, MaterialPageRoute(builder: (_) => AirPage())),
                    ),
                  ],
                ),
              ),
              
              // Footer text
              Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  'Version 1.0',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF999999),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildMenuButton(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 80,
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Color(0xFFE64C3C),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFE64C3C).withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
            SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}