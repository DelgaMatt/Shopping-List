import 'package:flutter/material.dart';
import 'package:shopping/data/categories.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a new item')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                //should be text form field bc it's integrated with the Form parent widget
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Name'),
                ),
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
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration:
                          const InputDecoration(label: Text('Quantity')),
                      initialValue: '1',
                      validator: (value) {
                  //another property given to us by using the form widget
                  if (value == null ||
                      value.isEmpty ||
                      int.tryParse(value) == null ||//then we know its not a valid number
                      int.tryParse(value)! <= 0) { 
                    return 'Must be a valid positive number';
                  }
                  return null;
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
                        onChanged: (value) {}),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () {}, child: const Text('Reset')),
                  const SizedBox(
                    width: 8,
                  ),
                  ElevatedButton(
                      onPressed: () {}, child: const Text('Add Item'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
