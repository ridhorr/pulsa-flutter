import 'package:flutter/material.dart';
import '../services/order_service.dart';
import 'home_page.dart'; // Changed from login_page.dart to home_page.dart

class ConfirmPesananPage extends StatelessWidget {
  final String nama;
  final String nomorTelepon;
  final String alamat;
  final List<Map<String, dynamic>> items;
  final double totalHarga;
  final OrderService _orderService = OrderService();

  ConfirmPesananPage({
    required this.nama,
    required this.nomorTelepon,
    required this.alamat,
    required this.items,
    required this.totalHarga,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Konfirmasi Pembayaran'),
        backgroundColor: Color(0xFFE64C3C),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Color(0xFFE7B8B8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.receipt_long,
                        size: 40, color: Color(0xFFE64C3C)),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Detail Transaksi',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('Konfirmasi pesanan Anda',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black87)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 25),

              // Informasi Pemesan
              Text("Informasi Pemesan",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow("Nama", nama),
                      Divider(),
                      _buildDetailRow("Nomor Telepon", nomorTelepon),
                      Divider(),
                      _buildDetailRow("Alamat", alamat),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 25),

              // Detail Pesanan
              Text("Detail Pesanan",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...items.map((item) => _buildItemRow(
                            "${item['name']}",
                            "${item['quantity']} ${item['unit']}",
                            "Rp ${(item['price'] * item['quantity']).toStringAsFixed(0)}",
                          )),
                      Divider(thickness: 1.5),
                      _buildDetailRow(
                          "Total Harga", "Rp ${totalHarga.toStringAsFixed(0)}",
                          isBold: true),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30),

              // Metode Pembayaran
              Text("Metode Pembayaran",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      RadioListTile(
                        title: Text("Bayar di Tempat (COD)"),
                        value: 1,
                        groupValue: 1,
                        onChanged: (value) {},
                        activeColor: Color(0xFFE64C3C),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30),

              // Tombol Konfirmasi
              Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      final List<String> orderItems = items.map((item) {
                        return "${item['quantity']} ${item['unit']} ${item['name']}";
                      }).toList();

                      // Panggilan ke OrderService yang diperbaiki
                      await _orderService.addOrder(
                        type: 'pesanan_antar',
                        phoneNumber: nomorTelepon,
                        amount:
                            "${orderItems.join(", ")} | Nama: $nama | Alamat: $alamat",
                        provider: 'Pesanan Siap Antar',
                        price: "Rp ${totalHarga.toStringAsFixed(0)}",
                      );

                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Pesanan Berhasil'),
                          content: Text(
                              'Pesanan Anda akan segera diantar ke $alamat.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (_) => HomePage()), // Changed from LoginPage to HomePage
                                  (route) => false,
                                );
                              },
                              child: Text('selesai'),
                            ),
                          ],
                        ),
                      );
                    } catch (e) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Error'),
                          content: Text('Terjadi kesalahan: ${e.toString()}'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  icon: Icon(Icons.check_circle),
                  label: Text("Konfirmasi Pesanan"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE64C3C),
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
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
          Text(label, style: TextStyle(fontSize: 16, color: Colors.black87)),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: isBold ? Color(0xFFE64C3C) : Colors.black,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(String item, String quantity, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(flex: 5, child: Text(item, style: TextStyle(fontSize: 15))),
          Expanded(
              flex: 2,
              child: Text(quantity,
                  style: TextStyle(fontSize: 15), textAlign: TextAlign.center)),
          Expanded(
              flex: 3,
              child: Text(price,
                  style: TextStyle(fontSize: 15), textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}