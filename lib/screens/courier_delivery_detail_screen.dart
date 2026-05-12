import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/courier_delivery_model.dart';
import '../services/courier_provider.dart';

class CourierDeliveryDetailScreen extends StatelessWidget {
  final CourierDelivery order;

  const CourierDeliveryDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Detail Order',
            style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white,
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
                _buildActionButtons(context, provider, updated),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(CourierDelivery order) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFF5C3317).withOpacity(0.12),
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
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

    if (!order.isPicked) {
      actions.add(_buildButton(
        label: 'Ambil Paket',
        color: const Color(0xFF5C3317),
        onTap: () {
          provider.markPicked(order.id);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Status paket diupdate: Dalam pengiriman')));
        },
      ));
    }

    if (!order.isDelivered) {
      actions.add(_buildButton(
        label: 'Update Status: Sampai Lokasi',
        color: Colors.orange.shade700,
        onTap: () {
          provider.updateStatus(order.id, 'Sampai lokasi penerima');
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Status diperbarui')));
        },
      ));
    }

    actions.add(_buildButton(
      label: order.isDelivered ? 'Sudah Selesai' : 'Selesaikan Order',
      color: order.isDelivered ? Colors.grey : Colors.green.shade700,
      onTap: order.isDelivered
          ? null
          : () {
              provider.completeOrder(order.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Order diselesaikan')));
            },
    ));

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
      height: 52,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}
