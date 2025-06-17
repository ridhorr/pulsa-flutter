import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/order.dart';
import '../services/order_service.dart';
import '../services/auth_service.dart';
import 'login_page.dart';
import 'order_description_page.dart'; // Import halaman baru

class OrderHistoryPage extends StatefulWidget {
  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> with SingleTickerProviderStateMixin {
  final OrderService _orderService = OrderService();
  final AuthService _authService = AuthService();
  List<Order> _orders = [];
  bool _isLoading = true;
  TabController? _tabController;
  final List<String> _orderTypes = ['Semua', 'Pulsa', 'Kuota', 'Pesanan'];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _orderTypes.length, vsync: this);
    _loadOrders();
  }
  
  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);
    try {
      final orders = await _orderService.getOrders();
      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat data. Silakan coba lagi.'),
          backgroundColor: Color(0xFFE64C3C),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  List<Order> _getFilteredOrders(String filter) {
    if (filter == 'Semua') return _orders;
    
    return _orders.where((order) {
      switch (filter) {
        case 'Pulsa':
          return order.type == 'pulsa';
        case 'Kuota':
          return order.type == 'kuota' || order.type == 'paket';
        case 'Pesanan':
          return order.type == 'pesanan_antar';
        default:
          return true;
      }
    }).toList();
  }

  Future<void> _confirmDelete(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Color(0xFFFEE2E2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.delete_outline_rounded,
                  color: Color(0xFFE64C3C),
                  size: 32,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Hapus Riwayat?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Anda yakin ingin menghapus riwayat transaksi ini?',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700]),
              ),
              SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black87,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(
                        'Batal',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE64C3C),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(
                        'Hapus',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirm == true) {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE64C3C)),
                ),
                SizedBox(height: 15),
                Text('Menghapus riwayat...'),
              ],
            ),
          ),
        ),
      );

      try {
        await _orderService.deleteOrder(id);
        Navigator.pop(context); // Close loading dialog
        await _loadOrders();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Riwayat berhasil dihapus'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      } catch (e) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghapus riwayat'),
            backgroundColor: Color(0xFFE64C3C),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

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
              // App Bar with back button
              _buildCustomAppBar(),
              
              // Tabs
              _buildTabBar(),
              
              // Content
              Expanded(
                child: _isLoading
                    ? _buildLoadingState()
                    : TabBarView(
                        controller: _tabController,
                        children: _orderTypes.map((type) {
                          final filteredOrders = _getFilteredOrders(type);
                          return filteredOrders.isEmpty
                              ? _buildEmptyState(type)
                              : _buildOrdersList(filteredOrders);
                        }).toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
      // FAB for refresh
      floatingActionButton: FloatingActionButton(
        onPressed: _loadOrders,
        backgroundColor: Color(0xFFE64C3C),
        child: Icon(Icons.refresh, color: Colors.white),
        elevation: 5,
        tooltip: 'Muat Ulang',
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              // Show confirmation dialog before logout
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  title: Text('Konfirmasi'),
                  content: Text('Apakah Anda yakin ingin keluar?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Batal'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE64C3C),
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Keluar'),
                    ),
                  ],
                ),
              );

              if (shouldLogout == true) {
                await _authService.logout();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              }
            },
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
              child: Icon(Icons.arrow_back_ios_rounded, size: 20, color: Color(0xFFE64C3C)),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              'Riwayat Transaksi',
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

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Color(0xFFE7B8B8).withOpacity(0.3),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Color(0xFFE64C3C),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black87,
        labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: TextStyle(fontSize: 12),
        isScrollable: true,
        tabs: _orderTypes.map((type) => Tab(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(type),
          ),
        )).toList(),
      ),
    );
  }
  
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 60,
            width: 60,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE64C3C)),
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Memuat transaksi...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmptyState(String type) {
    IconData getIcon() {
      switch (type) {
        case 'Pulsa':
          return Icons.smartphone;
        case 'Kuota':
          return Icons.wifi;
        case 'Pesanan':
          return Icons.shopping_bag;
        default:
          return Icons.history;
      }
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Color(0xFFE7B8B8).withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                getIcon(),
                size: 60,
                color: Color(0xFFE64C3C).withOpacity(0.7),
              ),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Belum Ada Transaksi ${type != 'Semua' ? type : ''}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Anda belum memiliki riwayat transaksi ${type.toLowerCase() != 'semua' ? type.toLowerCase() : ''} apapun saat ini.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildOrdersList(List<Order> orders) {
    // Sort orders by date (newest first)
    orders.sort((a, b) => b.date.compareTo(a.date));
    
    return RefreshIndicator(
      onRefresh: _loadOrders,
      color: Color(0xFFE64C3C),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        itemCount: orders.length,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final order = orders[index];
          return _buildOrderCard(order);
        },
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
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
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left date column
            Container(
              width: 60,
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
                  Text(
                    month.toUpperCase(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE64C3C),
                    ),
                  ),
                  Text(
                    day,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            
            // Main content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row with type and price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: getTypeColor().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                getTypeIcon(),
                                size: 14,
                                color: getTypeColor(),
                              ),
                              SizedBox(width: 6),
                              Text(
                                getTypeLabel(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: getTypeColor(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          order.price,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE64C3C),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Description Section - Made More Prominent and Tappable
                    GestureDetector(
                      onTap: () {
                        // Navigate to description detail page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderDescriptionPage(order: order),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.description,
                                  size: 16,
                                  color: Color(0xFFE64C3C),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Deskripsi Pemesanan',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFE64C3C),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 12,
                                  color: Color(0xFFE64C3C),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFE64C3C).withOpacity(0.03),
                                    Color(0xFFE64C3C).withOpacity(0.08),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Color(0xFFE64C3C).withOpacity(0.2),
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    order.amount,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                      height: 1.4,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Ketuk untuk melihat detail',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFFE64C3C),
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Phone and provider info
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _buildInfoRow(
                            'No. Handphone',
                            order.phoneNumber,
                            Icons.phone_android,
                          ),
                          if (order.provider.isNotEmpty) ...[
                            Divider(height: 16),
                            _buildInfoRow(
                              'Provider',
                              order.provider,
                              Icons.sim_card,
                            ),
                          ],
                          Divider(height: 16),
                          _buildInfoRow(
                            'Waktu',
                            DateFormat('HH:mm, dd MMM yyyy').format(order.date),
                            Icons.access_time,
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Delete button
                    GestureDetector(
                      onTap: () => _confirmDelete(order.id),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFE64C3C)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete_outline,
                              size: 16,
                              color: Color(0xFFE64C3C),
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Hapus Riwayat',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFFE64C3C),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
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
  
  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 14, color: Colors.grey[700]),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}