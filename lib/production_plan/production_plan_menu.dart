import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class production_plan_menu extends StatelessWidget {
  final String title, shopName, value, stan, svgSrc;
  final Function press;
  const production_plan_menu({
    Key key,
    this.title,
    this.shopName,
    this.value,
    this.stan,
    this.svgSrc,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This size provide you the total height and width of the screen
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(left: 20, right: 15, top: 20, bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xfff2f2d8),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 20,
            color: Color(0xFFB0CCE1).withOpacity(0.32),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: press,
          child: Padding(
            padding: const EdgeInsets.all(80.0),
            child: Column(
              children: <Widget>[
                Container(
                  /*margin: EdgeInsets.only(bottom: 25),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F6F9),
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    svgSrc,
                    width: size.width * 0.10,
                    // size.width * 0.18 means it use 18% of total width
                  ),*/
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff000000)),
                  ),
                SizedBox(height: 5),
                Text(
                  shopName,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Color(0xff000000)),
                ),
                SizedBox(height: 15),
                Text(
                  stan,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold, color: Color(0xff000000)),
                ),
                Text(
                  value,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold, color: Color(0xff000000)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
