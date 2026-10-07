import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget{
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}


class _RegisterScreenState extends State<RegisterScreen>{

  final _fullNameController = TextEditingController();

  final _garmentsNameController = TextEditingController();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _selectedSector;

  final List<String> _sectors = ['Admin' , 'Cutting' , 'Sewing' , 'Packaging'];

  bool _obscurePassword = true;


  @override
  void dispose(){   //for clean the memory

    _fullNameController.dispose();
    _garmentsNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: const Color(0xFF6C5CE7),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            const SizedBox(height: 24),
            _buildTextField(
              controller: _fullNameController,
              hint : 'Full Name',
              icon : Icons.person_outline,
            ),

            const SizedBox(height: 16),
            _buildTextField(
                controller: _garmentsNameController,
                hint: 'Garments Name',
                icon: Icons.factory_outlined,
            ),

            const SizedBox(height: 16),
            _buildTextField(
              controller : _emailController,
              hint : 'Email/Phone',
              icon: Icons.email_outlined,
            ),

            const SizedBox(height: 16),
            _buildSectorDropdown(),

            const SizedBox(height: 16),
            _buildPasswordField(),

            const SizedBox(height: 24),
            _buildRegisterButton(),

            const SizedBox(height: 16),
            _buildLoginLink(),
          ],
        ),
      ),
    );
  }


  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  } ){

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText : hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey.shade100,
        border:OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }


  Widget _buildSectorDropdown(){

    return DropdownButtonFormField<String>(
      initialValue: _selectedSector,
      decoration: InputDecoration(
        hintText: 'Sector',
        prefixIcon: const Icon(Icons.badge_outlined),
        filled: true,
        fillColor: Colors.grey.shade100,
        border : OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:  BorderSide.none,
        ),
      ),
      items: _sectors.map((sector){
        return DropdownMenuItem(
          value: sector,
          child: Text(sector),
        );
      }).toList(),
      onChanged: (value){
        setState(() {
          _selectedSector = value;
        });
      },
    );
  }


  Widget _buildPasswordField(){
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        hintText: 'Password',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(_obscurePassword ? Icons.visibility_off: Icons.visibility),
          onPressed: (){
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),

        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }


  Widget _buildRegisterButton(){
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: (){
          print('Name: ${_fullNameController.text}');
          print('Sector: $_selectedSector');
          print('E-mail/Phone: ${_emailController.text}');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6C5CE7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text('Register' ,style : TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }



  Widget _buildLoginLink(){
    return Center(
      child: TextButton(
        onPressed: (){
          Navigator.pop(context);   //back to login page
        },
        child: RichText(
          text: const TextSpan(
            style: TextStyle(color: Colors.black87),
            children: [
              TextSpan(text: 'Already have an account?'),
              TextSpan(
                text: 'Login',
                style: TextStyle(color: Color(0xFF6C5CE7), fontWeight:  FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
