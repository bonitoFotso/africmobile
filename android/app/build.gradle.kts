plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.afric.africmobile"
    compileSdk = 35  // Au lieu de flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"  // Vous l'avez déjà selon les logs
    
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }
    
    defaultConfig {
        applicationId = "com.afric.africmobile"
        minSdk = flutter.minSdkVersion  // Au lieu de flutter.minSdkVersion
        targetSdk = 35  // Au lieu de flutter.targetSdkVersion
        versionCode = flutter.versionCode  // Gardez celui-ci
        versionName = flutter.versionName  // Gardez celui-ci
    }
    
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
