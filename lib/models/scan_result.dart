class ScanResult {
  final int? id;
  final String productName;
  final String? brand;
  final String? imageUrl;
  final String? barcode;
  final List<String> ingredients;
  final List<String> allergens;
  final Map<String, String> allergiesDetected;
  final String scanType; // 'barcode' or 'manual'
  final DateTime scannedAt;

  ScanResult({
    this.id,
    required this.productName,
    this.brand,
    this.imageUrl,
    this.barcode,
    required this.ingredients,
    required this.allergens,
    required this.allergiesDetected,
    required this.scanType,
    required this.scannedAt,
  });

  // Convert to Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productName': productName,
      'brand': brand,
      'imageUrl': imageUrl,
      'barcode': barcode,
      'ingredients': ingredients.join('|'), // Store as pipe-separated string
      'allergens': allergens.join('|'), // Store as pipe-separated string
      'allergiesDetected': _encodeAllergies(allergiesDetected),
      'scanType': scanType,
      'scannedAt': scannedAt.millisecondsSinceEpoch,
    };
  }

  // Create from Map (database result)
  factory ScanResult.fromMap(Map<String, dynamic> map) {
    return ScanResult(
      id: map['id']?.toInt(),
      productName: map['productName'] ?? '',
      brand: map['brand'],
      imageUrl: map['imageUrl'],
      barcode: map['barcode'],
      ingredients: (map['ingredients'] as String?)?.split('|') ?? [],
      allergens: (map['allergens'] as String?)?.split('|') ?? [],
      allergiesDetected: _decodeAllergies(map['allergiesDetected'] ?? ''),
      scanType: map['scanType'] ?? 'manual',
      scannedAt: DateTime.fromMillisecondsSinceEpoch(map['scannedAt'] ?? 0),
    );
  }

  // Helper method to encode allergies map as string
  static String _encodeAllergies(Map<String, String> allergies) {
    return allergies.entries
        .map((entry) => '${entry.key}:${entry.value}')
        .join('|');
  }

  // Helper method to decode allergies string to map
  static Map<String, String> _decodeAllergies(String encoded) {
    if (encoded.isEmpty) return {};

    final Map<String, String> result = {};
    for (final pair in encoded.split('|')) {
      if (pair.contains(':')) {
        final parts = pair.split(':');
        if (parts.length == 2) {
          result[parts[0]] = parts[1];
        }
      }
    }
    return result;
  }

  @override
  String toString() {
    return 'ScanResult{id: $id, productName: $productName, scanType: $scanType, scannedAt: $scannedAt}';
  }
}
