import 'package:flutter/material.dart';
import 'new_order.dart';
import 'home.dart';
import 'workers.dart';

class Dashboard extends StatefulWidget{

  const Dashboard({super.key});


  @override

  State <Dashboard> createState() => _DashboardState();
}



class _DashboardState extends State<Dashboard>{

  
  int selectedIndex = 0;

  final SaveDetails detailsobject = SaveDetails(status : 'Not save');
  
  
  late final List<Widget> screens;
  
  
  @override
  
  void initState(){
    super.initState();
    
    screens = [
      const Home(),
      Order(saveDetails: detailsobject),
      WorkerScreen(adminGarmentsName: 'Al Selim Garments'),
    ];
  }

  Widget _navItem(IconData icon, String label, int index) {
    final bool isSelected = selectedIndex == index;

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circular icon with temporary ripple effect
          Material(
            color: isSelected
                ? const Color(0xFFDDF5E8)
                : const Color(0xFFF0FAF5),
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              customBorder: const CircleBorder(),
              splashColor: const Color(0xFF15966A).withOpacity(0.25),
              highlightColor: const Color(0xFF15966A).withOpacity(0.12),

              onTap: () {
                if (index < screens.length) {
                  setState(() {
                    selectedIndex = index;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '$label screen is not implemented yet.',
                      ),
                    ),
                  );
                }
              },

              child: SizedBox(
                width: 48,
                height: 48,
                child: Icon(
                  icon,
                  size: 24,
                  color: isSelected
                      ? const Color(0xFF15966A)
                      : const Color(0xFF43A982),
                ),
              ),
            ),
          ),

          const SizedBox(height: 5),

          // Label stays unchanged
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              color: isSelected
                  ? const Color(0xFF15966A)
                  : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context){

    return Scaffold(

      backgroundColor: Colors.white,

      appBar: AppBar(

        //leading baki..

        backgroundColor: Colors.green.shade50,
        elevation: 0,
        centerTitle: true,


        leading: selectedIndex != 0 ? IconButton(

            icon: const Icon(Icons.arrow_back,
              color: Colors.black),

            onPressed: () {
              setState(() {
                selectedIndex = 0;
              });
            },
        ) : null ,

        title: Text(
          selectedIndex == 0 ? 'Home Screen'
              : selectedIndex == 1 ? 'Add Product Details'
                  :selectedIndex == 2 ? 'Workers Details': 'Settings',

          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),

      ),
      
      
      body: screens[selectedIndex],





      bottomNavigationBar: selectedIndex == 0 ?Container(
        height: 200,
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.transparent),
          ),
        ),


        child: Column(

          children: [

            Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _navItem(Icons.home, 'Home', 0),
                    _navItem(Icons.add_circle, 'Add details', 1),
                    _navItem(Icons.person, 'Workers', 2),
                    _navItem(Icons.monetization_on, 'Cost Expences', 3),
                  ],
                ),
            ),


            const SizedBox(height: 5),

            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(Icons.inventory_2, 'Inventory', 4),
                  _navItem(Icons.factory,'Production', 5),
                  _navItem(Icons.person_add_alt_1, 'Add Customer', 6),
                  _navItem(Icons.settings, 'Settings', 7),
                ],
              ),
            ),

            const SizedBox(height: 30),

          ],
        ),
      )
        : null,
    );
  }
}