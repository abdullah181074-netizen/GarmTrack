import 'package:flutter/material.dart';



class Home extends StatefulWidget{

  const Home({super.key});

  @override

  State<Home> createState() => HomeScreenState();

}



class HomeScreenState extends State<Home>{


  int inProductionCount = 1000;
  int completeCount = 700;
  int pendingCount = 300;



  void updateProductionStates({int? production , int? completed , int? pending}){

    setState(() {
      if(production != null)
        inProductionCount = production;

      if(completed != null)
        completeCount = completed;

      if(pending != null)
        pendingCount = pending;
    });
  }



  @override

  Widget build(BuildContext context){
    return Scaffold(

      backgroundColor: Colors.white,

      body: SingleChildScrollView(

        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Container(

                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),

                    child: const Icon(
                        Icons.store ,
                        color: Colors.blueAccent,
                        size: 24,
                    ),

                  ),

                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Row(
                        children: const [],
                      )
                    ],
                  )




                ],
              )
            ],
          )

        )
      )
    );
  }

}