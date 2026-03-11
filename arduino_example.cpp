// Example Arduino/ESP32 code for IoT sensors
// This code reads sensors and updates Firebase Realtime Database

#include <WiFi.h>
#include <FirebaseESP32.h>
#include <DHT.h>

// WiFi credentials
#define WIFI_SSID "Your_WiFi_SSID"
#define WIFI_PASSWORD "Your_WiFi_Password"

// Firebase credentials
#define FIREBASE_HOST "your-project.firebaseio.com"
#define FIREBASE_AUTH "your-database-secret-or-token"

// User ID (get from Firebase Authentication)
#define USER_ID "your-user-id"

// Pin definitions
#define MOISTURE_SENSOR_PIN 34  // Analog pin for soil moisture sensor
#define DHT_PIN 4               // Digital pin for DHT sensor
#define PUMP_RELAY_PIN 5        // Digital pin for pump relay

// DHT sensor type
#define DHTTYPE DHT11

// Initialize sensors
DHT dht(DHT_PIN, DHTTYPE);
FirebaseData firebaseData;

// Variables
unsigned long lastUpdate = 0;
const unsigned long UPDATE_INTERVAL = 5000; // Update every 5 seconds

void setup() {
  Serial.begin(115200);
  
  // Initialize pins
  pinMode(MOISTURE_SENSOR_PIN, INPUT);
  pinMode(PUMP_RELAY_PIN, OUTPUT);
  digitalWrite(PUMP_RELAY_PIN, LOW);
  
  // Initialize DHT sensor
  dht.begin();
  
  // Connect to WiFi
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to WiFi");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  Serial.println("\nWiFi Connected!");
  Serial.print("IP Address: ");
  Serial.println(WiFi.localIP());
  
  // Initialize Firebase
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
  Firebase.reconnectWiFi(true);
  Serial.println("Firebase Connected!");
}

void loop() {
  unsigned long currentTime = millis();
  
  // Update sensor data every UPDATE_INTERVAL
  if (currentTime - lastUpdate >= UPDATE_INTERVAL) {
    lastUpdate = currentTime;
    
    // Read sensors
    float moisture = readMoisture();
    float temperature = dht.readTemperature();
    float humidity = dht.readHumidity();
    
    // Check if readings are valid
    if (isnan(temperature) || isnan(humidity)) {
      Serial.println("Failed to read from DHT sensor!");
      return;
    }
    
    // Update Firebase with sensor data
    String path = "/users/" + String(USER_ID) + "/sensorData";
    
    Firebase.setFloat(firebaseData, path + "/moistureLevel", moisture);
    Firebase.setFloat(firebaseData, path + "/temperature", temperature);
    Firebase.setFloat(firebaseData, path + "/humidity", humidity);
    Firebase.setString(firebaseData, path + "/timestamp", getCurrentTimestamp());
    Firebase.setString(firebaseData, path + "/status", "normal");
    
    // Debug output
    Serial.println("===== Sensor Data =====");
    Serial.print("Moisture: ");
    Serial.print(moisture);
    Serial.println("%");
    Serial.print("Temperature: ");
    Serial.print(temperature);
    Serial.println("°C");
    Serial.print("Humidity: ");
    Serial.print(humidity);
    Serial.println("%");
    Serial.println("=======================");
  }
  
  // Check pump status from Firebase
  String pumpPath = "/users/" + String(USER_ID) + "/sensorData/pumpStatus";
  if (Firebase.getBool(firebaseData, pumpPath)) {
    bool pumpStatus = firebaseData.boolData();
    controlPump(pumpStatus);
  }
  
  delay(100);
}

// Read soil moisture sensor (0-100%)
float readMoisture() {
  int sensorValue = analogRead(MOISTURE_SENSOR_PIN);
  // Convert to percentage (calibrate based on your sensor)
  // Typical range: dry (4095) to wet (0)
  float moisture = map(sensorValue, 4095, 0, 0, 100);
  moisture = constrain(moisture, 0, 100);
  return moisture;
}

// Control pump relay
void controlPump(bool status) {
  digitalWrite(PUMP_RELAY_PIN, status ? HIGH : LOW);
  Serial.print("Pump: ");
  Serial.println(status ? "ON" : "OFF");
}

// Get current timestamp (simplified - use NTP for accurate time)
String getCurrentTimestamp() {
  return String(millis());
}

/* 
 * WIRING GUIDE:
 * 
 * Soil Moisture Sensor:
 * - VCC → 3.3V
 * - GND → GND
 * - A0  → GPIO 34 (MOISTURE_SENSOR_PIN)
 * 
 * DHT11/DHT22 Sensor:
 * - VCC → 3.3V
 * - GND → GND
 * - DATA → GPIO 4 (DHT_PIN)
 * 
 * Relay Module (for Pump):
 * - VCC → 5V
 * - GND → GND
 * - IN  → GPIO 5 (PUMP_RELAY_PIN)
 * - COM → Pump Power Supply
 * - NO  → Pump Motor
 * 
 * INSTALLATION STEPS:
 * 1. Install required libraries in Arduino IDE:
 *    - DHT sensor library
 *    - FirebaseESP32 library
 * 2. Update WiFi and Firebase credentials
 * 3. Get your User ID from Firebase Authentication
 * 4. Upload code to ESP32
 * 5. Monitor Serial output for debugging
 */
