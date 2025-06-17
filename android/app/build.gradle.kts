plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    // --- Tambahkan plugin Google services Gradle di sini ---
    id("com.google.gms.google-services") // Ini sangat penting untuk Firebase
}

android {
    namespace = "com.example.flutter_application_1" // Pastikan ini sesuai dengan namespace proyek Anda
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.flutter_application_1" // Pastikan ini sesuai dengan ID aplikasi Anda
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// --- Tambahkan blok dependencies untuk Firebase di sini ---
dependencies {
    // Import the Firebase BoM (Bill of Materials) untuk mengelola versi dependensi Firebase
    // Ini membantu memastikan semua dependensi Firebase Anda menggunakan versi yang kompatibel.
    // Selalu periksa versi BoM terbaru di dokumentasi Firebase atau repositori Maven
    implementation(platform("com.google.firebase:firebase-bom:33.15.0")) // Ganti dengan versi BoM terbaru jika ada

    // TODO: Tambahkan dependensi untuk produk Firebase yang ingin Anda gunakan
    // Saat menggunakan BoM, jangan tentukan versi di dependensi Firebase ini,
    // karena BoM yang akan mengelola versi yang benar.

    // Dependensi wajib untuk Firebase:
    implementation("com.google.firebase:firebase-analytics") // Umumnya disertakan untuk analytics dasar

    // Dependensi spesifik untuk Firebase Authentication:
    implementation("com.google.firebase:firebase-auth") // Ini adalah dependensi untuk otentikasi

    // Tambahkan dependensi untuk produk Firebase lain jika diperlukan, contoh:
    // implementation("com.google.firebase:firebase-firestore")   // Untuk Cloud Firestore
    // implementation("com.google.firebase:firebase-storage")     // Untuk Cloud Storage
    // implementation("com.google.firebase:firebase-messaging")   // Untuk Cloud Messaging (FCM)
}
