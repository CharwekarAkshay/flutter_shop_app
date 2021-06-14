import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> itemsList = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final String? token;
  final String? userId;

  Products(
      {required this.token, required this.itemsList, required this.userId});

  List<Product> get items {
    return [...itemsList];
  }

  List<Product> get favoriteItems {
    return itemsList.where((product) => product.isFavorite).toList();
  }

  Product findById(String id) {
    return itemsList.firstWhere((product) => product.id == id);
  }

  Future<void> fetchAndSetProduct([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    final url =
        'https://shopapplication-4e66b-default-rtdb.firebaseio.com/products.json?auth=$token$filterString';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if (extractedData == null) return;

      // Extracting favorite products of user
      final favoriteProductUrl =
          "https://shopapplication-4e66b-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$token";
      final favoriteResponse = await http.get(Uri.parse(favoriteProductUrl));
      final favoriteData = json.decode(favoriteResponse.body);

      extractedData.forEach((productId, productData) {
        loadedProducts.add(
          Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            isFavorite:
                favoriteData == null ? false : favoriteData[productId] ?? false,
            imageUrl: productData['imageUrl'],
          ),
        );
      });
      itemsList = loadedProducts;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addNewProduct(Product product) async {
    final url =
        "https://shopapplication-4e66b-default-rtdb.firebaseio.com/products.json?auth=$token";
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': userId,
          },
        ),
      );

      final newProduct = Product(
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
        id: json.decode(response.body)['name'],
      );
      itemsList.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = itemsList.indexWhere((prod) => prod.id == id);
    final url =
        "https://shopapplication-4e66b-default-rtdb.firebaseio.com/products/$id.json?auth=$token";
    if (prodIndex >= 0) {
      await http.patch(
        Uri.parse(url),
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price,
        }),
      );
      itemsList[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        "https://shopapplication-4e66b-default-rtdb.firebaseio.com/products/$id.json?auth=$token";
    final existingProductIndex = itemsList.indexWhere((prod) => prod.id == id);
    Product? existingProduct = itemsList[existingProductIndex];
    itemsList.removeAt(existingProductIndex);
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      itemsList.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingProduct = null;
    notifyListeners();
  }
}
