import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/tracking_provider.dart';
import '../services/binderbyte_service.dart';
import '../utils/snackbar_helper.dart';
import 'detail_tracking_screen.dart';

class TrackingScreen extends StatefulWidget {
  final String? resiAwal;
  const TrackingScreen({super.key, this.resiAwal});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  late TextEditingController _resiController;

  @override
  void initState() {
    super.initState();
    _resiController = TextEditingController(text: widget.resiAwal ?? '');
    if (widget.resiAwal != null && widget.resiAwal!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _lacak());
    }
  }

  @override
  void dispose() {
    _resiController.dispose();
    super.dispose();
  }

  void _lacak() {
    final resi = _resiController.text.trim();
    if (resi.isEmpty) {
      SnackbarHelper.showValidationError(
        context,
        'Nomor Resi',
        'Masukkan nomor resi pengiriman Anda',
      );
      return;
    }

    if (resi.length < 8) {
      SnackbarHelper.showValidationError(
        context,
        'Format Resi',
        'Nomor resi minimal terdiri dari 8 karakter',
      );
      return;
    }

    SnackbarHelper.showLoading(context, 'Melacak paket Anda...');

    context.read<TrackingProvider>().trackPaket(resi).then((_) {
      final provider = context.read<TrackingProvider>();
      if (provider.state == TrackingState.success) {
        // Close loading snackbar
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        SnackbarHelper.showSuccess(
          context,
          '✓ Paket ditemukan! Menampilkan detail...',
          duration: const Duration(seconds: 2),
        );

        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailTrackingScreen(result: provider.result!),
              ),
            );
          }
        });
      } else if (provider.state == TrackingState.error) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        SnackbarHelper.showError(
          context,
          provider.errorMessage.isEmpty
              ? 'Paket tidak ditemukan. Periksa nomor resi Anda.'
              : provider.errorMessage,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Lacak Paket',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Consumer<TrackingProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Input Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nomor Resi',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF5C3317),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _resiController,
                        decoration: InputDecoration(
                          hintText: 'Contoh: JNE12345678901',
                          prefixIcon: const Icon(Icons.inventory_2_outlined),
                          suffixIcon: _resiController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _resiController.clear();
                                    provider.reset();
                                    setState(() {});
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Color(0xFFE0E0E0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Color(0xFF5C3317)),
                          ),
                        ),
                        onChanged: (_) => setState(() {}),
                        textInputAction: TextInputAction.search,
                        onSubmitted: (_) => _lacak(),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Pilih Ekspedisi',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF5C3317),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _EkspedisiSelector(
                        selected: provider.selectedEkspedisi,
                        onChanged: provider.setEkspedisi,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: provider.state == TrackingState.loading
                              ? null
                              : _lacak,
                          icon: provider.state == TrackingState.loading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.search_rounded),
                          label: Text(
                            provider.state == TrackingState.loading
                                ? 'Melacak...'
                                : 'Lacak Sekarang',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5C3317),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Error State
                if (provider.state == TrackingState.error) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red.shade400),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            provider.errorMessage,
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 24),
                const Text(
                  '💡 Tips Tracking',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF5C3317),
                  ),
                ),
                const SizedBox(height: 8),
                _TipsCard(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _EkspedisiSelector extends StatelessWidget {
  final String selected;
  final Function(String) onChanged;

  const _EkspedisiSelector({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: BinderbyteService.daftarEkspedisi.map((e) {
        final isSelected = selected == e['code'];
        return GestureDetector(
          onTap: () => onChanged(e['code']!),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [
                        Color(0xFF5C3317),
                        Color(0xFFA0673A),
                      ],
                    )
                  : const LinearGradient(
                      colors: [
                        Colors.white,
                        Color(0xFFF5F7FA),
                      ],
                    ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF5C3317)
                    : const Color(0xFFE0E0E0),
                width: isSelected ? 2 : 1.5,
              ),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: const Color(0xFF5C3317).withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                else
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected)
                  const Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                Text(
                  e['name']!,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF555555),
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    fontSize: 13,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _TipsCard extends StatelessWidget {
  final List<String> tips = const [
    'Pastikan nomor resi sesuai dengan ekspedisi yang dipilih',
    'Update status biasanya membutuhkan waktu 1-2 jam',
    'Resi akan otomatis tersimpan di riwayat setelah dilacak',
    'Notifikasi akan dikirim saat ada perubahan status paket',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFA0673A).withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFA0673A).withOpacity(0.3)),
      ),
      child: Column(
        children: tips
            .map(
              (tip) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle_outline,
                        size: 16, color: Color(0xFFA0673A)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        tip,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF555555),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
