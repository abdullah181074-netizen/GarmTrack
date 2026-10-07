import 'package:flutter/material.dart';



class Home extends StatefulWidget{

  const Home({super.key});

  @override

  State<Home> createState() => HomeScreenState();

}



class HomeScreenState extends State<Home>{




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
                  const Text(
                      "Welcome Back",
                      style: TextStyle(

                        fontSize: 16,
                        color: Colors.grey,
                      ),

                  ),


                  const SizedBox(height: 5),

                  Text(

                    'name',

                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  /*Text(

                  )

                   */

                ],
              )
            ],
          )

        )
      )
    );
  }

}