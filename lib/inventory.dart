import 'package:flutter/material.dart';


class InventoryItem{

  final String id;
  final String name;
  final String size;
  final String category;

  int storeQty;
  int godownQty;
  int factoryQtyy;


  InventoryItem({
    required this.id,
    required this.name,
    required this.size,
    required this.category,
    required this.storeQty,
    required this.godownQty,
    required this.factoryQtyy,
});

  int get totalQty => storeQty + godownQty + factoryQtyy;
}




