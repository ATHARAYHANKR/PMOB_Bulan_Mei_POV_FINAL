<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\TrackingController;
use App\Http\Controllers\CourierController;
use App\Http\Controllers\StaffController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

// Auth routes
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// Protected routes
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/user', [AuthController::class, 'user']);
    Route::post('/logout', [AuthController::class, 'logout']);

    // Tracking routes
    Route::post('/track', [TrackingController::class, 'track']);
    Route::get('/history', [TrackingController::class, 'history']);

    // Courier routes
    Route::prefix('courier')->group(function () {
        Route::get('/orders', [CourierController::class, 'orders']);
        Route::get('/history', [CourierController::class, 'history']);
        Route::put('/orders/{id}/status', [CourierController::class, 'updateStatus']);
        Route::post('/toggle-online', [CourierController::class, 'toggleOnline']);
    });

    // Staff routes
    Route::prefix('staff')->group(function () {
        Route::get('/dashboard', [StaffController::class, 'dashboard']);
        Route::get('/incoming', [StaffController::class, 'incomingShipments']);
        Route::put('/shipments/{id}/receive', [StaffController::class, 'receiveShipment']);
        Route::put('/shipments/{id}/ready', [StaffController::class, 'markReadyToPack']);
        Route::get('/inventory', [StaffController::class, 'inventory']);
        Route::post('/toggle-availability', [StaffController::class, 'toggleAvailability']);
    });
});
