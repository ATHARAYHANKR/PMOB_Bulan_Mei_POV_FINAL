import 'package:flutter/material.dart';
import '../utils/shared_styles.dart';
import 'package:provider/provider.dart';
import '../models/courier_delivery_model.dart';
import '../services/courier_provider.dart';
import 'courier_delivery_confirmation_screen.dart';

class CourierScanScreen extends StatefulWidget {
  final CourierDelivery order;

  const CourierScanScreen({super.key, required this.order});

  @override
  State<CourierScanScreen> createState() => _CourierScanScreenState();
}

class _CourierScanScreenState extends State<CourierScanScreen> {
  final TextEditingController _resiController = TextEditingController();
  bool _isScanning = false;
  bool _scanSuccess = false;
  bool _manualInput = false;

  @override
  void initState() {
    super.initState();
    _resiController.text = widget.order.nomorResi;
  }

  @override
  void dispose() {
    _resiController.dispose();
    super.dispose();
  }

  Future<void> _startScan() async {
    setState(() {
      _isScanning = true;
      _manualInput = false;
    });
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      _isScanning = false;
      _scanSuccess = true;
      _resiController.text = widget.order.nomorResi;
    });
  }

  Future<void> _saveScan() async {
    final provider = context.read<CourierProvider>();
    await provider.markScanComplete(widget.order.id);
    final updatedOrder = provider.getOrderById(widget.order.id) ?? widget.order;
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => CourierDeliveryConfirmationScreen(order: updatedOrder),
      ),
    );
  }

  void _showManualInput() {
    setState(() {
      _manualInput = true;
      _scanSuccess = false;
    });
  }

  void _resetScan() {
    setState(() {
      _scanSuccess = false;
      _manualInput = false;
      _isScanning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Scan Paket',
            style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: const Color(0xFF5C3317),
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _scanSuccess
                        ? 'Hasil Deteksi Sistem'
                        : 'Arahkan kamera ke resi',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2C3E50)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 320,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        )
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _scanSuccess
                                  ? const Color(0xFF5C3317)
                                  : Colors.grey.shade300,
                              width: 2,
                            ),
                            color: Colors.grey.shade100,
                          ),
                        ),
                        if (_scanSuccess)
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_circle_rounded,
                                  size: 72, color: Color(0xFF5C3317)),
                              const SizedBox(height: 12),
                              Text(_resiController.text,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF2C3E50))),
                              const SizedBox(height: 8),
                              Text(widget.order.ekspedisi,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600)),
                            ],
                          )
                        else if (_isScanning)
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                height: 44,
                                width: 44,
                                child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFF5C3317))),
                              ),
                              const SizedBox(height: 12),
                              Text('Sistem sedang mendeteksi paket...',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w600)),
                            ],
                          )
                        else
                          const Icon(Icons.qr_code_scanner_rounded,
                              size: 88, color: Color(0xFF5C3317)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (!_scanSuccess) ...[
              if (_manualInput)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('Input Manual',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2C3E50))),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _resiController,
                        decoration: InputDecoration(
                          hintText: 'Masukkan nomor resi paket',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() => _manualInput = false);
                              },
                              style: AppStyles.outlinedButtonStyle(),
                              child: const Text('Batal',
                                  style: TextStyle(
                                      color: Color(0xFF5C3317),
                                      fontWeight: FontWeight.w700)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (_resiController.text.isNotEmpty) {
                                  setState(() {
                                    _scanSuccess = true;
                                  });
                                }
                              },
                              style: AppStyles.primaryButtonStyle().copyWith(
                                  backgroundColor: WidgetStateProperty.all(
                                      const Color(0xFF5C3317))),
                              child: const Text('Simpan',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w700)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              if (!_manualInput) const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _isScanning ? null : _startScan,
                style: AppStyles.primaryButtonStyle().copyWith(
                    backgroundColor:
                        WidgetStateProperty.all(const Color(0xFF5C3317))),
                child: _isScanning
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white)),
                      )
                    : const Text('Scan Sekarang',
                        style: TextStyle(fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _showManualInput,
                child: const Text('Input Manual',
                    style: TextStyle(
                        color: Color(0xFF5C3317), fontWeight: FontWeight.w700)),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Hasil Deteksi Sistem',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16)),
                    const SizedBox(height: 12),
                    _infoRow('Resi Paket', _resiController.text),
                    const SizedBox(height: 8),
                    _infoRow('Tujuan Paket', widget.order.alamatAntar),
                    const SizedBox(height: 8),
                    _infoRow('Rute', widget.order.alamatAmbil),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _resetScan,
                      style: AppStyles.outlinedButtonStyle(),
                      child: const Text('Ulangi',
                          style: TextStyle(
                              color: Color(0xFF5C3317),
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveScan,
                      style: AppStyles.primaryButtonStyle().copyWith(
                          backgroundColor:
                              WidgetStateProperty.all(const Color(0xFF5C3317))),
                      child: const Text('Simpan',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            flex: 2,
            child: Text('$label',
                style: const TextStyle(fontSize: 12, color: Colors.grey))),
        const SizedBox(width: 10),
        Expanded(
            flex: 3,
            child: Text(value,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50)))),
      ],
    );
  }
}
