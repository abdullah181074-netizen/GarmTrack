import 'package:flutter/material.dart';
import 'new_order.dart';


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
       Order(saveDetails: detailsobject),
    ];
  }


















  @override
  Widget build(BuildContext context){

    return Scaffold(

      backgroundColor: Colors.white,

      appBar: AppBar(

        //leading baki..

        backgroundColor: Colors.blue,
        title: const Text('Al Selim Garments'),
        elevation: 0,
        centerTitle: true,



      ),
      
      
      body: screens[selectedIndex],



      floatingActionButton: FloatingActionButton(
          onPressed: (){
            //add new order section
          },


        backgroundColor: Colors.blue,

        elevation: 6,

        shape: const CircleBorder(),

        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 35,

        ),
      ),


      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      
      bottomNavigationBar: BottomNavigationBar(
        
        currentIndex: selectedIndex,
        onTap: (index){
          setState(() {
            selectedIndex = index;
          });
        },
        
        selectedItemColor: const Color(0xFF062675),
        unselectedItemColor: Colors.black,
        
        
        type: BottomNavigationBarType.fixed,
        
        
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home) , label: "Home"),
          
          BottomNavigationBarItem(icon: Icon(Icons.task), label: "Orders"),

          BottomNavigationBarItem(icon: Icon(Icons.search) , label: "Search"),

          BottomNavigationBarItem(icon: Icon(Icons.more_horiz) , label: "More"),
        ],
        
      )
      
      
    );
  }
}