import 'package:ecomapp/provider/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products.dart';

class EditingProductScreen extends StatefulWidget {
  const EditingProductScreen({super.key});
  static const routeName = "/EditingProductScreen";

  @override
  State<EditingProductScreen> createState() => _EditingProductScreenState();
}

class _EditingProductScreenState extends State<EditingProductScreen> {
  @override
  void initState() {
    _imageUrlFocuseNode.addListener(_updateUrl);
    super.initState();
  }

  final _nameFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocuseNode = FocusNode();
  final _imageUrlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  var _editedProduct =
      Product(title: '', description: '', price: 0, imageUrl: '', id: null);

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };

  var _isInit = true;
  var _isLoading = false;

  @override
  void dispose() {
    _imageUrlFocuseNode.removeListener(_updateUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocuseNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    FocusScope.of(context).requestFocus(_nameFocusNode);
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String?;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateUrl() {
    if (!_imageUrlFocuseNode.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
          (!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    setState(() {
      _isLoading = true;
    });
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id!, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (erorr) {
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text("An erorr occure"),
                  content: Text(erorr.toString()),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Okey"))
                  ],
                ));
      }
      // finally{
      //   setState(() {
      //     _isLoading = false;
      //   });
      // Navigator.of(context).pop();
      // }
    }

    setState(() {
          _isLoading = false;
        });
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Product',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _saveForm();
            },
            icon: const Icon(
              Icons.save,
            ),
            color: Colors.white,
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
            // autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: [
                  TextFormField(
                    initialValue: _initValues['title'],
                    focusNode: _nameFocusNode,
                    decoration: const InputDecoration(
                        labelText: "Title", prefixIcon: Icon(Icons.title)),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_priceFocusNode);
                    },
                    onSaved: (value) {
                      _editedProduct = Product(
                        title: value.toString(),
                        description: _editedProduct.description,
                        price: _editedProduct.price,
                        imageUrl: _editedProduct.imageUrl,
                        isFavorite: _editedProduct.isFavorite,
                        id: _editedProduct.id,
                      );
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter the title";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: _initValues['price'],
                    decoration: const InputDecoration(
                        labelText: "Price", prefixIcon: Icon(Icons.money)),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    focusNode: _priceFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode);
                    },
                    onSaved: (value) {
                      _editedProduct = Product(
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        price: double.parse(value!),
                        imageUrl: _editedProduct.imageUrl,
                        isFavorite: _editedProduct.isFavorite,
                        id: _editedProduct.id,
                      );
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please provide a price";
                      }
                      if (double.tryParse(value) == null) {
                        return "Please enter a valid number";
                      }
                      if (double.parse(value) <= 0) {
                        return "Please enter a number greater than zero.";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: _initValues['description'],
                    decoration: const InputDecoration(
                        labelText: "Description",
                        prefixIcon: Icon(Icons.description)),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    focusNode: _descriptionFocusNode,
                    onSaved: (value) {
                      _editedProduct = Product(
                        title: _editedProduct.title,
                        description: value.toString(),
                        price: _editedProduct.price,
                        imageUrl: _editedProduct.imageUrl,
                        isFavorite: _editedProduct.isFavorite,
                        id: _editedProduct.id,
                      );
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please provide a description.";
                      }
                      if (value.toString().length < 10) {
                        return "Should be atleast 10 character long.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.grey)),
                        child: _imageUrlController.text.isEmpty
                            ? const Center(
                                child: Text(
                                "Enter URL",
                                style: TextStyle(color: Colors.grey),
                              ))
                            : Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _imageUrlController,
                          decoration: const InputDecoration(
                              labelText: "ImageUrl",
                              prefixIcon: Icon(Icons.image)),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.url,
                          focusNode: _imageUrlFocuseNode,
                          onFieldSubmitted: (_) {
                            _saveForm();
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              imageUrl: value.toString(),
                              isFavorite: _editedProduct.isFavorite,
                              id: _editedProduct.id,
                            );
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter a image url";
                            }
                            if (!value.startsWith("http") &&
                                !value.startsWith("https")) {
                              return 'Please enter a valid URL';
                            }
                            if (!value.endsWith('.png') &&
                                !value.endsWith('.jpg') &&
                                !value.endsWith('.jpeg')) {
                              return 'Please enter a valid image URL.';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  )
                ],
              )),
    );
  }
}
