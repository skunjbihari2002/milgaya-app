class NlpService {
  // Mock implementation of Google Cloud Speech-to-Text & NLP parsing
  Future<Map<String, dynamic>> parseVoiceReport(String audioFilePath) async {
    // In production, this sends audio to backend, which returns parsed JSON
    await Future.delayed(const Duration(seconds: 2));
    return {
      'category': 'Bag',
      'color': 'Black',
      'location': 'Bhopal Station',
      'type': 'LOST',
    };
  }
}
