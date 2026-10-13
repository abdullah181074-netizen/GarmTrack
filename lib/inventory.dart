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


  void addNewProduct(String name, String size, String category , int store , int godown , int factory){
    setState(() {
      InventoryList.add(
        InventoryItem(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: name,
            size: size.isEmpty ? 'N/A' :size,
            category: category,
            storeQty: store,
            godownQty: godown,
            factoryQtyy: factory,
        ),
      );
    });
  }


  bool transferStock(InventoryItem item , String from , String to , int amount){

    if(amount <= 0)
      return false;

    int sourceQty = 0;

    if(from == 'Store')
      sourceQty = item.storeQty;
    if(from == 'Godown')
      sourceQty = item.godownQty;
    if(from == 'Factory')
      sourceQty = item.factoryQtyy;


    if(sourceQty < amount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Insufficient stock in $from! Available: $sourceQty'),
            backgroundColor: Colors.red,
        ),
      );
      return false;
    }


    setState(() {

      //deduct from source

      if(from == 'Store')
        item.storeQty -= amount;

      if(from == 'Godown')
        item.godownQty -= amount;

      if(from == 'Factory')
        item.factoryQtyy -= amount;


      //add to destination

      if(to == 'Store')
        item.storeQty += amount;

      if(to == 'Godown')
        item.godownQty += amount;

      if(to == 'Factory')
        item.factoryQtyy += amount;

    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Transferred $amount Dozen of ${item.name} (${item.size}) to $to!'),
          backgroundColor: const Color(0xFF15966A),
      ),
    );
    return true;
  }




  @override
  Widget build(BuildContext context){

    const primaryColor = Color(0xFF15966A);

    return Scaffold(

      backgroundColor: Colors.grey.shade50,

      floatingActionButton: FloatingActionButton.extended(
          onPressed: ()=> showAddProductDialog(context),    //not add yet
          backgroundColor: primaryColor,
          elevation: 3,
          icon: const Icon(Icons.add, color: Colors.white, size: 20),
          label: const Text(
            "Add Product",
            style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold, fontSize: 13),
          ),
      ),


      body: SafeArea(
          child: Column(
            children: [

              //Search and section filter bar

              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16.0),

                child: Column(
                  children: [
                    TextField(
                      onChanged: (val) => setState(()=> searchQuery = val),

                      decoration: InputDecoration(
                        hintText: "Search name or size...",
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),


                        prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),

                        filled: true,
                        fillColor: Colors.grey.shade100,

                        contentPadding: const EdgeInsets.symmetric(vertical: 0),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: primaryColor ,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),



                    const SizedBox(height: 12),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [


                        //not add yet

                      ],
                    ),
                  ],
                ),
              ),




              const Divider(height: 1, color: Colors.black12),

              Expanded(
                  child: FilteredItems.isEmpty
                      ? Center(
                    child: Text(
                      "No items found for $selectedSedtion",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  )
                      : ListView.builder(


                      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
                      itemCount: FilteredItems.length,
                      itemBuilder: (context , index){
                        final item = FilteredItems[index];
                        return buildInventoryCard(item , primaryColor);
                      },
                  ),
              ),
            ],
          ),
      ),

    );
  }










}
