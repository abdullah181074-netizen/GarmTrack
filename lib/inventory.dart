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



class InventoryScreen extends StatefulWidget{

  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState()=> InventoryScreenState();
}

class InventoryScreenState extends State<InventoryScreen>{

  String selectedSedtion = 'All';
  String searchQuery = '';



  List<InventoryItem> inventoryList = [];


  List<InventoryItem> get FilteredItems{
    return inventoryList.where((item){
      final matchesSearch = item.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
        item.size.toLowerCase().contains(searchQuery.toLowerCase());


      if(!matchesSearch)
        return false;


      if(selectedSedtion == 'Store') return item.storeQty > 0;
      if(selectedSedtion == 'Godown') return item.godownQty > 0;
      if(selectedSedtion == 'Factory') return item.factoryQtyy > 0;

      return true;

    }).toList();
  }


  void addNewProduct(String name, String size, String category , int store , int godown , int factory)

}
