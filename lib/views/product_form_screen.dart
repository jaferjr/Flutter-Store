import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/product.dart';

class ProducFormScreen extends StatefulWidget {
  @override
  _ProducFormScreenState createState() => _ProducFormScreenState();
}

class _ProducFormScreenState extends State<ProducFormScreen> {
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _imageFocusNode = FocusNode();
  final _imageUrlCtl = TextEditingController();
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  var _formData = Map<String, Object>();

  @override
  void initState() {
    super.initState();
    _imageFocusNode.addListener(_updateImage);
  }

  void _updateImage() {
    setState(() {});
  }

  void _saveForm() async {
    bool _isFormVaid = _formKey.currentState.validate();

    if (!_isFormVaid) return;

    _formKey.currentState.save();

    final product = Product(
      id: _formData['id'],
      description: _formData['description'],
      price: _formData['price'],
      title: _formData['title'],
      imageUrl: _formData['imageUrl'],
    );
    setState(() {
      _isLoading = true;
    });

    final products = Provider.of<Products>(context, listen: false);
    try {
      if (_formData['id'] == null) {
        products.addProduct(product);
      } else {
        products.updateProduct(product);
      }
      Navigator.of(context).pop();
    } catch (error) {
      showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('OCORREU UM ERRO'),
                content: Text('O servidor retornou um erro'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final product = ModalRoute.of(context).settings.arguments as Product;
      if (product != null) {
        _formData['id'] = product.id;
        _formData['description'] = product.description;
        _formData['price'] = product.price;
        _formData['title'] = product.title;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlCtl.text = _formData['imageUrl'];
      } else {
        _formData['price'] = '';
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageFocusNode.removeListener(_updateImage);
    _imageFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário Produto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _formData['title'],
                      onSaved: (value) => _formData['title'] = value,
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'O campo não pode ser vazio';
                        }
                        if (value.trim().length < 3) {
                          return 'o campo não pode ser menor que 3 caracteres';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Título',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['price'].toString(),
                      onSaved: (value) =>
                          _formData['price'] = double.parse(value),
                      decoration: InputDecoration(
                        labelText: 'Preço',
                      ),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      focusNode: _priceFocusNode,
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'O campo não pode ser vazio';
                        }
                        if (value.trim().length < 3) {
                          return 'o campo não pode ser menor que 3 caracteres';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['description'],
                      onSaved: (value) => _formData['description'] = value,
                      decoration: InputDecoration(
                        labelText: 'Descrição',
                      ),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_imageFocusNode);
                      },
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'O campo não pode ser vazio';
                        }
                        if (value.trim().length < 3) {
                          return 'o campo não pode ser menor que 3 caracteres';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            onSaved: (value) => _formData['imageUrl'] = value,
                            decoration:
                                InputDecoration(labelText: 'URL da Imagem'),
                            keyboardType: TextInputType.url,
                            focusNode: _imageFocusNode,
                            controller: _imageUrlCtl,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10, top: 8),
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          alignment: AlignmentDirectional.center,
                          child: _imageUrlCtl.text.isEmpty
                              ? Text('Informe a URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlCtl.text,
                                    width: 100,
                                    height: 100,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
