import 'package:flutter/material.dart';
import 'confirm_kuota_page.dart';

class KuotaPage extends StatefulWidget {
  @override
  _KuotaPageState createState() => _KuotaPageState();
}

class _KuotaPageState extends State<KuotaPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  String? _selectedProvider;
  String? _selectedPackage;

  final List<String> _providers = ['Telkomsel', 'XL', 'Indosat', 'Tri', 'Smartfren'];
  
  Map<String, List<Map<String, String>>> _packages = {
    'Telkomsel': [
      {'name': 'Internet 2GB / 7 Hari', 'price': 'Rp 25.000'},
      {'name': 'Internet 5GB / 30 Hari', 'price': 'Rp 50.000'},
      {'name': 'Internet 10GB / 30 Hari', 'price': 'Rp 80.000'},
    ],
    'XL': [
      {'name': 'XTRA Combo 5GB / 30 Hari', 'price': 'Rp 53.000'},
      {'name': 'XTRA Combo 10GB / 30 Hari', 'price': 'Rp 83.000'},
      {'name': 'XTRA Combo 15GB / 30 Hari', 'price': 'Rp 113.000'},
    ],
    'Indosat': [
      {'name': 'Freedom Internet 2GB / 7 Hari', 'price': 'Rp 20.000'},
      {'name': 'Freedom Internet 7GB / 30 Hari', 'price': 'Rp 50.000'},
      {'name': 'Freedom Internet 15GB / 30 Hari', 'price': 'Rp 85.000'},
    ],
    'Tri': [
      {'name': 'AON 2GB / 30 Hari', 'price': 'Rp 30.000'},
      {'name': 'AON 5GB / 30 Hari', 'price': 'Rp 55.000'},
      {'name': 'AON 10GB / 30 Hari', 'price': 'Rp 85.000'},
    ],
    'Smartfren': [
      {'name': 'Data 3GB / 30 Hari', 'price': 'Rp 30.000'},
      {'name': 'Data 8GB / 30 Hari', 'price': 'Rp 65.000'},
      {'name': 'Data 15GB / 30 Hari', 'price': 'Rp 100.000'},
    ],
  };

  List<Map<String, String>> _availablePackages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Isi Kuota')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nomor HP', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: '08xxxxxxxxxx',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 10) {
                    return 'Masukkan nomor yang valid';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text('Provider', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedProvider,
                decoration: InputDecoration(border: OutlineInputBorder()),
                items: _providers.map((provider) {
                  return DropdownMenuItem<String>(value: provider, child: Text(provider));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedProvider = value;
                    _selectedPackage = null;
                    if (value != null) {
                      _availablePackages = _packages[value]!;
                    } else {
                      _availablePackages = [];
                    }
                  });
                },
                validator: (value) => value == null ? 'Pilih provider' : null,
              ),
              SizedBox(height: 20),
              Text('Paket Data', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedPackage,
                decoration: InputDecoration(border: OutlineInputBorder()),
                items: _availablePackages.map((package) {
                  return DropdownMenuItem<String>(
                    value: package['name'],
                    child: Text("${package['name']} - ${package['price']}"),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedPackage = value),
                validator: (value) => value == null && _selectedProvider != null 
                  ? 'Pilih paket data' 
                  : null,
                disabledHint: Text(_selectedProvider == null 
                  ? 'Pilih provider terlebih dahulu' 
                  : 'Tidak ada paket tersedia'),
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Find the selected package price
                      String selectedPrice = '';
                      if (_selectedProvider != null && _selectedPackage != null) {
                        selectedPrice = _packages[_selectedProvider]!
                          .firstWhere((p) => p['name'] == _selectedPackage)['price']!;
                      }
                      
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Konfirmasi'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Pembelian paket data:'),
                              SizedBox(height: 8),
                              Text('• Nomor: ${_phoneController.text}'),
                              Text('• Provider: $_selectedProvider'),
                              Text('• Paket: $_selectedPackage'),
                              Text('• Harga: $selectedPrice'),
                            ],
                          ),
                          actions: [
                            TextButton(
                              child: Text('Batal'), 
                              onPressed: () => Navigator.pop(context)
                            ),
                            ElevatedButton(
                              child: Text('Lanjutkan'),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ConfirmKuotaPage(
                                      nomorHp: _phoneController.text,
                                      provider: _selectedProvider!,
                                      paket: _selectedPackage!,
                                      harga: selectedPrice,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: Text('Lanjutkan'),
                  style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 48)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}