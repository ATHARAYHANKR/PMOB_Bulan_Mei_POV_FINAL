<?php

namespace App\Http\Controllers;

use App\Models\RiwayatPengiriman;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

class TrackingController extends Controller
{
    public function track(Request $request)
    {
        $request->validate([
            'resi' => 'required|string',
            'ekspedisi' => 'required|string',
        ]);

        // Call BinderByte API (you need to set API_KEY in .env)
        $apiKey = env('BINDERBYTE_API_KEY', 'your-api-key');
        $response = Http::get("https://api.binderbyte.com/v1/track", [
            'api_key' => $apiKey,
            'courier' => $request->ekspedisi,
            'awb' => $request->resi,
        ]);

        if ($response->successful()) {
            $data = $response->json();

            // Save to history
            RiwayatPengiriman::create([
                'nomor_resi' => $request->resi,
                'ekspedisi' => $request->ekspedisi,
                'pengirim' => $data['data']['summary']['shipper'] ?? '-',
                'penerima' => $data['data']['summary']['receiver'] ?? '-',
                'alamat_penerima' => $data['data']['summary']['receiver_address'] ?? '-',
                'status_terakhir' => $data['data']['summary']['status'] ?? 'Unknown',
                'detail_tracking' => $data['data']['detail'] ?? [],
                'tanggal_cek' => now(),
            ]);

            return response()->json($data);
        }

        return response()->json(['error' => 'Tracking failed'], 400);
    }

    public function history(Request $request)
    {
        $user = $request->user();
        $history = RiwayatPengiriman::where('user_id', $user->id)
            ->orderBy('tanggal_cek', 'desc')
            ->get();

        return response()->json($history);
    }
}