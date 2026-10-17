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



      body: SafeArea(
        child: Column(
          children: [

            //searchBar Container

            Container(
              color: Colors.white,

              padding: const EdgeInsets.all(16.0),

              child: TextField(
                onChanged: (val) => setState(()=> searchQuery = val),
                decoration: InputDecoration(
                  hintText: "Search Product...",
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
                    borderSide: const BorderSide(color: primaryColor, width: 1.5),

                  ),
              ),
             ),
            ),

            const Divider(height: 1, color: Colors.black12),

            //Saved Product list

            Expanded(
                child: filteredProducts.isEmpty ? Center(
                  child: Text(
                    "No Product Cost Found",

                    style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                  ),
                ):
                    ListView.builder(

                        padding: const EdgeInsets.all(16),

                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index){
                          final product = filteredProducts[index];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.grey.shade200),

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),


                            child: ListTile(
                              contentPadding: const EdgeInsets.only(top: 6.0),

                              title: Text(
                                product.productName,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
                              ),

                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 6),

                                child: Text(
                                  "Quantity: ${product.totalQuantity} pcs",
                                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                                ),
                              ),

                              trailing: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDDF5E8),
                                  borderRadius: BorderRadius.circular(8)k
                                ),

                                child: Text(
                                  "Cost Per Pis: ৳${product.costPerPis.toStringAsFixed(1)}",
                                  style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ),




                            )

                          )
                        }
                    )
            )

          ],
        ),
      )



    );
  }
}










