// lib/pages/confirm_pulsa_page.dart
import 'package:flutter/material.dart';
import '../services/order_service.dart';
import 'qris_barcode_page.dart';

class ConfirmPulsaPage extends StatelessWidget {
  final String nomorHp;
  final String nominal;
  final OrderService _orderService = OrderService();

  ConfirmPulsaPage({required this.nomorHp, required this.nominal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Konfirmasi Pembayaran'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[50],
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue[700]!, Colors.blue[500]!],
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.phone_android, color: Colors.white, size: 30),
                      SizedBox(width: 10),
                      Text(
                        "Detail Transaksi", 
                        style: TextStyle(
                          fontSize: 20, 
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _buildDetailRow("Nomor HP", nomorHp, Icons.phone),
                  SizedBox(height: 15),
                  _buildDetailRow("Nominal", "Rp $nominal", Icons.money),
                  SizedBox(height: 15),
                  _buildDetailRow("Jenis", "Pulsa", Icons.sim_card),
                ],
              ),
            ),
            
            SizedBox(height: 30),
            
            // Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.orange[100]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange[600], size: 24),
                  SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      'Setelah konfirmasi, Anda akan diarahkan ke halaman pembayaran QRIS',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange[800],
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Spacer(),
            
            // Action Buttons
            Column(
              children: [
                // Konfirmasi Button - Modified to go directly to QRIS
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      // Show loading
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Row(
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(width: 20),
                                Text("Memproses transaksi..."),
                              ],
                            ),
                          );
                        },
                      );

                      try {
                        // Add to order history
                        await _orderService.addOrder(
                          type: 'pulsa',
                          phoneNumber: nomorHp,
                          amount: nominal,
                          price: nominal,
                        );
                        
                        // Close loading dialog
                        Navigator.of(context).pop();
                        
                        // Navigate directly to QRIS page
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => QRISBarcodePage(),
                          ),
                        );
                      } catch (e) {
                        // Close loading dialog
                        Navigator.of(context).pop();
                        
                        // Show error dialog
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Row(
                              children: [
                                Icon(Icons.error, color: Colors.red),
                                SizedBox(width: 10),
                                Text('Error'),
                              ],
                            ),
                            content: Text('Terjadi kesalahan saat memproses transaksi. Silakan coba lagi.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    icon: Icon(Icons.qr_code, size: 24),
                    label: Text(
                      "Konfirmasi & Bayar dengan QRIS",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: 15),
                
                // Cancel Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop(); // Go back
                    },
                    icon: Icon(Icons.arrow_back),
                    label: Text("Kembali"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                      side: BorderSide(color: Colors.grey[400]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        SizedBox(width: 10),
        Text(
          "$label: ",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}