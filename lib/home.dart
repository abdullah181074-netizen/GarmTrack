import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:image_picker/image_picker.dart';



class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeScreenState();
}

class HomeScreenState extends State<Home> {
  int inProductionCount = 1000;
  int completeCount = 700;
  int pendingCount = 300;

  void updateProductionStates({int? production, int? completed, int? pending}) {
    setState(() {
      if (production != null) inProductionCount = production;
      if (completed != null) completeCount = completed;
      if (pending != null) pendingCount = pending;
    });
  }




  //Banner State Management with large initial page for infinite smooth looping

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea( // Added SafeArea so it doesn't hide under phone status bars
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TOP HEADER ROW (Fixed spacing so notification goes to the right)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left Side: Logo & Brand Name
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.store,
                            color: Colors.blueAccent,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "AL-Selim Garments",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Track Every Stitch',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),


                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          print("Notification Button Clicked!");
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade200),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.notifications_outlined, size: 24),
                            ),
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),


                const SizedBox(height: 25),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const[
                    Text(
                        "Welcome Back! 👋 ",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                    ),

                     SizedBox(height: 4),

                     Text(
                       "Noman",
                       style: TextStyle(
                         fontSize: 22,
                         fontWeight: FontWeight.bold,
                       ),
                     ),

                    SizedBox(height: 4),

                    Text(
                      "Here's your business overview for today.",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),


                const SizedBox(height: 20),

                Row(

                  children: [

                    Expanded(
                        child: buildStatusCard(
                            title: "In Production",
                            value: inProductionCount.toString(),
                            icon: Icons.factory,
                            iconColor: Colors.blue.shade400,
                            bgColor: Colors.blue.shade50.withOpacity(0.5),
                        ),
                    ),

                    const SizedBox(width: 8),


                    Expanded(
                        child: buildStatusCard(
                            title: "Completed",
                            value: completeCount.toString(),
                            icon: Icons.schedule,
                            iconColor: Colors.green.shade400,
                            bgColor: Colors.green.shade50.withOpacity(0.5),
                        ),
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                        child: buildStatusCard(
                            title: "Pending",
                            value: pendingCount.toString(),
                            icon: Icons.warning_amber_rounded,
                            iconColor: Colors.red,
                            bgColor: Colors.red.shade50.withOpacity(0.5),
                        )
                    )

                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );
  }






  Widget buildStatusCard({
    required String title,
    required String value,
    //required bool isPositive,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
}){
    return Container(
      height: 145,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Icon(icon, color: iconColor, size: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),

        ],
      ),
    );
  }


}