import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_shop/model/product.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({Key? key}) : super(key: key);

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final _formData = Map<String, Object>();

  @override
  void initState() {
    _imageUrlFocus.addListener(updateImage);
    super.initState();
  }

  @override
  void dispose() {
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageUrlFocus.removeListener(updateImage);
    _imageUrlFocus.dispose();
    super.dispose();
  }

  void updateImage() {
    setState(() {});
    print('update Image...');
  }

  void _submitForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    _formKey.currentState?.save();
    final newProduct = Product(
      id: Random().nextDouble().toString(),
      name: _formData['name'] as String,
      description: _formData['description'] as String,
      imageUrl: _formData['imageUrl'] as String,
      price: _formData['price'] as double,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Produto'),
        actions: [
          IconButton(
            onPressed: _submitForm,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_priceFocus),
                onSaved: (name) => _formData['name'] = name ?? '',
                validator: (_name) {
                  final name = _name ?? '';
                  if (name.trim().isEmpty) {
                    return 'Nome é Obrigatório.';
                  }
                  if (name.trim().length < 3) {
                    return 'Nome precisa no mínimo de 3 letras.';
                  }
                  return null;
                },
              ),
              TextFormField(
                focusNode: _priceFocus,
                decoration: InputDecoration(labelText: 'Preço'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_descriptionFocus),
                onSaved: (price) => _formData['price'] = double.parse(price ?? '0'),
              ),
              TextFormField(
                focusNode: _descriptionFocus,
                decoration: InputDecoration(labelText: 'Descrição'),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                onSaved: (description) => _formData['description'] = description ?? '',
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      focusNode: _imageUrlFocus,
                      decoration: InputDecoration(labelText: 'Url da Imagem'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      onFieldSubmitted: (_) => _submitForm(),
                      onSaved: (imageUrl) => _formData['imageUrl'] = imageUrl ?? '',
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, left: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    // alignment: Alignment.center,
                    child: _imageUrlController.text.isEmpty
                        ? Center(child: Text('Informe a Url'))
                        : Image.network(
                            _imageUrlController.text,
                            fit: BoxFit.cover,
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
