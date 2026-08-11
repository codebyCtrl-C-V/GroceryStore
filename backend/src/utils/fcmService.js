const { initializeApp, cert } = require('firebase-admin/app');
const { getMessaging } = require('firebase-admin/messaging');

const serviceAccount = require('../../firebase-adminsdk.json');

const firebaseApp = initializeApp({
    credential: cert(serviceAccount),
});

const messaging = getMessaging(firebaseApp);

/**
 * Gửi notification tới 1 thiết bị cụ thể (theo fcmToken)
 */
async function sendNotificationToDevice(fcmToken, title, body, data = {}) {
    const message = {
        token: fcmToken,
        notification: { title, body },
        data: Object.fromEntries(
            Object.entries(data).map(([k, v]) => [k, String(v)])
        ),
        android: {
            notification: {
                channelId: 'order_updates',
                priority: 'high',
            },
        },
        apns: {
            payload: {
                aps: { sound: 'default' },
            },
        },
    };

    try {
        const response = await messaging.send(message);
        console.log('Gửi notification thành công:', response);
        return { success: true, response };
    } catch (error) {
        console.error('Gửi notification thất bại:', error.message);
        if (
            error.code === 'messaging/registration-token-not-registered' ||
            error.code === 'messaging/invalid-registration-token'
        ) {
            return { success: false, tokenInvalid: true };
        }
        return { success: false, error: error.message };
    }
}

/**
 * Gửi cùng lúc tới nhiều thiết bị
 */
async function sendNotificationToMultipleDevices(fcmTokens, title, body, data = {}) {
    if (!fcmTokens.length) return { success: false, error: 'Không có token nào' };

    const message = {
        tokens: fcmTokens,
        notification: { title, body },
        data: Object.fromEntries(
            Object.entries(data).map(([k, v]) => [k, String(v)])
        ),
        android: {
            notification: { channelId: 'order_updates', priority: 'high' },
        },
    };

    try {
        const response = await messaging.sendEachForMulticast(message);
        console.log(`Thành công: ${response.successCount}, Thất bại: ${response.failureCount}`);
        return { success: true, response };
    } catch (error) {
        console.error('Gửi notification hàng loạt thất bại:', error.message);
        return { success: false, error: error.message };
    }
}

/**
 * Gửi notification tới tất cả user (dùng cho admin broadcast)
 */
async function sendNotificationToAllUsers(title, body, data = {}) {
    const users = await User.find().select('fcmToken');
    const tokens = users
        .map(u => u.fcmToken)
        .filter(Boolean);

    return sendNotificationToMultipleDevices(tokens, title, body, data);
}

module.exports = {
    sendNotificationToDevice,
    sendNotificationToMultipleDevices,
    sendNotificationToAllUsers
};