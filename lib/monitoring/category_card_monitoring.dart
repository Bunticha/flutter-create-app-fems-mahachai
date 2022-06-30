import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class category_card_monitoring extends StatelessWidget {
  final String svgSrc;
  final String title;
  final Function press;
  const category_card_monitoring({
    Key key,
    this.svgSrc,
    this.title,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
          //padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const  Color(0xfff2f2d8),//Color.fromARGB(255, 129, 128, 89), //const  Color(0xff976311),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 17),
                blurRadius: 17,
                spreadRadius: -23,
            color: Colors.black,  //  Color(0xff976311),
                //color: Color(0xffc5c6ad),
              ),
            ],
          ),
          child: 
              Material(
                  color: Colors.transparent,
                  child: Stack(
                   alignment: Alignment.topCenter,  
                    children: [
                      InkWell(
                        onTap: press,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: <Widget>[
                              Spacer(),
                              Image.asset(svgSrc),
                              Spacer(),
                              Text(title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ))
                            ],
                          ),
                        ),
                      ),
                      
                    ],
                  )),
            
          ),
    );
  }
}
