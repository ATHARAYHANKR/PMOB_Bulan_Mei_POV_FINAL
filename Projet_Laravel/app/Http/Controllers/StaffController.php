<?php

namespace App\Http\Controllers;

use App\Models\StaffShipment;
use App\Models\InventoryItem;
use Illuminate\Http\Request;

class StaffController extends Controller
{
    public function dashboard(Request $request)
    {
        $user = $request->user();

        $incoming = StaffShipment::where('staff_id', $user->id)
            ->where('status', 'incoming')
            ->count();

        $inventory = InventoryItem::sum('stok');
        $lowStock = InventoryItem::whereColumn('stok', '<=', 'stok_minimum')->count();

        return response()->json([
            'incoming_count' => $incoming,
            'inventory_count' => $inventory,
            'low_stock_count' => $lowStock,
        ]);
    }

    public function incomingShipments(Request $request)
    {
        $user = $request->user();
        $shipments = StaffShipment::where('staff_id', $user->id)
            ->orderBy('tanggal_masuk', 'desc')
            ->get();

        return response()->json($shipments);
    }

    public function receiveShipment(Request $request, $id)
    {
        $user = $request->user();
        $shipment = StaffShipment::where('staff_id', $user->id)->findOrFail($id);

        $shipment->update(['status' => 'received']);

        return response()->json($shipment);
    }

    public function markReadyToPack(Request $request, $id)
    {
        $user = $request->user();
        $shipment = StaffShipment::where('staff_id', $user->id)->findOrFail($id);

        $shipment->update([
            'status' => 'ready_to_pack',
            'tanggal_proses' => now(),
        ]);

        return response()->json($shipment);
    }

    public function inventory(Request $request)
    {
        $items = InventoryItem::all();
        return response()->json($items);
    }

    public function toggleAvailability(Request $request)
    {
        $user = $request->user();
        // For demo, just return success
        return response()->json(['message' => 'Availability updated']);
    }
}