// lib/pages/qris_barcode_page.dart
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'home_page.dart';

class QRISBarcodePage extends StatefulWidget {
  const QRISBarcodePage({Key? key}) : super(key: key);

  @override
  State<QRISBarcodePage> createState() => _QRISBarcodePageState();
}

class _QRISBarcodePageState extends State<QRISBarcodePage> {
  final String qrisData = '00020101021126640017ID.CO.BANKBSI.WWW0118936004510000400543021000008335910303UMI51440014ID.CO.QRIS.WWW0215ID10243393615930303UMI5204541153033605802ID5910TOKO IMRON6014BANDAR LAMPUNG6105351446304E2A8';
  
  bool _isQRVisible = true;

  // Fungsi untuk menyalin QRIS data ke clipboard
  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: qrisData));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data QRIS berhasil disalin!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Fungsi untuk toggle visibility QR code
  void _toggleQRVisibility() {
    setState(() {
      _isQRVisible = !_isQRVisible;
    });
  }

  // Fungsi untuk kembali ke home
  void _backToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'QRIS Payment',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[700],
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                children: [
                  Icon(
                    Icons.store,
                    size: 40,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'TOKO IMRON',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'BANDAR LAMPUNG',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // QR Code Card
            Container(
              padding: const EdgeInsets.all(25.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 3,
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Scan QR untuk Pembayaran',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // QR Code
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: _isQRVisible ? 280 : 100,
                    child: _isQRVisible 
                      ? QrImageView(
                          data: qrisData,
                          version: QrVersions.auto,
                          size: 280.0,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          errorCorrectionLevel: QrErrorCorrectLevel.M,
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.visibility_off, 
                                     size: 30, 
                                     color: Colors.grey),
                                SizedBox(height: 5),
                                Text('QR Code Disembunyikan',
                                     style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                        ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Toggle Visibility Button
                      ElevatedButton.icon(
                        onPressed: _toggleQRVisibility,
                        icon: Icon(_isQRVisible 
                                 ? Icons.visibility_off 
                                 : Icons.visibility),
                        label: Text(_isQRVisible ? 'Sembunyikan' : 'Tampilkan'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20, 
                            vertical: 12
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                      
                      // Copy Button
                      ElevatedButton.icon(
                        onPressed: _copyToClipboard,
                        icon: const Icon(Icons.copy),
                        label: const Text('Salin'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20, 
                            vertical: 12
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.blue[100]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, 
                           color: Colors.blue[600], 
                           size: 24),
                      const SizedBox(width: 10),
                      Text(
                        'Informasi Pembayaran',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildInfoRow('Merchant', 'TOKO IMRON'),
                  _buildInfoRow('Lokasi', 'BANDAR LAMPUNG'),
                  _buildInfoRow('Bank', 'Bank Syariah Indonesia'),
                  _buildInfoRow('Status', 'Aktif'),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Tombol Selesai
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: _backToHome,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE64C3C),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.check_circle_outline, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Selesai',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Footer
            Container(
              padding: const EdgeInsets.all(15),
              child: const Text(
                'Pastikan aplikasi pembayaran Anda mendukung QRIS\nuntuk melakukan transaksi',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          const Text(
            ': ',
            style: TextStyle(color: Colors.grey),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}