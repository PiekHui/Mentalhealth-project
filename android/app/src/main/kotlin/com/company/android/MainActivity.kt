package com.company.android

import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle
import android.util.Log

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Example: Add error logging for debugging
        try {
            // If you have any reflection or plugin initialization, wrap it in try-catch
            // Example:
            // val method = someObject?.javaClass?.getMethod("someMethod")
            // method?.invoke(someObject)
        } catch (e: Exception) {
            Log.e("MainActivity", "Error during initialization", e)
        }
    }
}