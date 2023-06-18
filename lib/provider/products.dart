import 'dart:convert';
import 'dart:io';

import 'package:ecomapp/provider/product.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

const uuid = Uuid();

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    //   id: uuid.v4(),
    // ),
    // Product(
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    //   id: uuid.v4(),
    // ),
    // Product(
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    //   id: uuid.v4(),
    // ),
    // Product(
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    //   id: uuid.v4(),
    // ),
    // Product(
    //     title: 'Pent Coat',
    //     description: 'Get ready for wedding any time',
    //     price: 100,
    //     imageUrl:
    //         'https://tse1.mm.bing.net/th?id=OIP.--ro3wkW2w11z9M0LU7MugHaLL&pid=Api&P=0',
    //     id: uuid.v4()),
    // Product(
    //     title: 'Kind Cloth',
    //     description: 'Give your child a stylish look',
    //     price: 55.7,
    //     imageUrl:
    //         'https://tse1.mm.bing.net/th?id=OIP.tbdFF45vf1faG7_WVYCBIwDiEU&pid=Api&P=0',
    //     id: uuid.v4()),
    // Product(
    //     title: 'T-shirt',
    //     description: 'Make your look attaractive',
    //     price: 30.78,
    //     imageUrl:
    //         'https://sc01.alicdn.com/kf/H1120b832d8ca43dfa6ebccdeb74a4e395/238908982/H1120b832d8ca43dfa6ebccdeb74a4e395.jpg',
    //     id: uuid.v4()),
    // Product(
    //     title: '',
    //     description: 'Set of good looking cloth for winter season',
    //     price: 60.78,
    //     imageUrl:
    //         'https://media.istockphoto.com/photos/mens-clothing-isolated-on-white-background-picture-id895507422?k=6&m=895507422&s=612x612&w=0&h=va-3ITxwMgHsEBbNlrIBkenlKpCMIvFSRPbwJ1PkZyE=',
    //     id: uuid.v4()),
    // Product(
    //     title: 'T-shirts',
    //     description: 'Make your look attaractive',
    //     price: 100.78,
    //     imageUrl:
    //         's',
    //     id: uuid.v4()),
    // Product(
    //     title: 'WorkOut Suit',
    //     description: 'Perfect cloth which makes your body more detailed',
    //     price: 70.78,
    //     imageUrl:
    //         'https://i5.walmartimages.com/asr/77a41731-b9f1-4a6b-9d41-38544ecbae7a_1.46193ad11bf3b7c1c353d946bc97d3f7.jpeg',
    //     id: uuid.v4()),
    // Product(
    //     title: 'Jecket',
    //     description: 'Awesome jecket',
    //     price: 70.78,
    //     imageUrl:
    //         'https://tse1.mm.bing.net/th?id=OIP.bkbG1R0etPFpSqV2PofddwHaHa&pid=Api&P=0',
    //     id: uuid.v4()),
    // Product(
    //   title: 'Jecket',
    //   description: 'Water proof Jecket.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://tse4.explicit.bing.net/th?id=OIP.YqVIvOcpG5RX2724OUbXDgHaHa&pid=Api&P=0&w=300&h=300',
    //   id: uuid.v4(),
    // ),
  ];

  final String authToken;
  final String userId;
  Products(this.authToken, this._items, this.userId);
  
  List<Product> get items {
    return _items;
  }

  

  List<Product> get favoriteItem {
    return _items.where((prodItem) => prodItem.isFavorite == true).toList();
  }


  // void get showAll{
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  // void get showFavorites{
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  Product findById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    final url = 'https://ecom-21bb9-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString';
    final favouriteUrl =
        "https://ecom-21bb9-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken";
    try {
      // fatching products
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      final Map<String, dynamic>? extractedData = jsonDecode(response.body);
      final List<Product> loadedProduct = [];

      if(extractedData == null){
        return;
      }




      // fatching favoriteStatus for specipic user
      final favouriteUri = Uri.parse(favouriteUrl);
      final favouriteResponse = await http.get(favouriteUri);
      final favouriteData = jsonDecode(favouriteResponse.body);
      
      extractedData.forEach(
        (prodId, prodData) => loadedProduct.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavorite: favouriteData == null ? false : favouriteData[prodId] ?? false,
          ),
        ),
      );
      _items = loadedProduct;
      print(response);
      notifyListeners();
      
    } catch (e) {
      print(e);
    }
  }

  Future<void> addProduct(Product product) async {
    final url = "https://ecom-21bb9-default-rtdb.firebaseio.com/products.json?auth=$authToken";
    try {
      final uri = Uri.parse(url);
      final response = await http.post(uri,
          body: jsonEncode({
            "title": product.title,
            "description": product.description,
            "imageUrl": product.imageUrl,
            "price": product.price,
            "isFvourite": product.isFavorite,
            "creatorId": userId
          }));
      final newProduct = Product(
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
          id: jsonDecode(response.body)['name']);
      _items.add(newProduct);
      notifyListeners();
    } catch (erorr) {
      print(erorr);
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async{
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = "https://ecom-21bb9-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken";
      try {
      final uri = Uri.parse(url);
      final response = await http.patch(uri,
          body: jsonEncode({
            "title": newProduct.title,
            "description": newProduct.description,
            "imageUrl": newProduct.imageUrl,
            "price": newProduct.price,
          }));
    }catch(e){
      print(e);
    }
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print(".....");
    }
  }

  // optimisting updating

  Future<void> removeProduct(String id) async{
    final url = "https://ecom-21bb9-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken";
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[prodIndex];
    _items.removeAt(prodIndex);
    notifyListeners(); 
   final response = await http.delete(Uri.parse(url));
      if(response.statusCode >= 400){
        _items.insert(prodIndex, existingProduct);
        notifyListeners();
        throw const HttpException("Could not delete product");
      }
      existingProduct = null;
    
  }
}
