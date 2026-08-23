class NotificationService {
  // Simulates Firebase Cloud Messaging (FCM)
  
  Future<void> initPushNotifications() async {
    // In production, request permission and get FCM token
    print('Push notifications initialized');
  }

  Future<void> sendMatchAlert(String userId, String itemName) async {
    // Backend triggers this when matchmaking score > 75
    print('FCM Sent to $userId: "Possible match found for your $itemName!"');
  }

  Future<void> sendTransitAlert(String userId, String stationName) async {
    // Transit alert for upcoming station
    print('FCM Sent to $userId: "Alert: Approaching $stationName. Check your belongings!"');
  }
}
