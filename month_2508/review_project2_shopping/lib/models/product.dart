enum category { ELECTRONICS, CLOTHING, HOME, BEAUTY, SPORTS, TOYS }

class product {
  // 필드
  late String productId;
  late String productName;
  late int price;
  late int stock;
  late String description;

  product({
    required String productId,
    required String productName,
    required int price,
    required int stock,
    required String description,
  }) {
    this.productId = productId;
    this.productName = productName;
    this.price = price;
    this.stock = stock;
    this.description = description;
  }

  // static getters
  String get getProductId => productId;
  String get getProductName => productName;
  int get getPrice => price;
  int get getStock => stock;
  String get getDescription => description;

  // 금액 계산 메서드
  int calculateTotalPrice(int quantity) {
    return price * quantity;
  }

  // 재고 확인 메서드
  bool isInStock(int quantity) {
    return stock >= quantity;
  }

  // 재고 감소 메서드
  void reduceStock(int quantity) {
    if (isInStock(quantity)) {
      stock -= quantity;
    } else {
      throw Exception('재고가 부족합니다.');
    }
  }

  // 상품 정보 출력 메서드
  String displayProductInfo() {
    return '상품ID: $productId, 상품명: $productName, 가격: $price, 재고: $stock, 설명: $description';
  }

  // 상품 정보 업데이트 메서드
  void updateProductInfo({
    String? newId,
    String? newName,
    int? newPrice,
    int? newStock,
    String? newDescription,
  }) {
    if (newId != null) productId = newId;
    if (newName != null) productName = newName;
    if (newPrice != null) price = newPrice;
    if (newStock != null) stock = newStock;
    if (newDescription != null) description = newDescription;
  }

  // 상품 삭제 메서드
  void deleteProduct() {
    productId = '';
    productName = '';
    price = 0;
    stock = 0;
    description = '';
  }

  // 상품 비교 메서드
  bool isEqual(product other) {
    return productId == other.productId &&
        productName == other.productName &&
        price == other.price &&
        stock == other.stock &&
        description == other.description;
  }

  // 상품 아이디로 비교하는 메서드
  bool isSameId(product other) {
    return productId == other.productId;
  }

  // 상품 카테고리 설정 메서드
  void setCategory(category cat) {
    // 카테고리 설정 로직
    switch (cat) {
      case category.ELECTRONICS:
        // 전자제품 관련 로직
        break;
      case category.CLOTHING:
        // 의류 관련 로직
        break;
      case category.HOME:
        // 홈 관련 로직
        break;
      case category.BEAUTY:
        // 뷰티 관련 로직
        break;
      case category.SPORTS:
        // 스포츠 관련 로직
        break;
      case category.TOYS:
        // 장난감 관련 로직
        break;
    }
  }
}
