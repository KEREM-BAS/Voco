# Flutter Wrapper
-keep class io.flutter.app.** { *;}
-keep class io.flutter.plugin.** { *;}
-keep class io.flutter.util.** { *;}
-keep class io.flutter.view.** { *;}
-keep class io.flutter.** { *;}
-keep class io.flutter.plugins.** { *;}

# Keep your MainActivity class to ensure method channels work in release mode
-keep class com.hstpos.app.MainActivity {
    *;
}

# Keep all method names used in MethodChannel to prevent them from being obfuscated
-keepclassmembers class * {
    @io.flutter.plugin.common.MethodChannel$MethodCallHandler <methods>;
}

# Preserve the native classes and methods that are called through the method channel
-keepclassmembers class * {
    void onMethodCall(io.flutter.plugin.common.MethodChannel$MethodCall, io.flutter.plugin.common.MethodChannel$Result);
}

# Keep any Printer-related classes and methods to ensure printing works correctly
-keep class com.hstpos.printer.** { *; }

# If you have any third-party SDKs for printers, add rules to prevent them from being obfuscated.
# Example:
-keep class com.your.printer.sdk.** { *; }