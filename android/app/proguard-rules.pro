# ===== Flutter =====
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.embedding.engine.** { *; }
-keep class io.flutter.embedding.android.** { *; }

# Platform channels
-keep class * extends io.flutter.plugin.common.MethodChannel$MethodCallHandler { *; }
-keep class * extends io.flutter.plugin.common.EventChannel$StreamHandler { *; }

# ===== Google Play Core =====
-keep class com.google.android.play.core.** { *; }
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-dontwarn com.google.android.play.core.**

# ===== Dio/OkHttp =====
-keepattributes Signature, *Annotation*
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-dontwarn okhttp3.**
-dontwarn okio.**

# ===== Firebase (if used) =====
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# ===== App-Specific =====
-keep public class com.n_prep.medieducation.MainActivity
-keep class com.n_prep.medieducation.BuildConfig { *; }

# ===== Native/Enums =====
-keepclasseswithmembernames class * {
    native <methods>;
}
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# ===== Remove Debug Logs =====
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
    public static *** w(...);
    public static *** e(...);
}

# ===== Aggressive Optimizations =====
-optimizationpasses 5
-overloadaggressively
-repackageclasses ''
-allowaccessmodification

# Remove unused code
-dontwarn javax.**
-dontwarn java.awt.**
-dontwarn sun.misc.**
-dontwarn com.sun.**

# Strip debug info
-renamesourcefileattribute SourceFile
-keepattributes SourceFile,LineNumberTable
