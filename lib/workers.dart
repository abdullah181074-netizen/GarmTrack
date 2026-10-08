import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class Worker{

  final String id;
  final String name;
  final String sector;

  final String garmentsName;



  Worker({
    required this.id,
    required this.name,
    required this.sector,
    required this.garmentsName,
});

}




class AssignedOrder{

  final String workerId;
  final String productName;
  final String quantity;
  final String price;
  final String deadline;
  final String descripton;


  AssignedOrder({
    required this.workerId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.deadline,
    required this.descripton,
});

}


class WorkerDatabase{

  static final List<Worker> registeredWorkers = [

    Worker(
      id: 'W001',
      name: 'Rahim Ahmed',
      sector: 'Cutting Operator',
      garmentsName: 'Al Selim Garments', // Matches your dashboard admin garments name
    ),

  ];


  //all assigned orders will be stored

  static final List<AssignedOrder> assignedOrders = [];



  static void addWorker(Worker worker){
    registeredWorkers.add(worker);
  }


  static void addOrder(AssignedOrder order){
    assignedOrders.add(order);
  }
}




class WorkerScreen extends StatefulWidget{

  final String adminGarmentsName;

  const WorkerScreen({super.key , required this. adminGarmentsName});

  @override
  State<WorkerScreen> createState() => WorkerScreenState();
}


class WorkerScreenState extends State<WorkerScreen>{


  String searchQuery ="";


  @override

  Widget build(BuildContext context){

    List<Worker> filteredWorkers = WorkerDatabase.registeredWorkers
        .where((worker) =>
    worker.garmentsName.trim().toLowerCase() ==
        widget.adminGarmentsName.trim().toLowerCase())
        .where((worker) =>
    worker.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
        worker.sector.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(

      backgroundColor: Colors.grey.shade100,

      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(16.0),

            child: TextField(
              onChanged: (value){
                setState(() {
                  searchQuery = value;
                });
              },

              decoration: InputDecoration(
                hintText: 'Search Worker',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,

                fillColor: Colors.white,

                focusColor: Colors.white,

                hoverColor: Colors.grey.shade50,

                contentPadding: const EdgeInsets.symmetric(vertical: 0),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),

            ),
          ),


          Expanded(

            child: filteredWorkers.isEmpty? const Center(
              child: Text(
                'No Workers found for your Garments.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ):ListView.builder(

               padding: const EdgeInsets.symmetric(horizontal: 16),
               itemCount: filteredWorkers.length,
               itemBuilder: (context, index){
                 final worker = filteredWorkers[index];

                 return Container(
                   margin: const EdgeInsets.only(bottom: 12),

                   decoration: BoxDecoration(

                     color: Colors.white,

                     borderRadius: BorderRadius.circular(12),

                     boxShadow: [
                       BoxShadow(
                         color: Colors.black.withOpacity(0.01),
                         blurRadius: 6,
                         offset: const Offset(0,2),
                       ),
                     ],
                   ),

                   child: ListTile(
                     contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

                     title: Text(
                       worker.name,

                       style: const TextStyle(
                         color: Colors.black87,
                         fontWeight: FontWeight.bold,
                         fontSize: 16,
                       ),
                     ),

                     subtitle: Padding(
                         padding: const EdgeInsets.only(top: 4),

                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,

                           children: [
                             Text(
                               'ID: ${worker.id}',
                               style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                             ),
                           ],
                         ),
                     ),


                     trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),

                     onTap: (){
                       Navigator.push(
                         context,
                         MaterialPageRoute(builder: (context)=> AssignProductScreen(worker: worker),
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
    );
  }
}




class AssignProductScreen extends StatefulWidget{
  final Worker worker;

  const AssignProductScreen({super.key , required this.worker});


  @override
  State<AssignProductScreen> createState()=> AssignProductScreenState();
}




class AssignProductScreenState extends State<AssignProductScreen>{



  final _productNameController  = TextEditingController();
  final _quantityController = TextEditingController();

  final _priceController = TextEditingController();

  final _descriptionController = TextEditingController();

  final dateController = TextEditingController();




  @override
  void initState(){
    super.initState();

    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());


  }


  Future<void> selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,

      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }


    void saveOrder() {
      if (_productNameController.text
          .trim()
          .isEmpty || _quantityController.text
          .trim()
          .isEmpty || _priceController.text
          .trim()
          .isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please Fill in Product Name , Quantity and price'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }


      WorkerDatabase.addOrder(
        AssignedOrder(
          workerId: widget.worker.id,
          productName: _productNameController.text.trim(),
          quantity: _quantityController.text.trim(),
          price: _priceController.text.trim(),
          deadline: dateController.text,
          descripton: _descriptionController.text
              .trim()
              .isEmpty ? 'N/A' : _descriptionController.text.trim(),
        ),
      );


      //clear form

      _productNameController.clear();
      _quantityController.clear();
      _priceController.clear();
      _descriptionController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
            'Order Assigned to ${widget.worker.name} Successfully!'),
          backgroundColor: Colors.green,
        ),
      );

  }







  @override
  Widget build(BuildContext context){
    return Scaffold(

        backgroundColor: Colors.white,

        appBar: AppBar(

          backgroundColor: Colors.transparent,
          title:  Text(
              'Assign Product to : ${widget.worker.name}',

               style: const TextStyle(color: Colors.black87 , fontSize: 18),
          ),

          centerTitle: true,
        ),


        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Text(
                    'Sector: ${widget.worker.sector} (${widget.worker.id})',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                  ),

                  InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=>
                          WorkerOrdersScreen(worker: widget.worker),
                        ),
                      );
                    },


                    child: Row(
                      children: const [
                        Icon(Icons.task, size: 18, color: Colors.grey),

                        SizedBox(width: 4),

                        Text(
                          'View All Orders',
                          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        Icon(Icons.chevron_right , size: 18, color: Colors.grey),
                      ],
                    ),

                  ),

                ],
              ),


              const SizedBox(height: 30),

              buildTextField(
                  controller: _productNameController,
                  hint: 'Product Name',
              ),

              const SizedBox(height: 16),

              buildTextField(
                  controller: _quantityController,
                  hint: 'Quantity (Dozen)',
              ),


              const SizedBox(height: 16),

              buildTextField(
                  controller: _priceController,
                  hint: 'Price (per Pis)',
              ),

              const SizedBox(height: 16),

              buildFormLabel('Delivery Deadline'),

              TextFormField(

                controller: dateController,

                readOnly: true,

                onTap: ()=> selectDate(context),

                decoration: InputDecoration(

                  filled: true,

                  fillColor: Colors.grey.shade100,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),

                  suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today , color: Colors.grey),
                      onPressed: ()=> selectDate(context),
                  ),
                ),
              ),



              const SizedBox(height: 16),

              buildFormLabel('Add Description (Optional)'),

              buildTextField(
                  controller: _descriptionController,
                  hint: 'Right Here',
              ),



              const SizedBox(height: 30),


              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: saveOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Add', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),


              const SizedBox(height: 20),

            ],
          )
        )


    );
  }



  Widget buildTextField({
    required TextEditingController controller,
    required String hint,

    //icon
  }){

    return TextFormField(
      controller: controller,

      validator: (value){

        if(value == null || value.isEmpty){
          return 'Please Enter $hint';
        }

        return null;
      },

      decoration: InputDecoration(
        hintText: hint,

        filled:  true,

        fillColor: Colors.grey.shade100,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );

  }



  Widget buildFormLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
    );
  }

}




class WorkerOrdersScreen extends StatefulWidget{

  final Worker worker;

  const WorkerOrdersScreen({super.key , required this.worker});


  @override
  State<WorkerOrdersScreen> createState()=> WorkerOrdersScreenState();

}



class WorkerOrdersScreenState extends State<WorkerOrdersScreen>{




  @override

  Widget build(BuildContext context){

    List<AssignedOrder> workerOrder = WorkerDatabase.assignedOrders.where((order) => order.workerId == widget.worker.id).toList();

    return Scaffold(

      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(

        title: Text('${widget.worker.name}\'s Orders'),

        backgroundColor: Colors.grey,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),


      body: workerOrder.isEmpty? const Center(
        child: Text('No orders assigned yet..',
        style: TextStyle(color: Colors.grey , fontSize: 16),
        ),
      )
          : ListView.builder(

          padding: const EdgeInsets.all(16),
          itemCount: workerOrder.length,
          itemBuilder: (context , index){
            final order = workerOrder[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(

                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
               // boxShadow:
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Text(
                        order.productName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),


                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),

                        child: Text(
                          '${order.quantity} Dozen',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),

                    ],
                  ),


                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(Icons.calendar_today,size: 14, color: Colors.grey),

                      const SizedBox(width: 6),

                      Text(
                        'Deadline : ${order.deadline}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),

                  if (order.descripton.isNotEmpty && order.descripton != 'N/A')...[

                    const SizedBox(height: 8),

                    Text(
                      'Note: ${order.descripton}',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                      ),
                    ),
                  ],


                ],
              ),

            );
          },
      ),

    );
  }
}