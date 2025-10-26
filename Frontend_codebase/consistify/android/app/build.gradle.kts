//plugins {
//    id("com.android.application")
//    // START: FlutterFire Configuration
//    id("com.google.gms.google-services")
//    // END: FlutterFire Configuration
//    id("kotlin-android")
//    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
//    id("dev.flutter.flutter-gradle-plugin")
//}
//
//android {
//    namespace = "com.example.consistify"
//    compileSdk = flutter.compileSdkVersion
////    ndkVersion = flutter.ndkVersion
//    ndkVersion = "29.0.14206865"
//
//    compileOptions {
//        sourceCompatibility = JavaVersion.VERSION_11
//        targetCompatibility = JavaVersion.VERSION_11
//    }
//
//    kotlinOptions {
//        jvmTarget = JavaVersion.VERSION_11.toString()
//    }
//
//    defaultConfig {
//        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
//        applicationId = "com.example.consistify"
//        // You can update the following values to match your application needs.
//        // For more information, see: https://flutter.dev/to/review-gradle-config.
//        minSdk = flutter.minSdkVersion
//        targetSdk = flutter.targetSdkVersion
//        versionCode = flutter.versionCode
//        versionName = flutter.versionName
//    }
//
//    buildTypes {
//        release {
//            // TODO: Add your own signing config for the release build.
//            // Signing with the debug keys for now, so `flutter run --release` works.
//            signingConfig = signingConfigs.getByName("debug")
//        }
//    }
//}
//
//flutter {
//    source = "../.."
//}



// C:\Users\hp\Documents\consistify\android\app\build.gradle.kts

// C:\Users\hp\Documents\consistify\android\app\build.gradle.kts








// C:\Users\hp\Documents\consistify\android\app\build.gradle.kts (App module build file)

// C:\Users\hp\Documents\consistify\android\app\build.gradle.kts (App module build file)

// C:\Users\hp\Documents\consistify\android\app\build.gradle.kts (App module build file)

// C:\Users\hp\Documents\consistify\android\app\build.gradle.kts (App module build file)

// C:\Users\hp\Documents\consistify\android\app\build.gradle.kts (App module build file)

import org.gradle.api.JavaVersion
import org.gradle.kotlin.dsl.*
import com.android.build.gradle.internal.dsl.BaseAppModuleExtension

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // Keep uncommented if using Firebase
}

android { // Using the 'android' extension from com.android.application plugin
    namespace = "com.example.consistify"
    compileSdk = 35 // Target SDK 35
    buildToolsVersion = "35.0.0" // Or "34.0.0" if 35.0.0 isn't stable/available
    ndkVersion = "27.0.12077973"  // Keep this, matches your local.properties

    defaultConfig {
        applicationId = "com.example.consistify"
        minSdk = 23 // Required by firebase_messaging and modern plugins
        targetSdk = 35 // Match compileSdk
        versionCode = 1
        versionName = "1.0"
        multiDexEnabled = true // Required for minSdk 21 with many dependencies
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    buildFeatures {
        viewBinding = true
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    implementation("androidx.multidex:multidex:2.0.1") // Required for multiDexEnabled
}