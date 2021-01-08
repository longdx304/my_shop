import 'package:flutter/material.dart';

class EditedProduct {
  String title;
  String description;
  double price;
  String imageUrl;

  EditedProduct({
    this.title,
    this.description,
    this.price,
    this.imageUrl,
  });
}

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit_product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _editedProduct = EditedProduct(
    title: '',
    price: 0.0,
    description: '',
    imageUrl: '',
  );

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http://') &&
              !_imageUrlController.text.startsWith('https://')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('jpeg'))) return;
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _formKey.currentState.validate();
    if (!isValid) return;
    _formKey.currentState.save();
    print(_editedProduct.title);
    print(_editedProduct.price);
    print(_editedProduct.description);
    print(_editedProduct.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveForm(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          autovalidateMode: AutovalidateMode.always,
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  validator: (editedTitle) {
                    if (editedTitle.isEmpty) return 'Please provide a title';
                    return null;
                  },
                  onSaved: (editedTitle) => _editedProduct.title = editedTitle,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  validator: (editedPrice) {
                    if (editedPrice.isEmpty) return 'Please enter a price';
                    if (double.tryParse(editedPrice) == null)
                      return 'Please enter a valid number';
                    if (double.parse(editedPrice) <= 0)
                      return 'Please enter a number greater than 0';
                    return null;
                  },
                  onSaved: (editedPrice) =>
                      _editedProduct.price = double.parse(editedPrice),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  validator: (editedDescription) {
                    if (editedDescription.isEmpty)
                      return 'Please enter a description';
                    return null;
                  },
                  onSaved: (editedDescription) =>
                      _editedProduct.description = editedDescription,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: 8,
                        right: 10,
                      ),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? Text('Enter a URL')
                          : FittedBox(
                              child: Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        validator: (editedImageUrl) {
                          if (editedImageUrl.isEmpty)
                            return 'Please enter an image Url';
                          if ((!editedImageUrl.startsWith('http://') &&
                                  !editedImageUrl.startsWith('https://')) ||
                              (!editedImageUrl.endsWith('.png') &&
                                  !editedImageUrl.endsWith('.jpg') &&
                                  !editedImageUrl.endsWith('jpeg')))
                            return 'Please enter a valid Url';
                          return null;
                        },
                        onFieldSubmitted: (value) => _saveForm(),
                        onSaved: (editedImageUrl) =>
                            _editedProduct.imageUrl = editedImageUrl,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
