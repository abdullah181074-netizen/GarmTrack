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

    final filteredProducts = globalSavedProducts.where((product){
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
                                  borderRadius: BorderRadius.circular(8),
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
  const AddProductCostScreen({super.key});


  @override
  State<AddProductCostScreen> createState()=> AddProductCostScreenState();
}


class AddProductCostScreenState extends State<AddProductCostScreen>{
  static const primaryColor = Color(0xFF15966A);


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
                controller: nameController,
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
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          "Cost Calculator",
          style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller: productNameController,
                        decoration: InputDecoration(
                          labelText: "Product Name",
                          filled: true,
                          fillColor: Colors.grey.shade50,

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller: totalQuantityController,
                        keyboardType: TextInputType.number,

                        onChanged: (val) => setState(() {}),

                        decoration: InputDecoration(
                          labelText: "Total Quantity (Pcs)",

                          filled: true,
                          fillColor: Colors.grey.shade50,

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),



                const SizedBox(height: 20),

                //cost Breakdown

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [

                    const Text(
                        "Cost BreakDown",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                    ),

                    OutlinedButton.icon(

                        style: OutlinedButton.styleFrom(
                          foregroundColor: primaryColor,
                          side: BorderSide(color: primaryColor.withOpacity(0.4)),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(8),
                          ),

                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        ),

                        onPressed: addCostElementDialog,
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text("Add Cost Item" , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ],
                ),


                const SizedBox(height: 10),


                //Dynamic cost List

                if(costElements.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade200),
                  ),

                  child: Center(
                    child: Text("No cost items added yet. Tap '+ Add Cost Item' to start.",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                    ),
                  ),
                )

                else
                  ListView.builder(

                      shrinkWrap: true,

                      physics: const NeverScrollableScrollPhysics(),

                      itemCount: costElements.length,
                      itemBuilder: (context, index){

                        final item = costElements[index];

                        return Container(
                          key: ValueKey(item),

                          margin: const EdgeInsets.only(bottom: 8),

                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),

                          decoration: BoxDecoration(
                            color: Colors.white,

                            borderRadius: BorderRadius.circular(12),

                            border: Border.all(color: Colors.grey.shade200),
                          ),

                          child: Row(

                            children: [
                              Expanded(
                                  flex: 3,
                                  child: Text(
                                    item.name,
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                  ),
                              ),

                              Expanded(
                                  flex: 1,
                                  child: TextField(
                                    controller: item.controller,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    textAlign: TextAlign.right,

                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),

                                    decoration: const InputDecoration(
                                      prefixText: "৳ ",
                                      border: InputBorder.none,
                                      isDense: true,
                                    ),

                                    onChanged: (val){
                                      setState(() {
                                        item.amount = double.tryParse(val) ?? 0.0;
                                      });
                                    },
                                  ),
                              ),

                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                onPressed: ()=> removeCostElement(index),
                              ),

                            ],
                          ),
                        );
                      },
                  ),


                const SizedBox(height: 24),

                Container(
                  padding: const EdgeInsets.all(18),

                  decoration: BoxDecoration(
                    color: const Color(0xFFDDF5E8),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: primaryColor.withOpacity(0.3)),
                  ),

                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Text(
                            "Total Manufacturing Cost: ",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),


                          Text(
                            "৳ ${totalCost.toStringAsFixed(2)}",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                        ],
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Divider(color: Colors.grey, height: 1),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [

                          const Text(
                            "Cost Per Pcs: ",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: primaryColor),
                          ),

                          Text(
                            "৳ ${costPerPis.toStringAsFixed(2)}",
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),


                const SizedBox(height: 20),


                //save Button

                SizedBox(
                  width: double.infinity,
                  height: 50,

                  child: ElevatedButton.icon(

                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      onPressed: (){
                        if(productNameController.text.trim().isEmpty){
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please Enter a product Name !'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }


                        final newSavedProduct = SavedProductCost(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            productName: productNameController.text.trim(),
                            totalQuantity: int.tryParse(totalQuantityController.text) ??1 ,
                            totalCost: totalCost,
                            costPerPis: costPerPis,
                            costBreakdown: List.from(costElements),
                        );


                        globalSavedProducts.add(newSavedProduct);
                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("Successfully saved cost for '${productNameController.text} !"),
                              backgroundColor: primaryColor,
                          ),
                        );
                      },
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: const Text(
                        "Save",
                        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                  ),
                )







              ],
            )
          )
      )

    );
  }
}



class ProductDetailScreen extends StatelessWidget {
  final SavedProductCost product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF15966A);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          product.productName,
          style: const TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFDDF5E8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: primaryColor.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total Production Qty:", style: TextStyle(fontWeight: FontWeight.w500)),
                        Text("${product.totalQuantity} Pcs", style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total Cost:", style: TextStyle(fontWeight: FontWeight.w500)),
                        Text("৳ ${product.totalCost.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Cost Per Piece:", style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
                        Text("৳ ${product.costPerPis.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: primaryColor)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Cost Breakdown Details",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: product.costBreakdown.length,
                itemBuilder: (context, index) {
                  final item = product.costBreakdown[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        Text("৳ ${item.amount.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
