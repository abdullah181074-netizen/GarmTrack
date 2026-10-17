import 'package:flutter/material.dart';

class CostElement{
  String name;
  //String size;
  double amount;
  late TextEditingController controller;

  CostElement({required this.name ,required this.amount}){
    controller = TextEditingController(text: amount > 0 ? amount.toStringAsFixed(0): '');
  }
}



class SavedProductCost{
  final String id;
  final String productName;
  final int totalQuantity;
  final double totalCost;
  final double costPerPis;
  final List<CostElement> costBreakdown;


  SavedProductCost({
    required this.id,
    required this.productName,
    required this.totalQuantity,
    required this.totalCost,
    required this.costPerPis,
    required this.costBreakdown,
});
}


//list to store saved product across screen
List<SavedProductCost> globalSavedProducts = [];



//void main()












