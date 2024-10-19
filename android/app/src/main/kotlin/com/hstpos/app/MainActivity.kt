package com.hstpos.app

import android.content.Intent
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

@Suppress("UNCHECKED_CAST")
class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.hstpos.app/channel"
    private var initialDeepLink: String? = null
    private lateinit var printerProvider: PrinterProviderImpl

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleDeepLink(intent)
        try {
            printerProvider = PrinterProviderImpl.getInstance(this)
            printerProvider.initPrint()
        } catch (e: Exception) {
            Log.e("MainActivity", "Failed to initialize printer: ${e.message}")
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

    @RequiresApi(Build.VERSION_CODES.S)
    private fun openAppSettings() {
        val intent = Intent(
            Settings.ACTION_APP_OPEN_BY_DEFAULT_SETTINGS,
            Uri.parse("package:$packageName")
        )
        startActivity(intent)
    }

    @RequiresApi(Build.VERSION_CODES.S)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).apply {
            setMethodCallHandler { call, result ->
                when (call.method) {
                    "getInitialDeepLink" -> {
                        result.success(initialDeepLink)
                    }
                    "openAppSettings" -> {
                        openAppSettings()
                        result.success(null)
                    }
                    "printSlip" -> {
                        val paymentJson = call.arguments as Map<String, Any>
                        val receiptPrinter = ReceiptPrinter(context = this@MainActivity)
                        val receiptBitmap = receiptPrinter.createReceipt(paymentJson)
                        if (receiptBitmap != null) {
                            printerProvider.addBitmap(receiptBitmap, 0) // Add the bitmap to the printer
                            val printResult = printerProvider.startPrint() // Start the printing process
                            result.success(printResult)
                        } else {
                            result.error("PRINT_ERROR", "Failed to generate receipt", null)
                        }
                    }
                    "getPrinterStatus" -> {
                        val printerStatus = printerProvider.status
                        result.success(printerStatus)
                    }
                    else -> result.notImplemented()
                }
            }
        }
    }
}