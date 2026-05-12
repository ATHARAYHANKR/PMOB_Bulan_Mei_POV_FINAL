import 'package:flutter/material.dart';

class BeriRatingScreen extends StatefulWidget {
  final String nomorResi;
  const BeriRatingScreen({super.key, required this.nomorResi});

  @override
  State<BeriRatingScreen> createState() => _BeriRatingScreenState();
}

class _BeriRatingScreenState extends State<BeriRatingScreen> {
  int _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();
  bool _isLoading = false;
  bool _terkirim = false;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _kirimRating() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Pilih rating terlebih dahulu'),
            duration: Duration(seconds: 2)),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      _isLoading = false;
      _terkirim = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: Color(0xFF2C3E50), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Beri Rating',
            style: TextStyle(
                color: Color(0xFF2C3E50),
                fontWeight: FontWeight.w700,
                fontSize: 17)),
        centerTitle: true,
      ),
      body: _terkirim ? _buildSukses() : _buildForm(),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 16),

          // Pertanyaan
          const Text(
            'Bagaimana pengalaman Anda\ndalam menggunakan Trackly?',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2C3E50),
                height: 1.4),
          ),

          const SizedBox(height: 32),

          // Bintang rating
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              return GestureDetector(
                onTap: () => setState(() => _rating = i + 1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(
                    i < _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: i < _rating
                        ? const Color(0xFFFFC107)
                        : Colors.grey.shade300,
                    size: 44,
                  ),
                ),
              );
            }),
          ),

          if (_rating > 0) ...[
            const SizedBox(height: 12),
            Text(
              _labelRating(_rating),
              style: const TextStyle(
                  color: Color(0xFF5C3317),
                  fontWeight: FontWeight.w600,
                  fontSize: 14),
            ),
          ],

          const SizedBox(height: 28),

          // Feedback opsional
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Tulis Feedback (Opsional)',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700)),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: _feedbackController,
              maxLines: 4,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: 'Cerita pengalaman, pengiriman cepat, paket datang kondisi baik...',
                hintStyle: TextStyle(
                    color: Colors.grey.shade400, fontSize: 13),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(14),
              ),
            ),
          ),

          const SizedBox(height: 28),

          // Tombol kirim
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _kirimRating,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5C3317),
                disabledBackgroundColor: Colors.grey.shade300,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2))
                  : const Text('Kirim',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSukses() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF5C3317).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded,
                  color: Color(0xFF5C3317), size: 50),
            ),
            const SizedBox(height: 20),
            const Text('Rating Terkirim!',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2C3E50))),
            const SizedBox(height: 10),
            Text('Terima kasih atas masukan Anda.\nKami akan terus meningkatkan layanan.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.5)),
          ],
        ),
      ),
    );
  }

  String _labelRating(int r) {
    switch (r) {
      case 1: return 'Sangat Buruk 😞';
      case 2: return 'Buruk 😕';
      case 3: return 'Cukup 😐';
      case 4: return 'Baik 😊';
      case 5: return 'Sangat Baik 🌟';
      default: return '';
    }
  }
}
