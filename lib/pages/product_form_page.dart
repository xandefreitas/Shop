import 'package:flutter/material.dart';
import 'package:flutter_shop/model/product.dart';
import 'package:flutter_shop/model/product_list.dart';
import 'package:provider/provider.dart';

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

  final _formData = <String, Object>{};

  bool isLoading = false;

  @override
  void initState() {
    _imageUrlFocus.addListener(updateImage);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_formData.isEmpty) {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      if (arguments != null) {
        final product = arguments as Product;
        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['price'] = product.price;
        _formData['description'] = product.description;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = product.imageUrl;
      }
    }
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
  }

  void _submitForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    _formKey.currentState?.save();
    setState(() => isLoading = true);
    Provider.of<ProductList>(context, listen: false).saveProduct(_formData).then((value) {
      setState(() => isLoading = false);
      Navigator.pop(context);
    });
  }

  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool endsWithFile = url.toLowerCase().endsWith('.png') || url.toLowerCase().endsWith('.jpg') || url.toLowerCase().endsWith('.jpeg');
    return isValidUrl && endsWithFile;
  }

  textFieldValidator(String text, int minLength) {
    if (text.trim().isEmpty) {
      return 'Campo Obrigatório.';
    }
    if (text.trim().length < minLength) {
      return 'Campo precisa no mínimo de $minLength caracteres.';
    }
    return null;
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Nome'),
                      textInputAction: TextInputAction.next,
                      initialValue: _formData['name']?.toString(),
                      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_priceFocus),
                      onSaved: (name) => _formData['name'] = name ?? '',
                      validator: (_name) => textFieldValidator(_name ?? '', 3),
                    ),
                    TextFormField(
                      focusNode: _priceFocus,
                      decoration: InputDecoration(labelText: 'Preço'),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      textInputAction: TextInputAction.next,
                      initialValue: _formData['price']?.toString(),
                      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_descriptionFocus),
                      onSaved: (price) => _formData['price'] = double.parse(price ?? '0'),
                      validator: (_price) {
                        final priceString = _price ?? '-1';
                        final price = double.tryParse(priceString) ?? -1;

                        if (price <= 0) {
                          return 'Informe um preço válido.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      focusNode: _descriptionFocus,
                      decoration: InputDecoration(labelText: 'Descrição'),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      initialValue: _formData['description']?.toString(),
                      onSaved: (description) => _formData['description'] = description ?? '',
                      validator: (_description) => textFieldValidator(_description ?? '', 10),
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
                            validator: (_imageUrl) {
                              final imageUrl = _imageUrl ?? '';
                              if (!isValidImageUrl(imageUrl)) {
                                return 'Informe uma Url válida!';
                              }
                              return null;
                            },
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
