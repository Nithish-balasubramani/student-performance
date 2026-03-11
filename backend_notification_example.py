"""
Backend Example: Send Push Notifications via Firebase Cloud Messaging (Python)

SETUP:
1. Install Firebase Admin SDK: pip install firebase-admin
2. Download service account key from Firebase Console:
   Project Settings > Service Accounts > Generate New Private Key
3. Save as 'serviceAccountKey.json' in your backend folder
4. Run this script: python backend_notification_example.py
"""

import firebase_admin
from firebase_admin import credentials, messaging
from datetime import datetime

# Initialize Firebase Admin SDK
cred = credentials.Certificate('serviceAccountKey.json')
firebase_admin.initialize_app(cred)

# ============================================
# EXAMPLE 1: Send to Single Device
# ============================================
def send_to_device(device_token):
    """Send notification to a single device"""
    message = messaging.Message(
        notification=messaging.Notification(
            title='Low Soil Moisture Alert! 🌱',
            body='Moisture level is at 25%. Your plants need water!',
        ),
        data={
            'type': 'moisture',
            'level': '25',
            'timestamp': str(int(datetime.now().timestamp())),
        },
        token=device_token,
    )

    try:
        response = messaging.send(message)
        print(f'✅ Successfully sent message: {response}')
        return response
    except Exception as error:
        print(f'❌ Error sending message: {error}')
        raise

# ============================================
# EXAMPLE 2: Send to Multiple Devices
# ============================================
def send_to_multiple_devices(device_tokens):
    """Send notification to multiple devices"""
    message = messaging.MulticastMessage(
        notification=messaging.Notification(
            title='Rain Expected Today 🌧️',
            body='Weather forecast shows rain. Irrigation scheduled paused.',
        ),
        data={
            'type': 'weather',
            'action': 'pause_irrigation',
        },
        tokens=device_tokens,
    )

    try:
        response = messaging.send_multicast(message)
        print(f'✅ {response.success_count} messages sent successfully')
        if response.failure_count > 0:
            print(f'❌ {response.failure_count} messages failed')
        return response
    except Exception as error:
        print(f'❌ Error sending bulk messages: {error}')
        raise

# ============================================
# EXAMPLE 3: Send to Topic (All Subscribed Users)
# ============================================
def send_to_topic(topic):
    """Send notification to all users subscribed to a topic"""
    message = messaging.Message(
        notification=messaging.Notification(
            title='System Update 🔔',
            body='Your irrigation system has been updated successfully!',
        ),
        data={
            'type': 'system',
            'update_version': '1.0.1',
        },
        topic=topic,  # e.g., 'all_users', 'zone_1', 'moisture_alerts'
    )

    try:
        response = messaging.send(message)
        print(f'✅ Successfully sent message to topic: {response}')
        return response
    except Exception as error:
        print(f'❌ Error sending message to topic: {error}')
        raise

# ============================================
# EXAMPLE 4: High Priority Notification
# ============================================
def send_high_priority_notification(device_token):
    """Send high priority critical notification"""
    message = messaging.Message(
        notification=messaging.Notification(
            title='⚠️ CRITICAL: Pump Failure Detected',
            body='Water pump has stopped working. Immediate attention required!',
        ),
        data={
            'type': 'pump',
            'status': 'failure',
            'priority': 'critical',
        },
        android=messaging.AndroidConfig(
            priority='high',
            notification=messaging.AndroidNotification(
                sound='default',
                priority='high',
                channel_id='system_alerts',
            ),
        ),
        apns=messaging.APNSConfig(
            payload=messaging.APNSPayload(
                aps=messaging.Aps(
                    sound='default',
                    badge=1,
                ),
            ),
        ),
        token=device_token,
    )

    try:
        response = messaging.send(message)
        print(f'✅ High priority notification sent: {response}')
        return response
    except Exception as error:
        print(f'❌ Error sending high priority notification: {error}')
        raise

# ============================================
# EXAMPLE 5: Subscribe Device to Topic
# ============================================
def subscribe_to_topic(device_tokens, topic):
    """Subscribe device tokens to a topic"""
    try:
        response = messaging.subscribe_to_topic(device_tokens, topic)
        print(f'✅ Successfully subscribed to topic "{topic}": {response}')
        return response
    except Exception as error:
        print(f'❌ Error subscribing to topic: {error}')
        raise

# ============================================
# FLASK API ENDPOINT EXAMPLE
# ============================================
"""
from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/api/notifications/send', methods=['POST'])
def send_notification():
    data = request.json
    device_token = data.get('deviceToken')
    title = data.get('title')
    body = data.get('body')
    custom_data = data.get('data', {})

    message = messaging.Message(
        notification=messaging.Notification(title=title, body=body),
        data=custom_data,
        token=device_token,
    )

    try:
        response = messaging.send(message)
        return jsonify({'success': True, 'messageId': response})
    except Exception as error:
        return jsonify({'success': False, 'error': str(error)}), 500

@app.route('/api/notifications/moisture-alert', methods=['POST'])
def send_moisture_alert():
    data = request.json
    device_token = data.get('deviceToken')
    moisture_level = data.get('moistureLevel')

    message = messaging.Message(
        notification=messaging.Notification(
            title='Low Soil Moisture Alert! 🌱',
            body=f'Moisture level is at {moisture_level}%. Your plants need water!',
        ),
        data={
            'type': 'moisture',
            'level': str(moisture_level),
        },
        token=device_token,
    )

    try:
        response = messaging.send(message)
        return jsonify({'success': True, 'messageId': response})
    except Exception as error:
        return jsonify({'success': False, 'error': str(error)}), 500

if __name__ == '__main__':
    app.run(debug=True, port=5000)
    print('🚀 Notification server running on port 5000')
"""

# ============================================
# USAGE EXAMPLES
# ============================================
if __name__ == '__main__':
    # Replace with actual device token from your Flutter app (printed in console)
    DEVICE_TOKEN = 'YOUR_DEVICE_FCM_TOKEN_HERE'

    print('📱 Firebase Cloud Messaging Backend Example (Python)')
    print('Replace DEVICE_TOKEN with your actual FCM token from the Flutter app')
    print('Uncomment the function calls you want to test\n')

    # Example: Send notification to single device
    # send_to_device(DEVICE_TOKEN)

    # Example: Send to multiple devices
    # tokens = ['token1', 'token2', 'token3']
    # send_to_multiple_devices(tokens)

    # Example: Send to all users subscribed to 'moisture_alerts'
    # send_to_topic('moisture_alerts')

    # Example: Send high priority notification
    # send_high_priority_notification(DEVICE_TOKEN)

    # Example: Subscribe device to topic
    # subscribe_to_topic([DEVICE_TOKEN], 'moisture_alerts')
