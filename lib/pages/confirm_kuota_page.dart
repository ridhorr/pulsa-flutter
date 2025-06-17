import 'package:flutter/material.dart';
import '../services/order_service.dart';
import 'qris_barcode_page.dart'; // Import QRIS page instead of login page

class ConfirmKuotaPage extends StatelessWidget {
  final String nomorHp;
  final String provider;
  final String paket;
  final String harga;
  final OrderService _orderService = OrderService();

  ConfirmKuotaPage({
    required this.nomorHp, 
    required this.provider, 
    required this.paket, 
    required this.harga
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Konfirmasi Pembayaran')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Detail Transaksi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow("Nomor HP", nomorHp),
                    Divider(),
                    _buildDetailRow("Provider", provider),
                    Divider(),
                    _buildDetailRow("Paket Data", paket),
                    Divider(),
                    _buildDetailRow("Harga", harga, isBold: true),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  // Add to order history
                  await _orderService.addOrder(
                    type: 'kuota',
                    phoneNumber: nomorHp,
                    amount: paket,
                    provider: provider,
                    price: harga,
                  );
                  
                  // Navigate directly to QRIS page for payment
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QRISBarcodePage(),
                    ),
                  );
                },
                icon: Icon(Icons.qr_code),
                label: Text("Lanjut ke Pembayaran QRIS"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  
  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16)),
          Text(
            value, 
            style: TextStyle(
              fontSize: 16, 
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal
            )
          ),
        ],
      ),
    );
  }
}