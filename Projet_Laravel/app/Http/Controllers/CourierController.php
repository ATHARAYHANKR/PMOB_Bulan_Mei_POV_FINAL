<?php

namespace App\Http\Controllers;

use App\Models\CourierDelivery;
use Illuminate\Http\Request;

class CourierController extends Controller
{
    public function orders(Request $request)
    {
        $user = $request->user();
        $orders = CourierDelivery::where('courier_id', $user->id)
            ->where('status', '!=', 'completed')
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json($orders);
    }

    public function history(Request $request)
    {
        $user = $request->user();
        $history = CourierDelivery::where('courier_id', $user->id)
            ->where('status', 'completed')
            ->orderBy('updated_at', 'desc')
            ->get();

        return response()->json($history);
    }

    public function updateStatus(Request $request, $id)
    {
        $request->validate([
            'status' => 'required|in:accepted,in_transit,delivered',
        ]);

        $user = $request->user();
        $order = CourierDelivery::where('courier_id', $user->id)->findOrFail($id);

        $order->update([
            'status' => $request->status,
            'tanggal_antar' => $request->status === 'delivered' ? now() : null,
        ]);

        return response()->json($order);
    }

    public function toggleOnline(Request $request)
    {
        $user = $request->user();
        // For demo, just return success
        return response()->json(['message' => 'Status updated']);
    }
}