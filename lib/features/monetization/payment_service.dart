class PaymentService {
  // Simulates UPI intent or Payment Gateway (Razorpay/Stripe)

  Future<bool> initiateSosBoost(String itemId) async {
    // Deduct ₹49 for SOS Boost
    await Future.delayed(const Duration(seconds: 2));
    print('SOS Boost Activated for Item: $itemId (₹49 paid)');
    return true;
  }

  Future<bool> sendTipToFinder(String finderId, double amount) async {
    // 10% commission logic
    double platformFee = amount * 0.10;
    double finderAmount = amount - platformFee;
    
    await Future.delayed(const Duration(seconds: 2));
    print('Tip of ₹$amount sent. Finder receives ₹$finderAmount. Platform fee: ₹$platformFee');
    return true;
  }
}
