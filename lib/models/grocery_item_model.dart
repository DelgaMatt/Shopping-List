import 'package:shopping/models/category_model.dart';

class GroceryItem {
  const GroceryItem(
      {required this.id,
      required this.name,
      required this.quantity,
      required this.category}
  );

  final String id;
  final String name;
  final int quantity;
  final String category;
}
