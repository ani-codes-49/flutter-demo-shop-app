import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';

import '../providers/Product.dart';

class AddProducts extends StatefulWidget {
  static const routeName = '/AddProducts';

  @override
  _AddProductsState createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: '',
    title: '',
    price: 0,
    imageUrl: '',
    description: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlController.addListener(updateImage);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (ModalRoute.of(context)!.settings.arguments == null) {
        return;
      } else {
        _editedProduct = ModalRoute.of(context)!.settings.arguments as Product;
      }

      _initValues = {
        'title': _editedProduct.title,
        'description': _editedProduct.description,
        'price': _editedProduct.price.toString(),
        //'imageUrl': _editedProduct.imageUrl,
      };
      _imageUrlController.text = _editedProduct.imageUrl;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlController.removeListener(updateImage);
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void updateImage() {
    if (!_imageUrlFocusNode.hasFocus ||
        _imageUrlController.text.isEmpty ||
        _imageUrlController.text.startsWith('http') ||
        _imageUrlController.text.startsWith('https') ||
        _imageUrlController.text.endsWith('.png') ||
        _imageUrlController.text.endsWith('.jpg') ||
        _imageUrlController.text.endsWith('.jpeg')) {
      setState(() {});
    }
  }

  Future<void> saveForm() async {
    final isValid = _form.currentState!.validate();
    if (isValid == false) {
      return;
    }
    _form.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    if (_editedProduct.id == '') {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProducts(_editedProduct);

        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product added'),
          ),
        );
      } catch (error) {
        await showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: const Text('An error occured'),
                content: const Text('Something went wrong.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(_).pop();
                    },
                    child: const Text('Okay'),
                  ),
                ],
              );
            });
      }
    } else {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      setState(() {});
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product added'),
        ),
      );
      Navigator.of(context).pop();
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add an item'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues['title'],
                      autocorrect: true,
                      decoration: const InputDecoration(
                        labelText: 'Product Name',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter a valid title';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      onSaved: (value) => _editedProduct = Product(
                        isFavorite: _editedProduct.isFavorite,
                        id: _editedProduct.id,
                        title: value!,
                        description: _editedProduct.description,
                        price: _editedProduct.price,
                        imageUrl: _editedProduct.imageUrl,
                      ),
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      autocorrect: true,
                      decoration: const InputDecoration(
                        labelText: 'Price',
                      ),
                      validator: (value) {
                        if (value!.isEmpty ||
                            double.tryParse(value) == null ||
                            double.parse(value) <= 0) {
                          return 'Enter a valid price';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      onSaved: (value) => _editedProduct = Product(
                        isFavorite: _editedProduct.isFavorite,
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        price: double.parse(value!),
                        imageUrl: _editedProduct.imageUrl,
                      ),
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      autocorrect: true,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter a valid description';
                        } else if (value.length < 10) {
                          return 'Please enter description greater than 10 words';
                        }
                        return null;
                      },
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.next,
                      onSaved: (value) => _editedProduct = Product(
                        isFavorite: _editedProduct.isFavorite,
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        description: value!,
                        price: _editedProduct.price,
                        imageUrl: _editedProduct.imageUrl,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(
                            right: 8.0,
                            top: 10.0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? const Center(
                                  child: Text('Enter an Url'),
                                )
                              : _imageUrlController.text.startsWith('http') ||
                                      _imageUrlController.text
                                          .startsWith('https') ||
                                      _imageUrlController.text
                                          .endsWith('.png') ||
                                      _imageUrlController.text
                                          .endsWith('.jpg') ||
                                      _imageUrlController.text.endsWith('.jpeg')
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Image.network(
                                        _imageUrlController.text,
                                        fit: BoxFit.fill,
                                      ),
                                    )
                                  : const Center(
                                      child: Text('Enter a valid Url'),
                                    ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              label: Text('Image URL'),
                            ),
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onSaved: (value) => _editedProduct = Product(
                              isFavorite: _editedProduct.isFavorite,
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              imageUrl: value!,
                            ),
                            validator: (value) {
                              if (value!.isNotEmpty ||
                                  value.startsWith('http') ||
                                  value.startsWith('https') ||
                                  value.endsWith('.png') ||
                                  value.endsWith('.jpg') ||
                                  value.endsWith('.jpeg')) {
                                return null;
                              } else {
                                return 'Enter a valid url';
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.only(
                        top: 20.0,
                        left: 5.0,
                        right: 5.0,
                      ),
                      child: ElevatedButton(
                        child: const Text('Add Product'),
                        onPressed: () => saveForm(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
