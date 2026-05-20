import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/staff_model.dart';
import '../services/staff_provider.dart';

class StaffPackageListScreen extends StatefulWidget {
  const StaffPackageListScreen({super.key});

  @override
  State<StaffPackageListScreen> createState() => _StaffPackageListScreenState();
}

class _StaffPackageListScreenState extends State<StaffPackageListScreen> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Daftar Paket Gudang',
            style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<StaffProvider>(
          builder: (context, provider, _) {
            final packages = provider.warehousePackages.where((item) {
              if (_filter == 'All') return true;
              return item.status == _filter;
            }).toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Filter Status',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2C3E50))),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: ['All', 'Menunggu', 'Overload', 'Selesai']
                      .map((status) => ChoiceChip(
                            label: Text(status),
                            selected: _filter == status,
                            selectedColor: const Color(0xFF5C3317),
                            backgroundColor: Colors.grey.shade200,
                            labelStyle: TextStyle(
                              color: _filter == status
                                  ? Colors.white
                                  : const Color(0xFF2C3E50),
                            ),
                            onSelected: (_) {
                              setState(() {
                                _filter = status;
                              });
                            },
                          ))
                      .toList(),
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: packages.isEmpty
                      ? const Center(
                          child: Text('Tidak ada paket untuk filter ini.'))
                      : ListView.separated(
                          itemCount: packages.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final paket = packages[index];
                            return _PackageTile(paket: paket);
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PackageTile extends StatelessWidget {
  final WarehousePackage paket;

  const _PackageTile({required this.paket});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.local_shipping_rounded, color: Color(0xFF5C3317)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(paket.resi,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, color: Color(0xFF2C3E50))),
                const SizedBox(height: 6),
                Text('${paket.berat} kg',
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: paket.status == 'Selesai'
                  ? Colors.green.shade50
                  : paket.status == 'Overload'
                      ? Colors.orange.shade50
                      : Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(paket.status,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: paket.status == 'Selesai'
                        ? Colors.green.shade700
                        : paket.status == 'Overload'
                            ? Colors.orange.shade700
                            : const Color(0xFF2C3E50))),
          ),
        ],
      ),
    );
  }
}
