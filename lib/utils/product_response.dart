class ProductResponse {
  final String? name;
  final String? brands;
  final String? imageUrl;
  final int status;
  final String? statusVerbose;

  ProductResponse({
    this.name,
    this.brands,
    this.imageUrl,
    this.status = 0,
    this.statusVerbose,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      name: json['product']?['product_name'],
      brands: json['product']?['brands'],
      imageUrl: json['product']?['image_url'],
      status: json['status'] ?? 0,
      statusVerbose: json['status_verbose'],
    );
  }
}
