class MockDatabase {
  static final MockDatabase _instance = MockDatabase._internal();
  factory MockDatabase() => _instance;
  MockDatabase._internal();

  // --- Help Requests ---
  List<Map<String, dynamic>> helpRequests = [
    {'category': 'PET CARE', 'title': 'Dog walking needed this weekend', 'desc': 'Need someone to walk my 2-year-old Labrador.', 'user': 'Sarah Johnson', 'time': '5h', 'price': '\$25', 'icon': 'pets'},
    {'category': 'TECH HELP', 'title': 'Laptop tech support needed', 'desc': 'My MacBook is running slow and needs a tune-up.', 'user': 'John Smith', 'time': '1d', 'price': '\$40', 'icon': 'computer'},
  ];

  // --- Lost & Found Items ---
  List<Map<String, dynamic>> lostFoundItems = [
    {'type': 'Lost', 'title': 'Black Leather Wallet', 'desc': 'Lost near DB Mall yesterday.', 'user': 'Alex Kim', 'time': '2h', 'tagColor': 'red', 'image': null},
    {'type': 'Found', 'title': 'iPhone 13 Pro', 'desc': 'Found at Indore Airport Terminal 2.', 'user': 'Priya S.', 'time': '4h', 'tagColor': 'green', 'image': null},
  ];

  // --- Messages ---
  List<Map<String, dynamic>> messages = [
    {'name': 'Sarah Johnson', 'msg': 'Hey, is the wallet still available?', 'time': '2m ago', 'unread': true, 'avatar': 'S'},
    {'name': 'Safe Hub: City Cafe', 'msg': 'Your item has been deposited here.', 'time': '1h ago', 'unread': false, 'avatar': 'C'},
  ];

  void addHelpRequest(Map<String, dynamic> request) {
    helpRequests.insert(0, request);
  }

  void addLostFoundItem(Map<String, dynamic> item) {
    lostFoundItems.insert(0, item);
  }

  void addMessage(Map<String, dynamic> message) {
    messages.insert(0, message);
  }
}
