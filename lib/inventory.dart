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

                        buildTabButton("All", primaryColor),
                        buildTabButton("Store", primaryColor),
                        buildTabButton("Godown", primaryColor),
                        buildTabButton("Factory", primaryColor),

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


  Widget buildTabButton(String label , Color primaryColor){

    final isSelected = selectedSedtion == label;

    return Expanded(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),

            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected ? primaryColor : Colors.grey.shade100,
                foregroundColor: isSelected ? Colors.white : Colors.black87,
                elevation: 0,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),

              onPressed: ()=> setState(()=> selectedSedtion = label),

              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
        ),
    );
  }


  Widget buildInventoryCard(InventoryItem item , Color primaryColor){

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),

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

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [

              Row(

                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(width: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),

                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,

                      borderRadius: BorderRadius.circular(6),
                    ),

                    child: Text(
                      "Size: ${item.size}",
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),



              //total badge shown on 'all' tab

              if(selectedSedtion == 'All')
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10 , vertical: 4 ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDF5E8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Total: ${item.totalQty}",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),


          if(selectedSedtion == 'All') ...[
            Row(
              children: [
                buildStockBadge("Store" , item.storeQty , primaryColor, const Color(0xFFDDF5E8)),

                const SizedBox(width: 8)

                buildStockBadge("Godown" , item.godownQty , primaryColor, const Color(0xFFDDF5E8)),

                const SizedBox(width: 8),

                buildStockBadge("Factory" , item.godownQty , primaryColor, const Color(0xFFDDF5E8)),
              ],
            ),

            const SizedBox(height: 10),

            InkWell(
              onTap: ()=> showTransferBottomSheet(context, item, primaryColor, initialFrom : 'Factory'),

              child: Row(

                children: const [
                  Text(
                    "Tap to move Stock between locations",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),

                  SizedBox(width: 4),

                  Icon(Icons.swap_horiz,size: 14, color: Colors.grey),
                ],
              ),
            ),
          ] else...[
            Row(
              children: [

                Icon(
                  selectedSedtion == 'Store' ? Icons.store
                      : selectedSedtion == 'Godown' ? Icons.warehouse : Icons.factory,
                  color: primaryColor,
                  size: 18,
                ),

                const SizedBox(width: 6),
                Text(
                  "In $selectedSedtion: ",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),

                Text(
                  "${selectedSedtion == 'Store' ? item.storeQty: selectedSedtion == 'Godown' ? item.godownQty : item.factoryQtyy} pcs",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

              ],
            ),



            //Move stock button

            OutlinedButton.icon(

                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryColor,
                  side: BorderSide(color: primaryColor.withOpacity(0.4)),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: ()=> showTransferBottomSheet(
                  context,
                  item,
                  primaryColor,
                  initialFrom: selectedSedtion,
                ),

                icon: const Icon(Icons.swap_horiz, size: 14),
                label: const Text(
                  "Move Stock",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ),
          ],
        ],
      ),

    );
  }



  Widget buildStockBadge(String label , int qty , Color textColor , Color bgColor){

    return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                "$qty",
                style: TextStyle(
                  fontSize: 12,
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
    );
  }




  void showTransferBottomSheet(
      BuildContext context,
      InventoryItem item,
      Color primaryColor,{
        required String initialFrom,
  }){

    String fromLocation = initialFrom;
    String toLocation = initialFrom == 'Store' ? 'Godown' : 'Store';

    final TextEditingController amountController = TextEditingController();


    showModalBottomSheet(
        context: context,

        isScrollControlled: true,
        backgroundColor: Colors.white,

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (ctx){
          return StatefulBuilder(
              builder: (ctx, setModalState){
                return Padding(
                    padding: EdgeInsets.only(
                      top: 20,
                      left: 20,
                      right: 20,
                      bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
                    ),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Text(
                            "Transfer Stock: ${item.name}",
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8 , vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(6),
                            ),

                            child: Text(
                              "Size: ${item.size}",
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  const Text(
                                      "From Location ",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),

                                  DropdownButton<String>(

                                      value: fromLocation,
                                      isExpanded: true,
                                      items: ['Store' , 'Godown' , 'Factory'].map((loc){
                                        return DropdownMenuItem(
                                          value: loc,
                                          child: Text(loc)
                                        );
                                      }).toList(),

                                      onChanged: (val){
                                        if(val != null) setModalState(()=> toLocation = val);
                                      },
                                  ),
                                ],
                              ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Quantity to Transfer",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),


                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 48,

                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                            onPressed: (){
                            if(fromLocation == toLocation){
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Source and Destination cannot be Same!'),)
                              );
                              return;
                            }

                            final amount = int.tryParse(amountController.text) ?? 0;

                            if(transferStock(item, from, to, amount)){
                              Navigator.pop(ctx);
                            }
                            } ,
                            child: const Text(
                              "Confirm Transfer",
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                        ),
                      ),
                    ],
                  ),
                );
              },
          );
        },
    );
  }
















}
