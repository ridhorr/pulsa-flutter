import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/order.dart';

class OrderDescriptionPage extends StatelessWidget {
  final Order order;

  const OrderDescriptionPage({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              _buildCustomAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildOrderSummaryCard(),
                      SizedBox(height: 20), // Added context here
                      _buildDescriptionCard(context),
                      SizedBox(height: 20),
                      _buildOrderDetailsCard(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Icons.arrow_back_ios_rounded,
                  size: 20, color: Color(0xFFE64C3C)),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              'Detail Pesanan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryCard() {
    final month = DateFormat('MMM').format(order.date);
    final day = DateFormat('dd').format(order.date);

    Color getTypeColor() {
      switch (order.type) {
        case 'pulsa':
          return Color(0xFFE64C3C);
        case 'kuota':
        case 'paket':
          return Color(0xFF4CAF50);
        case 'pesanan_antar':
          return Color(0xFF2196F3);
        default:
          return Color(0xFF9E9E9E);
      }
    }

    String getTypeLabel() {
      switch (order.type) {
        case 'pulsa':
          return 'PULSA';
        case 'kuota':
        case 'paket':
          return 'KUOTA';
        case 'pesanan_antar':
          return 'PESANAN';
        default:
          return 'LAINNYA';
      }
    }

    IconData getTypeIcon() {
      switch (order.type) {
        case 'pulsa':
          return Icons.smartphone;
        case 'kuota':
        case 'paket':
          return Icons.wifi;
        case 'pesanan_antar':
          return Icons.shopping_bag;
        default:
          return Icons.receipt;
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left date column
            Container(
              width: 80,
              decoration: BoxDecoration(
                color: Color(0xFFE7B8B8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Text(
                    month.toUpperCase(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE64C3C),
                    ),
                  ),
                  Text(
                    day,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),

            // Main content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Type badge
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: getTypeColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            getTypeIcon(),
                            size: 18,
                            color: getTypeColor(),
                          ),
                          SizedBox(width: 8),
                          Text(
                            getTypeLabel(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: getTypeColor(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),

                    // Price
                    Text(
                      order.price,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE64C3C),
                      ),
                    ),

                    SizedBox(height: 12),

                    // Phone number
                    Row(
                      children: [
                        Icon(
                          Icons.phone_android,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 8),
                        Text(
                          order.phoneNumber,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),

                    if (order.provider.isNotEmpty) ...[
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.sim_card,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 8),
                          Text(
                            order.provider,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ],

                    SizedBox(height: 8),

                    // Date and time
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 8),
                        Text(
                          DateFormat('HH:mm, dd MMMM yyyy').format(order.date),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionCard(BuildContext context) {
    // Added context parameter
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xFFE64C3C).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.description,
                    color: Color(0xFFE64C3C),
                    size: 24,
                  ),
                ),
                SizedBox(width: 16),
                Text(
                  'Deskripsi Pemesanan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFE64C3C).withOpacity(0.05),
                    Color(0xFFE64C3C).withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Color(0xFFE64C3C).withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detail Pemesanan:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE64C3C),
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 12),
                  SelectableText(
                    order.amount,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Copy button
            Container(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Copy to clipboard functionality would go here
                  // You can use Clipboard.setData(ClipboardData(text: order.amount));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Deskripsi berhasil disalin'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
                icon: Icon(Icons.copy, size: 18),
                label: Text(
                  'Salin Deskripsi',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE64C3C).withOpacity(0.1),
                  foregroundColor: Color(0xFFE64C3C),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Color(0xFFE64C3C).withOpacity(0.3)),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetailsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xFFE64C3C).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.info_outline,
                    color: Color(0xFFE64C3C),
                    size: 24,
                  ),
                ),
                SizedBox(width: 16),
                Text(
                  'Informasi Transaksi',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  _buildDetailRow('ID Transaksi', order.id),
                  Divider(height: 24),
                  _buildDetailRow('Nomor Handphone', order.phoneNumber),
                  if (order.provider.isNotEmpty) ...[
                    Divider(height: 24),
                    _buildDetailRow('Provider', order.provider),
                  ],
                  Divider(height: 24),
                  _buildDetailRow('Tanggal Transaksi',
                      DateFormat('dd MMMM yyyy').format(order.date)),
                  Divider(height: 24),
                  _buildDetailRow('Waktu Transaksi',
                      DateFormat('HH:mm:ss').format(order.date)),
                  Divider(height: 24),
                  _buildDetailRow('Total Pembayaran', order.price),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          ':',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
