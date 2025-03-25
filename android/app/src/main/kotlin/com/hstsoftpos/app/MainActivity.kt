package com.hstsoftpos.app

import android.content.Intent
import android.graphics.Bitmap
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.util.Log
import androidx.annotation.RequiresApi
import com.urovo.sdk.print.PrinterProviderImpl
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.Executors

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.hstsoftpos.app/channel"
    private var initialDeepLink: String? = null
    private lateinit var printerProvider: PrinterProviderImpl

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleDeepLink(intent)

        if (isUrovoDevice()) {
            try {
                printerProvider = PrinterProviderImpl.getInstance(this)
                printerProvider.initPrint()
            } catch (e: Exception) {
                Log.e("MainActivity", "Failed to initialize printer: ${e.message}")
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        handleDeepLink(intent)
    }

    private fun handleDeepLink(intent: Intent?) {
        intent?.data?.let { uri ->
            Log.d("DeepLink", "Intent Data: $uri")
            initialDeepLink = uri.toString() // Save the deep link
            // Send the deep link to Flutter side if the Flutter engine is ready
            flutterEngine?.dartExecutor?.binaryMessenger?.let {
                MethodChannel(it, CHANNEL)
                    .invokeMethod("onDeepLinkReceived", uri.toString())
            }
        }
    }

    private fun isUrovoDevice(): Boolean {
        val manufacturer = Build.MANUFACTURER.toLowerCase()
        val model = Build.MODEL.toLowerCase()

        val isUrovo = manufacturer.contains("i9100") || model.contains("i9100")
        Log.d("DeviceCheck", if (isUrovo) {
            "This device is a Urovo device."
        } else {
            "This device is not a Urovo device."
        })
        return isUrovo
    }

    private fun openAppSettings() {
        val intent = Intent(
            Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
            Uri.parse("package:$packageName")
        )
        startActivity(intent)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getInitialDeepLink" -> {
                    result.success(initialDeepLink)
                }
                "openAppSettings" -> {
                    openAppSettings()
                    result.success(null)
                }
                "printSlip" -> {
                    if (isUrovoDevice()) {
                        val paymentJson = call.arguments as? Map<String, Any>
                        if (paymentJson == null) {
                            result.error("INVALID_ARGUMENT", "Payment data is null", null)
                            return@setMethodCallHandler
                        }
                        // Run heavy operations on background thread
                        Executors.newSingleThreadExecutor().execute {
                            try {
                                val receiptPrinter = ReceiptPrinter(context = this@MainActivity)
                                val receiptBitmap = receiptPrinter.createReceipt(paymentJson)
                                if (receiptBitmap != null) {
                                    printerProvider.addBitmap(receiptBitmap, 0)
                                    val printResult = printerProvider.startPrint()
                                    // Send result back on main thread
                                    runOnUiThread {
                                        result.success(printResult)
                                    }
                                } else {
                                    runOnUiThread {
                                        result.error("PRINT_ERROR", "Failed to generate receipt", null)
                                    }
                                }
                            } catch (e: Exception) {
                                e.printStackTrace()
                                runOnUiThread {
                                    result.error("PRINT_ERROR", e.message, null)
                                }
                            }
                        }
                    } else {
                        result.error("PRINT_ERROR", "This device is not a Urovo device.", null)
                    }
                }
                "printEndOfDaySlip" -> {
                    if (isUrovoDevice()) {
                        val transactionListJson = call.arguments as? List<Map<String, Any>>
                        if (transactionListJson == null) {
                            result.error("INVALID_ARGUMENT", "Payment data is null", null)
                            return@setMethodCallHandler
                        }
                        Executors.newSingleThreadExecutor().execute {
                            try {
                                val endOfDayPrinter = EndOfDayPrinter(context = this@MainActivity)

                            } catch (e: Exception) {
                                e.printStackTrace()
                                runOnUiThread {
                                    result.error("PRINT_ERROR", e.message, null)
                                }
                            }
                        }
                    } else {
                        result.error("PRINT_ERROR", "This device is not a Urovo device.", null)
                    }
                }
                "getPrinterStatus" -> {
                    if (isUrovoDevice()) {
                        // Run on background thread if the status retrieval is heavy
                        Executors.newSingleThreadExecutor().execute {
                            try {
                                val printerStatus = printerProvider.status
                                runOnUiThread {
                                    result.success(printerStatus)
                                }
                            } catch (e: Exception) {
                                e.printStackTrace()
                                runOnUiThread {
                                    result.error("PRINTER_ERROR", e.message, null)
                                }
                            }
                        }
                    } else {
                        result.error("PRINTER_ERROR", "This device is not a Urovo device.", null)
                    }
                }
                "isUrovoDevice" -> {
                    result.success(isUrovoDevice())
                }
                else -> result.notImplemented()
            }
        }
    }
}