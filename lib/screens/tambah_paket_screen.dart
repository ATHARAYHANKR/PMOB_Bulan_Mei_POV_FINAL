import 'package:flutter/material.dart';
import '../utils/shared_styles.dart';
import '../services/binderbyte_service.dart';

// ✅ Form + TextFormField + GlobalKey<FormState> (Requirement ETS)
class TambahPaketScreen extends StatefulWidget {
  const TambahPaketScreen({super.key});

  @override
  State<TambahPaketScreen> createState() => _TambahPaketScreenState();
}

class _TambahPaketScreenState extends State<TambahPaketScreen> {
  // ✅ GlobalKey<FormState> (Requirement ETS)
  final _formKey = GlobalKey<FormState>();
  final _resiController = TextEditingController();
  final _namaPengirimController = TextEditingController();
  final _namaPenerimaController = TextEditingController();
  final _catatanController = TextEditingController();

  String _selectedEkspedisi = 'jne';
  bool _isLoading = false;
  bool _isSimpan = false;

  @override
  void dispose() {
    _resiController.dispose();
    _namaPengirimController.dispose();
    _namaPenerimaController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // ✅ Validasi dengan GlobalKey
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _isSimpan = true;
        });

        // ✅ SnackBar setelah aksi berhasil (Requirement ETS)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Paket ${_resiController.text} berhasil ditambahkan!',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 3),
          ),
        );

        // Kembali ke halaman sebelumnya setelah 1.5 detik
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) Navigator.pop(context, _resiController.text);
        });
      });
    }
  }

  void _resetForm() {
    setState(() {
      _isSimpan = false;
      _resiController.clear();
      _namaPengirimController.clear();
      _namaPenerimaController.clear();
      _catatanController.clear();
      _selectedEkspedisi = 'jne';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Tambah Paket',
            style: TextStyle(fontWeight: FontWeight.w700)),
        actions: [
          if (_isSimpan)
            TextButton.icon(
              onPressed: _resetForm,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Baru', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3A5F), Color(0xFF00B4D8)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.add_box_rounded,
                        color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tambah Paket Baru',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16)),
                        Text('Isi data paket yang ingin dilacak',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ✅ Form dengan GlobalKey<FormState>
            Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ TextFormField 1: Nomor Resi dengan 2 validasi
                    _buildLabel('Nomor Resi *'),
                    TextFormField(
                      controller: _resiController,
                      enabled: !_isSimpan,
                      textCapitalization: TextCapitalization.characters,
                      decoration: _inputDecoration(
                        hint: 'Contoh: JNE001234567',
                        icon: Icons.inventory_2_outlined,
                      ),
                      // ✅ Validasi 1: tidak boleh kosong
                      // ✅ Validasi 2: minimal 8 karakter
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Nomor resi tidak boleh kosong';
                        }
                        if (val.length < 8) {
                          return 'Nomor resi minimal 8 karakter';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Pilih Ekspedisi
                    _buildLabel('Ekspedisi *'),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedEkspedisi,
                      decoration: _inputDecoration(
                          hint: 'Pilih ekspedisi', icon: Icons.local_shipping),
                      items: BinderbyteService.daftarEkspedisi
                          .map((e) => DropdownMenuItem(
                                value: e['code'],
                                child: Text(e['name']!),
                              ))
                          .toList(),
                      onChanged: _isSimpan
                          ? null
                          : (val) => setState(() => _selectedEkspedisi = val!),
                      validator: (val) =>
                          val == null ? 'Pilih ekspedisi' : null,
                    ),

                    const SizedBox(height: 16),

                    // ✅ TextFormField 2: Nama Pengirim
                    _buildLabel('Nama Pengirim *'),
                    TextFormField(
                      controller: _namaPengirimController,
                      enabled: !_isSimpan,
                      decoration: _inputDecoration(
                          hint: 'Nama pengirim paket',
                          icon: Icons.person_outline),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Nama pengirim tidak boleh kosong';
                        }
                        if (val.length < 3) {
                          return 'Nama pengirim minimal 3 karakter';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // ✅ TextFormField 3: Nama Penerima
                    _buildLabel('Nama Penerima *'),
                    TextFormField(
                      controller: _namaPenerimaController,
                      enabled: !_isSimpan,
                      decoration: _inputDecoration(
                          hint: 'Nama penerima paket',
                          icon: Icons.person_pin_outlined),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Nama penerima tidak boleh kosong';
                        }
                        if (val.length < 3) {
                          return 'Nama penerima minimal 3 karakter';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // TextFormField 4: Catatan (opsional)
                    _buildLabel('Catatan (Opsional)'),
                    TextFormField(
                      controller: _catatanController,
                      enabled: !_isSimpan,
                      maxLines: 3,
                      decoration: _inputDecoration(
                          hint: 'Tambahkan catatan pengiriman...',
                          icon: Icons.notes_rounded),
                    ),

                    const SizedBox(height: 24),

                    // Tombol Submit
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed:
                            (_isLoading || _isSimpan) ? null : _submitForm,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white))
                            : Icon(_isSimpan
                                ? Icons.check_circle_rounded
                                : Icons.save_rounded),
                        label: Text(
                          _isLoading
                              ? 'Menyimpan...'
                              : _isSimpan
                                  ? 'Tersimpan!'
                                  : 'Simpan Paket',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15),
                        ),
                        style: AppStyles.primaryButtonStyle().copyWith(
                          backgroundColor: WidgetStateProperty.all(_isSimpan
                              ? Colors.green
                              : const Color(0xFF1E3A5F)),
                          foregroundColor:
                              WidgetStateProperty.all(Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Info validasi
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF00B4D8).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: const Color(0xFF00B4D8).withValues(alpha: 0.3)),
              ),
              child: const Column(
                children: [
                  Row(children: [
                    Icon(Icons.info_outline_rounded,
                        size: 16, color: Color(0xFF00B4D8)),
                    SizedBox(width: 8),
                    Text('Aturan Validasi Form',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E3A5F),
                            fontSize: 13)),
                  ]),
                  SizedBox(height: 8),
                  _ValidationInfo(text: 'Nomor resi tidak boleh kosong'),
                  _ValidationInfo(text: 'Nomor resi minimal 8 karakter'),
                  _ValidationInfo(text: 'Nama pengirim & penerima wajib diisi'),
                  _ValidationInfo(text: 'Nama minimal 3 karakter'),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text,
          style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E3A5F),
              fontSize: 13)),
    );
  }

  InputDecoration _inputDecoration(
      {required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
      prefixIcon: Icon(icon, color: const Color(0xFF1E3A5F), size: 20),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1E3A5F), width: 2)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red)),
      filled: true,
      fillColor: const Color(0xFFF5F7FA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}

class _ValidationInfo extends StatelessWidget {
  final String text;
  const _ValidationInfo({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline,
              size: 14, color: Color(0xFF00B4D8)),
          const SizedBox(width: 6),
          Text(text,
              style: const TextStyle(color: Color(0xFF555555), fontSize: 12)),
        ],
      ),
    );
  }
}
