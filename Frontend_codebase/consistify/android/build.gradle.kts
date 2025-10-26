//allprojects {
//    repositories {
//        google()
//        mavenCentral()
//    }
//}
//
//val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
//rootProject.layout.buildDirectory.value(newBuildDir)
//
//subprojects {
//    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
//    project.layout.buildDirectory.value(newSubprojectBuildDir)
//}
//subprojects {
//    project.evaluationDependsOn(":app")
//}
//
//tasks.register<Delete>("clean") {
//    delete(rootProject.layout.buildDirectory)
//}



// C:\Users\hp\Documents\consistify\android\build.gradle.kts (Project-level build file)

// C:\Users\hp\Documents\consistify\android\build.gradle.kts (Project-level build file)

// Top-level build file where you can add configuration options common to all sub-projects/modules.
// C:\Users\hp\Documents\consistify\android\build.gradle.kts (Project-level build file)

// Top-level build file where you can add configuration options common to all sub-projects/modules.
// C:\Users\hp\Documents\consistify\android\build.gradle.kts (Project-level build file)

// Top-level build file where you can add configuration options common to all sub-projects/modules.









// Top-level build.gradle.kts
// Project-level build.gradle.kts

// Project-level build.gradle.kts

// C:\Users\hp\Documents\consistify\android\build.gradle.kts (Project-level build file)

// C:\Users\hp\Documents\consistify\android\build.gradle.kts (Project-level build file)

// C:\Users\hp\Documents\consistify\android\build.gradle.kts (Project-level build file)

// C:\Users\hp\Documents\consistify\android\build.gradle.kts (Project-level build file)

// C:\Users\hp\Documents\consistify\android\build.gradle.kts (Project-level build file)

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Define the Android Gradle Plugin (AGP) version here globally
        classpath("com.android.tools.build:gradle:8.7.3") // Ensure this matches the version in plugins block
        // Define the Kotlin Gradle Plugin version here globally
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:2.1.0") // Ensure this matches the version in plugins block
        // Define the Google Services plugin version here globally for Firebase
        classpath("com.google.gms:google-services:4.4.1") // Ensure this matches the version in plugins block
    }
}

plugins {
    // These plugins are applied to subprojects (like 'app') but declared here
    // The 'version' for com.android.application, org.jetbrains.kotlin.android,
    // and com.google.gms.google-services should match the classpath dependencies above.
    id("com.android.application") apply false
    id("org.jetbrains.kotlin.android") apply false
    id("dev.flutter.flutter-gradle-plugin") apply false
    id("com.google.gms.google-services") apply false
}

// Expose values for Flutter plugins that read rootProject.ext properties (Groovy builds)
extra.apply {
    set("compileSdkVersion", 35)
    set("targetSdkVersion", 35)
    set("minSdkVersion", 23)
    set("kotlin_version", "2.1.0")
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }

    // Unify Kotlin/Java targets across all subprojects to avoid JVM target mismatches
    subprojects {
        // Force Kotlin JVM target 17
        tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
            kotlinOptions.jvmTarget = "17"
        }

        // Force Java compile target 17 for any Java compilation
        tasks.withType<JavaCompile>().configureEach {
            sourceCompatibility = "17"
            targetCompatibility = "17"
        }

        // For Android modules (application or library), set compileOptions to 17
        afterEvaluate {
            val androidExt = extensions.findByName("android")
            if (androidExt is com.android.build.gradle.BaseExtension) {
                androidExt.compileOptions.apply {
                    sourceCompatibility = JavaVersion.VERSION_17
                    targetCompatibility = JavaVersion.VERSION_17
                }
            }
        }
    }

    // Do not force --release for Android modules; AGP manages bootClasspath. Using --release here breaks android.* resolution.

}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}