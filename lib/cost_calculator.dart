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


                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product),
                                  ),
                                );
                              },
                            ),

                          );
                        },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}




class AddProductCostScreen extends StatefulWidget{
  cosnt AddProductCostScreen({super.key});


  @override
  State<AddProductCostScreen> createState()=> AddProductCostScreenState();
}


class AddProductCostScreenState extends State<AddProductCostScreen>{
  static const primaryColor = color(0xFF15966A);


  //each new costing start with fresh text field
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController totalQuantityController = TextEditingController();


  //No previous cost show in the screen
  List<CostElement> costElements = [];


  double get totalCost{
    double sum = 0.0;

    for(var element in costElements){
      sum += element.amount;
    }
    return sum;
  }


  double get costPerPis{
    int totalQty = int.tryParse(totalQuantityController.text) ?? 0;

    return totalQty > 0 ? (totalCost / totalQty) : 0.0;
  }


  void addCostElementDialog(){
    final nameController = TextEditingController();
    final amountController = TextEditingController();


    showDialog(
      context: context,
      builder: (ctx){

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),

          title: const Text("Add Cost Item", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              TextField(
                controller: productNameController,
                textCapitalization: TextCapitalization.sentences,

                decoration: InputDecoration(
                  labelText: "Element Name",
                  hintText: "e.g Febric , Button , Printing",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: "Total Cost (BDT)",
                  prefixText: "৳",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),

          actions: [
            TextButton(
                onPressed: ()=> Navigator.pop(ctx),
                child: const Text("Cancel" , style: TextStyle(color: Colors.grey)),
            ),

            ElevatedButton(

                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: (){
                  if(nameController.text.isNotEmpty){
                    final amount = double.tryParse(amountController.text) ?? 0.0;

                    setState(() {
                      costElements.add(CostElement(name: nameController.text.trim(), amount: amount));
                    });

                    Navigator.pop(ctx);
                  }
                },
                child: const Text("Add" , style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }


  void removeCostElement(int index){
    setState(() {
      costElements[index].controller.dispose();
      costElements.removeAt(index);
    });
  }


  @override
  Widget build(BuildContext context){

    return Scaffold(
      backgroundColor: Colors.grey.shade50,

      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0.5,
        title: const Text(
          "Cost Calculator",
          style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),

      body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade200),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const Text(
                        "Product Information",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                      )
                    ],
                  )
                )
              ],
            )
          )
      )

    );
  }


}










