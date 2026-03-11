/**
 * Backend Example: Send Push Notifications via Firebase Cloud Messaging
 * 
 * SETUP:
 * 1. Install Firebase Admin SDK: npm install firebase-admin
 * 2. Download service account key from Firebase Console:
 *    Project Settings > Service Accounts > Generate New Private Key
 * 3. Save as 'serviceAccountKey.json' in your backend folder
 * 4. Run this script: node backend_notification_example.js
 */

const admin = require('firebase-admin');

// Initialize Firebase Admin SDK
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

// ============================================
// EXAMPLE 1: Send to Single Device
// ============================================
async function sendToDevice(deviceToken) {
  const message = {
    notification: {
      title: 'Low Soil Moisture Alert! 🌱',
      body: 'Moisture level is at 25%. Your plants need water!',
    },
    data: {
      type: 'moisture',
      level: '25',
      timestamp: Date.now().toString(),
    },
    token: deviceToken,
  };

  try {
    const response = await admin.messaging().send(message);
    console.log('✅ Successfully sent message:', response);
    return response;
  } catch (error) {
    console.error('❌ Error sending message:', error);
    throw error;
  }
}

// ============================================
// EXAMPLE 2: Send to Multiple Devices
// ============================================
async function sendToMultipleDevices(deviceTokens) {
  const message = {
    notification: {
      title: 'Rain Expected Today 🌧️',
      body: 'Weather forecast shows rain. Irrigation scheduled paused.',
    },
    data: {
      type: 'weather',
      action: 'pause_irrigation',
    },
    tokens: deviceTokens, // Array of device tokens
  };

  try {
    const response = await admin.messaging().sendEachForMulticast(message);
    console.log(`✅ ${response.successCount} messages sent successfully`);
    if (response.failureCount > 0) {
      console.log(`❌ ${response.failureCount} messages failed`);
    }
    return response;
  } catch (error) {
    console.error('❌ Error sending bulk messages:', error);
    throw error;
  }
}

// ============================================
// EXAMPLE 3: Send to Topic (All Subscribed Users)
// ============================================
async function sendToTopic(topic) {
  const message = {
    notification: {
      title: 'System Update 🔔',
      body: 'Your irrigation system has been updated successfully!',
    },
    data: {
      type: 'system',
      update_version: '1.0.1',
    },
    topic: topic, // e.g., 'all_users', 'zone_1', 'moisture_alerts'
  };

  try {
    const response = await admin.messaging().send(message);
    console.log('✅ Successfully sent message to topic:', response);
    return response;
  } catch (error) {
    console.error('❌ Error sending message to topic:', error);
    throw error;
  }
}

// ============================================
// EXAMPLE 4: Scheduled Notification with Priority
// ============================================
async function sendHighPriorityNotification(deviceToken) {
  const message = {
    notification: {
      title: '⚠️ CRITICAL: Pump Failure Detected',
      body: 'Water pump has stopped working. Immediate attention required!',
    },
    data: {
      type: 'pump',
      status: 'failure',
      priority: 'critical',
    },
    android: {
      priority: 'high',
      notification: {
        sound: 'default',
        priority: 'high',
        channelId: 'system_alerts',
      },
    },
    apns: {
      payload: {
        aps: {
          sound: 'default',
          badge: 1,
        },
      },
    },
    token: deviceToken,
  };

  try {
    const response = await admin.messaging().send(message);
    console.log('✅ High priority notification sent:', response);
    return response;
  } catch (error) {
    console.error('❌ Error sending high priority notification:', error);
    throw error;
  }
}

// ============================================
// EXAMPLE 5: Subscribe Device to Topic
// ============================================
async function subscribeToTopic(deviceTokens, topic) {
  try {
    const response = await admin.messaging().subscribeToTopic(deviceTokens, topic);
    console.log(`✅ Successfully subscribed to topic "${topic}":`, response);
    return response;
  } catch (error) {
    console.error('❌ Error subscribing to topic:', error);
    throw error;
  }
}

// ============================================
// USAGE EXAMPLES
// ============================================

// Replace with actual device token from your Flutter app (printed in console)
const DEVICE_TOKEN = 'YOUR_DEVICE_FCM_TOKEN_HERE';

// Example: Send notification to single device
// sendToDevice(DEVICE_TOKEN);

// Example: Send to multiple devices
// const tokens = ['token1', 'token2', 'token3'];
// sendToMultipleDevices(tokens);

// Example: Send to all users subscribed to 'moisture_alerts'
// sendToTopic('moisture_alerts');

// Example: Send high priority notification
// sendHighPriorityNotification(DEVICE_TOKEN);

// Example: Subscribe device to topic
// subscribeToTopic([DEVICE_TOKEN], 'moisture_alerts');

// ============================================
// EXPRESS.JS API ENDPOINT EXAMPLE
// ============================================
/*
const express = require('express');
const app = express();
app.use(express.json());

// POST /api/notifications/send
app.post('/api/notifications/send', async (req, res) => {
  const { deviceToken, title, body, data } = req.body;

  const message = {
    notification: { title, body },
    data: data || {},
    token: deviceToken,
  };

  try {
    const response = await admin.messaging().send(message);
    res.json({ success: true, messageId: response });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

app.listen(3000, () => {
  console.log('🚀 Notification server running on port 3000');
});
*/

console.log('📱 Firebase Cloud Messaging Backend Example');
console.log('Replace DEVICE_TOKEN with your actual FCM token from the Flutter app');
console.log('Uncomment the function calls you want to test');
