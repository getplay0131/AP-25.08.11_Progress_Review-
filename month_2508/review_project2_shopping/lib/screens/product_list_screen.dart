// 상품 목록 화면
import 'package:flutter/material.dart';
import 'package:review_project2_shopping/models/product.dart';

// 상품 목록 화면
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  // 필드
  List<product> productList = [];

  product product1 = product(
    productId: '001',
    productName: '상품1',
    price: 10000,
    stock: 50,
    description: '상품1 설명',
  );

  product product2 = product(
    productId: '002',
    productName: '상품2',
    price: 20000,
    stock: 30,
    description: '상품2 설명',
  );
  product product3 = product(
    productId: '003',
    productName: '상품3',
    price: 30000,
    stock: 20,
    description: '상품3 설명',
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  // 디버깅용 함수
  void _debugPrint(String message) {
    debugPrint('ProductListScreen: $message');
  }

  @override
  Widget build(BuildContext context) {
    // 상품 리스트 초기화 (예시 상품 3개)
    if (productList.isEmpty) {
      productList.addAll([product1, product2, product3]);
    }
    _debugPrint('build 호출됨');
    return Scaffold(
      appBar: AppBar(title: const Text('상품 목록')),
      body: ListView.builder(
        itemCount: productList.length,
        itemBuilder: (context, index) {
          final item = productList[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(item.productName),
              subtitle: Text(item.description),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('₩${item.price}'), Text('재고: ${item.stock}')],
              ),
              onTap: () => navigateToProductContentScreen(productList, index),
            ),
          );
        },
      ),
    );
  }

  //   method

  // 프로덕트 상세 스크린으로 이동하는 네비게이터 함수
  void navigateToProductContentScreen(List<product> products, int index) {
    Navigator.pushNamed(
      context,
      '/productContent',
      arguments: {'products': products[index], 'index': index},
    );
  }
}
