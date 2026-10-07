import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';


class SaveDetails{
  String status;
  SaveDetails({this.status = 'Not save'});
}



class Order extends StatefulWidget{


  final  SaveDetails saveDetails;

  const Order({
    super.key,

    required this.saveDetails,

  });

  @override

  State <Order> createState()=> OrderScreenState();
}





class OrderScreenState extends State<Order>{


  late SaveDetails saveDetails;



  @override

  void initState(){
    super.initState();

    saveDetails = widget.saveDetails;


    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }


  Future<void> submitDetails() async{

    setState(() {
      saveDetails.status = 'Saved';
    });

    if(mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Save Product Details')),
      );
    }

  }





  final _productNameController  = TextEditingController();
  final _quantityController = TextEditingController();

  final _descriptionController = TextEditingController();

  final dateController = TextEditingController();




  File? _selectedImage;


  Future<void> _pickImageFromGallery() async{

    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if(image != null){
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }




  Future<void> selectDate(BuildContext context) async{
    DateTime initialDate;

    try{
      initialDate = DateFormat('dd/MM/yyyy').parse(dateController.text);
    }

    catch(e){
      initialDate = DateTime.now();
    }




    final DateTime? pickedDate = await showDatePicker(
        context: context,

        initialDate: initialDate,

        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
    );


    //when a date is picked then it updates the text field and returns automatically

    if(pickedDate != null){
      setState(() {
        dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }


  }







  @override

  Widget build(BuildContext context){
    return Scaffold(

      backgroundColor: Colors.white70,

      appBar: AppBar(

        backgroundColor: Colors.yellow,

        title: const Text('Add Product Details'),

        centerTitle: true,

      ),



      body: SingleChildScrollView(

        padding: const EdgeInsets.all(24),

        child: Form(

          //key

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              const SizedBox(height: 10),


              Center(
                child: GestureDetector(

                  onTap: _pickImageFromGallery,     //opens gallery on tap

                  child: Container(
                    height: 150,
                    width: 150,

                    decoration: BoxDecoration(

                      color: Colors.grey.shade100,

                      borderRadius: BorderRadius.circular(12),

                      border: Border.all(color: Colors.grey.shade400),
                    ),

                    child: _selectedImage != null ? ClipRRect(

                      borderRadius: BorderRadius.circular(12),

                      child: Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                      ),
                    )

                        :Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add_a_photo, size: 40 , color: Colors.grey),
                        SizedBox(height: 8),

                        Text('Add Image' , style: TextStyle(color: Colors.grey)),
                      ],

                    ),
                  ),
                ),
              ),


              SizedBox(height: 16),

              buildTextField(
                  controller: _productNameController,
                  hint: 'Product Name'
              ),


              SizedBox(height: 16),

              buildTextField(
                  controller: _quantityController,
                  hint: 'Quantity (Dozen)'
              ),



              SizedBox(height: 16),

              TextFormField(
                controller: dateController,

                readOnly: true,     //this text controller only read data

                onTap: ()=> selectDate(context),

                validator: (value){
                  if(value == null || value.isEmpty){
                    return 'Please select a Date for Product';
                  }
                  return null;
                },



                decoration: InputDecoration(

                  hintText: 'Product Date',

                  filled: true,
                  fillColor: Colors.grey.shade100,

                  border: OutlineInputBorder(

                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),

                  suffixIcon: IconButton(

                      icon: const Icon(Icons.calendar_today_outlined, color: Colors.grey),
                      onPressed: ()=> selectDate(context),
                  ),


                ),

              ),


              SizedBox(height: 20),

              buildTextField(
                  controller: _descriptionController,
                  hint: 'Add Description',
              ),


              SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(
                    onPressed: submitDetails,

                    style: ElevatedButton.styleFrom(

                      backgroundColor: Colors.blue,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                    child: Text(
                     saveDetails.status == 'Not save' ? 'Save Details' : 'Save',
                     style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),

                ),
              ),



            ],
          )
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


}