import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:shop_app/provider/product_list_provider.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _urlImagemFocus = FocusNode();

  final _urlImagemController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final Map<String, Object> formData = {};

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _urlImagemFocus.addListener(updateImage);
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _urlImagemFocus.removeListener(updateImage);
    _urlImagemController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg != null) {
        ProductModel productModel = arg as ProductModel;

        formData['id'] = productModel.id;
        formData['title'] = productModel.title;
        formData['description'] = productModel.description;
        formData['price'] = productModel.price;
        formData['imageUrl'] = productModel.imageUrl;

        _urlImagemController.text = productModel.imageUrl;
      }
    }
  }

  updateImage() {
    setState(() {});
  }

  bool _isValidateUrl(String url) {
    bool isValidate = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool endsWithFileExtensions = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg');

    return isValidate && endsWithFileExtensions;
  }

  _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    setState(() => isLoading = true);

    try {
      await Provider.of<ProductListProvider>(context, listen: false)
          .saveProduct(formData);
      Navigator.of(context).pop();
    } catch (e) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Ocorreu um erro!'),
            content: const Text('Ocorreu um erro para salvar o produto.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              )
            ],
          );
        },
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Formulário do Produto'),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: formData['title']?.toString(),
                        decoration: const InputDecoration(
                          label: Text('Nome'),
                          border: OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_priceFocus),
                        validator: (nome) {
                          String value = nome ?? '';
                          if (value.trim().isEmpty) {
                            return 'O campo nome é obrigatório!';
                          }
                          if (value.length < 3) {
                            return 'O campo nome deve possuir no mínimo 3 caracteres!';
                          }
                          return null;
                        },
                        onSaved: (newValue) =>
                            formData['title'] = newValue ?? '',
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: formData['price'] != null
                            ? double.tryParse(formData['price'].toString())!
                                .toStringAsFixed(2)
                            : '',
                        decoration: const InputDecoration(
                          label: Text('Preço'),
                          border: OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.next,
                        focusNode: _priceFocus,
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_descriptionFocus),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (value) {
                          String priceString = value ?? '';
                          double price = double.tryParse(
                                  priceString.replaceAll(',', '.')) ??
                              0;
                          if (price < 1) {
                            return 'O preço deve ser maior que 0';
                          }
                          return null;
                        },
                        onSaved: (newValue) =>
                            formData['price'] = newValue ?? '',
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: formData['description']?.toString(),
                        decoration: const InputDecoration(
                          label: Text('Descrição'),
                          border: OutlineInputBorder(),
                        ),
                        focusNode: _descriptionFocus,
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_urlImagemFocus),
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        validator: (value) {
                          String description = value ?? '';
                          if (description.trim().isEmpty) {
                            return 'O campo descrição é obrigatório!';
                          }
                          if (description.length < 10) {
                            return 'O campo descrição deve conter no mínimo 10 caracteres!';
                          }
                          return null;
                        },
                        onSaved: (newValue) =>
                            formData['description'] = newValue ?? '',
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _urlImagemController,
                              decoration: const InputDecoration(
                                label: Text('Url da Imagem'),
                                border: OutlineInputBorder(),
                              ),
                              focusNode: _urlImagemFocus,
                              keyboardType: TextInputType.url,
                              validator: (value) {
                                String imageUrl = value ?? '';

                                if (!_isValidateUrl(imageUrl)) {
                                  return 'Informar uma Url válida!';
                                }

                                return null;
                              },
                              onSaved: (newValue) =>
                                  formData['imageUrl'] = newValue ?? '',
                              onFieldSubmitted: (value) {
                                _submitForm();
                              },
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 100,
                            height: 100,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            child: _urlImagemController.text.isEmpty
                                ? const Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Text(
                                      'Informe a url da imagem.',
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : Image.network(
                                    _urlImagemController.text,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.error);
                                    },
                                  ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save),
                            Text('Salvar'),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
