import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shopping/data/categories.dart';
import 'package:shopping/models/category.dart';
import 'package:shopping/models/grocery_item_model.dart';
// import 'package:shopping/models/grocery_item_model.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<
      FormState>(); //if the build widget is executed again, the form widget will not be rebuilt and will keep it's internal state. which is what will communicate to flutter if it needs to display some validator messaging or not.
  var _enteredName = '';
  var _enteredQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables]!;
  var _isSending = false;

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      //will trigger the 'onSaved' function
      setState(() {
        _isSending = true;
      });
      final url = Uri.https(
          'flutter-shopping-list-4d113-default-rtdb.firebaseio.com',
          'shopping-list.json'); //creating a url
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'name': _enteredName,
            'quantity': _enteredQuantity,
            'category': _selectedCategory.title,
          },
        ),
      );

      final Map<String, dynamic> resData = json.decode(response.body);

      if (!context.mounted) {
        return;
      }

      Navigator.of(context).pop(GroceryItem(
          id: resData['name'],
          name: _enteredName,
          quantity: _enteredQuantity,
          category:
              _selectedCategory)); //popping screen once the request is recieved
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a new item')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                //should be text form field bc it's integrated with the Form parent widget
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Name'),
                ),
                initialValue: _enteredName,
                validator: (value) {
                  //another property given to us by using the form widget
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 and 50 characters.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredName = value!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration:
                          const InputDecoration(label: Text('Quantity')),
                      keyboardType: TextInputType.number,
                      initialValue: _enteredQuantity.toString(),
                      validator: (value) {
                        //another property given to us by using the form widget
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) ==
                                null || //then we know its not a valid number
                            int.tryParse(value)! <= 0) {
                          return 'Must be a valid positive number';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredQuantity = int.parse(value!);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      //selected item will be stored in ui - feature of the form
                      //form specific version thats supported by forms
                      value: _selectedCategory,
                      items: [
                        for (final category in categories
                            .entries) //dummy data is a map, so we add .entries which returns every item in list
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(children: [
                              Container(
                                  width: 16,
                                  height: 16,
                                  color: category.value.color),
                              const SizedBox(width: 6),
                              Text(category.value
                                  .title) //here we are iteratiing through the list via the .entries method
                            ]),
                          )
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: _isSending ? null : () {
                        _formKey.currentState!.reset();
                      },
                      child: const Text('Reset')),
                  const SizedBox(
                    width: 8,
                  ),
                  ElevatedButton(
                      onPressed: _isSending ? null : _saveItem, 
                      child: _isSending ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(),) : const Text('Add Item'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
