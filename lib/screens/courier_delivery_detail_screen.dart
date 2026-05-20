import 'package:flutter/material.dart';
import '../utils/shared_styles.dart';
import 'package:provider/provider.dart';
import '../models/courier_delivery_model.dart';
import '../services/courier_provider.dart';
import 'courier_scan_screen.dart';
import 'courier_delivery_confirmation_screen.dart';

class CourierDeliveryDetailScreen extends StatelessWidget {
  final CourierDelivery order;

  const CourierDeliveryDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          order.status.toLowerCase().contains('pickup')
              ? 'Pickup Aktif'
              : 'Detail Order',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF2C3E50),
        iconTheme: const IconThemeData(color: Color(0xFF2C3E50)),
        elevation: 0,
      ),
      body: Consumer<CourierProvider>(
        builder: (context, provider, _) {
          final updated = provider.getOrderById(order.id) ?? order;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(updated),
                const SizedBox(height: 18),
                _buildInfoCard(updated),
                const SizedBox(height: 18),
                _buildScanInstruction(updated),
                const SizedBox(height: 18),
                _buildProgressBar(updated),
                const SizedBox(height: 18),
                _buildActionButtons(context, provider, updated),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgressBar(CourierDelivery order) {
    final step = _progressStep(order);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildStepItem('Pickup', step >= 1),
            _buildStepLine(step >= 2),
            _buildStepItem('Scan', step >= 2),
            _buildStepLine(step >= 3),
            _buildStepItem('Selesai', step >= 3),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Status saat ini: ${order.status.isEmpty ? 'Menunggu Pickup' : order.status}',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  int _progressStep(CourierDelivery order) {
    final status = order.status.toLowerCase();
    if (status.contains('selesai')) return 3;
    if (status.contains('scan')) return 2;
    if (status.contains('pickup') || order.isPicked) return 1;
    return 0;
  }

  Widget _buildStepItem(String label, bool active) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: active ? const Color(0xFF5C3317) : Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: Icon(
              active ? Icons.check : Icons.circle,
              size: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 11,
                  color: active ? const Color(0xFF2C3E50) : Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildStepLine(bool active) {
    return Container(
      width: 30,
      height: 2,
      color: active ? const Color(0xFF5C3317) : Colors.grey.shade300,
    );
  }

  Widget _buildHeader(CourierDelivery order) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: AppStyles.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFF5C3317).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.local_shipping_rounded,
                    color: Color(0xFF5C3317)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.ekspedisi,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF5C3317))),
                    const SizedBox(height: 4),
                    Text(order.status,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(order.nomorResi,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2C3E50))),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.access_time_filled,
                  size: 16, color: Colors.grey),
              const SizedBox(width: 6),
              Text(order.estimasi,
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(CourierDelivery order) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: AppStyles.cardDecoration(),
      child: Column(
        children: [
          _infoRow('Pengirim', order.pengirim),
          const SizedBox(height: 12),
          _infoRow('Penerima', order.penerima),
          const SizedBox(height: 12),
          _infoRow('Alamat Ambil', order.alamatAmbil),
          const SizedBox(height: 12),
          _infoRow('Alamat Antar', order.alamatAntar),
        ],
      ),
    );
  }

  Widget _buildScanInstruction(CourierDelivery order) {
    final status = order.status.toLowerCase();
    if (!status.contains('pickup') && !status.contains('scan')) {
      return const SizedBox.shrink();
    }

    final scanned = status.contains('scan');
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: AppStyles.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF5C3317).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.qr_code_2_rounded,
                    color: Color(0xFF5C3317)),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('Scan Barcode / Nomor Resi',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2C3E50))),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Scan semua paket yang akan diambil dan pastikan jumlah paket sudah sesuai.',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 18),
          const Text('Paket yang harus discan',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2C3E50))),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: scanned
                        ? const Color(0xFF5C3317).withValues(alpha: 0.12)
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    scanned ? Icons.check_circle : Icons.inventory_2,
                    color: scanned ? const Color(0xFF5C3317) : Colors.grey,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order.nomorResi,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2C3E50))),
                      const SizedBox(height: 4),
                      Text(order.pengirim,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                Text(scanned ? 'Sudah discan' : 'Belum discan',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: scanned
                            ? const Color(0xFF2C3E50)
                            : Colors.orange.shade700)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: 96,
            child: Text(label,
                style: const TextStyle(fontSize: 12, color: Colors.grey))),
        Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50))))
      ],
    );
  }

  Widget _buildActionButtons(
      BuildContext context, CourierProvider provider, CourierDelivery order) {
    final actions = <Widget>[];
    final status = order.status.toLowerCase();

    if (order.isDelivered) {
      actions.add(_buildButton(
        label: 'Order Selesai',
        color: Colors.grey,
        onTap: null,
      ));
    } else if (!order.isPicked) {
      actions.add(_buildButton(
        label: 'Mulai Pickup',
        color: const Color(0xFF5C3317),
        onTap: () {
          provider.markPicked(order.id);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CourierScanScreen(order: order)),
          );
        },
      ));
    } else if (status.contains('pickup')) {
      actions.add(_buildButton(
        label: 'Scan Paket',
        color: const Color(0xFF5C3317),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CourierScanScreen(order: order)),
          );
        },
      ));
    } else if (status.contains('scan') || status.contains('dalam pengiriman')) {
      actions.add(_buildButton(
        label: 'Konfirmasi Pengiriman',
        color: Colors.orange.shade700,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    CourierDeliveryConfirmationScreen(order: order)),
          );
        },
      ));
    } else {
      actions.add(_buildButton(
        label: 'Selesaikan Order',
        color: Colors.green.shade700,
        onTap: () {
          provider.completeOrder(order.id);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Order diselesaikan')));
        },
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: actions
          .map((button) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: button,
              ))
          .toList(),
    );
  }

  Widget _buildButton(
      {required String label, required Color color, VoidCallback? onTap}) {
    return SizedBox(
      height: AppStyles.buttonHeight,
      child: ElevatedButton(
        onPressed: onTap,
        style: AppStyles.primaryButtonStyle()
            .copyWith(backgroundColor: WidgetStateProperty.all(color)),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}
