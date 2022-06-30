import 'package:fems_mahachai/monitoring/category_card_monitoring.dart';
import 'package:fems_mahachai/production_plan/production_plan_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class main_monitiring extends StatelessWidget {
  main_monitiring();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context)
        .size; //this gonna give us total height and with of our device
    // ignore: unused_label

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff01579b),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu_sharp),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
         actions: <Widget>[
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                Navigator.pop(context);
            },
            ),
          ],
      ),
      backgroundColor: const Color(0xff01579b),
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: 
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20),
                  Text(
                    "MONITORING",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      ),
                      
                  ),
                  SizedBox(height: 30),
                  Image.asset(
                  "assets/images/industry.png",
                  width: 200,
                  height: 200,
                ),
                  //SizedBox(height: 10),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      alignment: Alignment.center,
                      height: 20,
                      width: 52,
                    ),
                  ),
                  SizedBox(height: 50),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 3,
                      childAspectRatio: .85,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 20,
                      children: <Widget>[
                        category_card_monitoring(
                          title: "Electric",
                          svgSrc: "assets/images/ups.png",
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return production_plan_main();
                              }),
                              );
                          },
                        ),
                        category_card_monitoring(
                          title: "Water",
                          svgSrc: "assets/images/water-pipe.png",
                          press: () {
                            Navigator.pop(context);
                          },
                        ),
                        category_card_monitoring(
                          title: "Compressed Air",
                          svgSrc: "assets/images/conveyor.png",
                          press: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
