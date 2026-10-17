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


//main list screen with search and cost button

class PrductCostListScreen extends StatefulWidget{

  const PrductCostListScreen({super.key});

  @override
  State<PrductCostListScreen> createState()=> ProductCostListScreenState();
}

class ProductCostListScreenState extends State<PrductCostListScreen>{

  static const primaryColor = Color(0xFF15966A);
  String searchQuery = '';

  @override
  Widget build(BuildContext context){

    final filteredProducts = globalSavedProducts.where((Product){
      return product.productName.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: ()async{
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddProductCostScreen()),
            );
            setState(() {
              //refresh list upon return
            });
          },
          backgroundColor: primaryColor,
          icon: Icon(Icons.add, color: Colors.white),
          label: const Text("New Costing", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),



    )
  }
}










