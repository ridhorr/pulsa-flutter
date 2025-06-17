import 'package:flutter/material.dart';
import 'confirm_pesanan_page.dart';

class AirPage extends StatefulWidget {
  @override
  _AirPageState createState() => _AirPageState();
}

class _AirPageState extends State<AirPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  
  // Daftar barang dengan harga
  final List<Map<String, dynamic>> _products = [
    {
      'id': 1,
      'name': 'Air Isi Ulang Grand',
      'price': 5000,
      'image': Icons.water_drop,
      'quantity': 0,
      'unit': 'Galon'
    },
    {
      'id': 2,
      'name': 'Air Isi Ulang Aqua',
      'price': 7000,
      'image': Icons.water_drop,
      'quantity': 0,
      'unit': 'Galon'
    },
    {
      'id': 3,
      'name': 'Air Grand Original',
      'price': 18000,
      'image': Icons.water,
      'quantity': 0,
      'unit': 'Galon'
    },
    {
      'id': 4,
      'name': 'Air Aqua Original',
      'price': 22000,
      'image': Icons.water,
      'quantity': 0,
      'unit': 'Galon'
    },
    {
      'id': 5,
      'name': 'Gas LPG 3kg',
      'price': 25000,
      'image': Icons.propane_tank,
      'quantity': 0,
      'unit': 'Tabung'
    },
    {
      'id': 6,
      'name': 'Gas LPG 12kg',
      'price': 185000,
      'image': Icons.propane_tank,
      'quantity': 0,
      'unit': 'Tabung'
    },
  ];

  int get _totalItems => _products.fold(0, (sum, product) => sum + product['quantity'] as int);
  
  double get _totalPrice => _products.fold(0, (sum, product) => 
    sum + (product['price'] as int) * (product['quantity'] as int));

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesanan Siap Antar'),
        backgroundColor: Color(0xFFE64C3C),
        elevation: 0,
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
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
                          Icon(Icons.delivery_dining, size: 40, color: Color(0xFFE64C3C)),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pesanan Siap Antar',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Pilih barang dan kami antar ke lokasi Anda',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 25),
                    
                    // Product List
                    Text(
                      'Pilih Produk',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    
                    // Product Items
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        final product = _products[index];
                        return _buildProductItem(product);
                      },
                    ),
                    
                    SizedBox(height: 25),
                    
                    // Customer Information Form
                    if (_totalItems > 0) ...[
                      Text(
                        'Informasi Pengiriman',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15),
                      
                      // Name Field
                      _buildTextField(
                        controller: _nameController,
                        label: 'Nama Lengkap',
                        icon: Icons.person,
                      ),
                      SizedBox(height: 15),
                      
                      // Phone Field
                      _buildTextField(
                        controller: _phoneController,
                        label: 'Nomor Telepon',
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: 15),
                      
                      // Address Field
                      _buildTextField(
                        controller: _addressController,
                        label: 'Alamat Pengiriman',
                        icon: Icons.location_on,
                        maxLines: 3,
                      ),
                      
                      SizedBox(height: 25),
                    ],
                  ],
                ),
              ),
            ),
            
            // Bottom Order Summary
            if (_totalItems > 0)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$_totalItems Item',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Rp ${_totalPrice.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE64C3C),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _processOrder,
                        child: Text(
                          'PESAN SEKARANG',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFE64C3C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _processOrder() {
    // Validate form fields if items selected
    if (_totalItems > 0) {
      if (_nameController.text.isEmpty ||
          _phoneController.text.isEmpty ||
          _addressController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Harap isi semua data pengiriman'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      // Filter selected products
      final selectedProducts = _products.where((product) => product['quantity'] > 0).toList();
      
      // Navigate to confirmation page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmPesananPage(
            nama: _nameController.text,
            nomorTelepon: _phoneController.text,
            alamat: _addressController.text,
            items: selectedProducts,
            totalHarga: _totalPrice,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Silakan pilih produk terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildProductItem(Map<String, dynamic> product) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product Icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Color(0xFFE7B8B8).withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              product['image'] as IconData,
              size: 30,
              color: Color(0xFFE64C3C),
            ),
          ),
          SizedBox(width: 15),
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'] as String,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Rp ${product['price']}/${product['unit']}',
                  style: TextStyle(
                    color: Color(0xFFE64C3C),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Quantity Control
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  padding: EdgeInsets.all(4),
                  constraints: BoxConstraints(),
                  icon: Icon(Icons.remove, size: 18),
                  onPressed: product['quantity'] > 0
                      ? () {
                          setState(() {
                            product['quantity'] = product['quantity'] - 1;
                          });
                        }
                      : null,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '${product['quantity']}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.all(4),
                  constraints: BoxConstraints(),
                  icon: Icon(Icons.add, size: 18),
                  onPressed: () {
                    setState(() {
                      product['quantity'] = product['quantity'] + 1;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        ),
      ),
    );
  }
}