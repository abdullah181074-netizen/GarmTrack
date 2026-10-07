import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


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







  @override

  Widget build(BuildContext context){
    return Scaffold(

      backgroundColor: Colors.white70,

      appBar: AppBar(

        backgroundColor: Colors.blue,

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