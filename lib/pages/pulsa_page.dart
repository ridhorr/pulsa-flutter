import 'package:flutter/material.dart';
import 'confirm_pulsa_page.dart';

class PulsaPage extends StatefulWidget {
  @override
  _PulsaPageState createState() => _PulsaPageState();
}

class _PulsaPageState extends State<PulsaPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  String? _selectedNominal;

  final List<String> _nominals = [
    'Rp 5.000',
    'Rp 10.000',
    'Rp 20.000',
    'Rp 50.000',
    'Rp 100.000',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Isi Pulsa')),
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
              Text('Nominal Pulsa', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedNominal,
                decoration: InputDecoration(border: OutlineInputBorder()),
                items: _nominals.map((nominal) {
                  return DropdownMenuItem(value: nominal, child: Text(nominal));
                }).toList(),
                onChanged: (value) => setState(() => _selectedNominal = value),
                validator: (value) => value == null ? 'Pilih nominal pulsa' : null,
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Konfirmasi'),
                          content: Text('Kirim pulsa $_selectedNominal ke ${_phoneController.text}?'),
                          actions: [
                            TextButton(child: Text('Batal'), onPressed: () => Navigator.pop(context)),
                            ElevatedButton(
                              child: Text('Lanjutkan'),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ConfirmPulsaPage(
                                      nomorHp: _phoneController.text,
                                      nominal: _selectedNominal!,
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
