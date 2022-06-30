import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fems_mahachai/main.dart';
import 'package:fems_mahachai/model/detailData.dart';
import 'package:fems_mahachai/production_line/production_line_main.dart';
import 'package:fems_mahachai/production_plan/production_plan_menu.dart';
import 'package:fems_mahachai/tab_page/tab_main.dart';
import 'package:flutter/material.dart';
import "package:collection/collection.dart";

class production_plan_main extends StatelessWidget {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DateTime userSelectedStartDate = DateTime.now().subtract(Duration(hours: 1));
  DateTime userSelectedEndDate = DateTime.now(); //.subtract(Duration(hours: 1));

  @override
  Widget build(BuildContext context) {
    print('Start:' + userSelectedStartDate.toString());
    print('End:' + userSelectedEndDate.toString());

    var startUnix = userSelectedStartDate.millisecondsSinceEpoch;

    print('startUnix :' + startUnix.toString());

    var startUnixStr =
        startUnix.toString().substring(0, startUnix.toString().length - 3);

    print('startUnixStr :' + startUnixStr.toString());

    var dateConvert = new DateTime.fromMillisecondsSinceEpoch(startUnix);

    print('dateConvert:' + dateConvert.toString());

    var finalUnixStart = int.parse(startUnixStr) + 25200;

    print('finalUnixStart==' + finalUnixStart.toString());

    int counter = 0;

    return StreamBuilder(
      stream: _firestore
          .collection("FEMS_Mahachai")
          .where('MASTER_TAG', isEqualTo: 'M')
          .where('UNIX', isGreaterThanOrEqualTo: finalUnixStart.toString())
          .snapshots(),
      builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot> snapshot,
      ) {
        print(snapshot.hasData.toString);
        if (snapshot.hasData) {
          var values = snapshot.data;
          List<detailData> ret = convertSnapShotToModel(values);
          //return new MyOeeDashboard(listOEE: ret); //Text(snapshot.dat

          return buildListData(ret, context);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  convertSnapShotToModel(QuerySnapshot data) {
    List<detailData> a = new List<detailData>();

    for (var item in data.docs) {
      detailData b = new detailData();

      var base_unit = item.data()['BASE_UNIT'];
      b.base_unit = base_unit.toString();

      var factory = item.data()['FACTORY'];
      b.factory = factory.toString();

      var output_kg = item.data()['OUTPUT_KG'];
      b.output_kg = output_kg;

      var timestamp = item.data()['TIMESTAMP'];
      b.timestamp = timestamp.toString();

      var time_entry = item.data()['TIME_ENTRY'];
      b.time_entry = time_entry.toString();

      var production_plant = item.data()['PRODUCTION_PLANT'];
      b.production_plant = production_plant.toString();

      var master_tag = item.data()['MASTER_TAG'];
      b.master_tag = master_tag.toString();

      a.add(b);
    }

    return a;
  }

  @override
  Widget buildListData(List<detailData> data, context) {
    print('dataPlan===${data.length}');

    var Product = groupBy(data, (pang) => pang.production_plant).keys.toList();
    Product.sort();

    var c = new List<num> ();
    for (var i = 0; i < Product.length; i++) {
      var Product1 = data
        .where((value) => value.production_plant.toString().contains(Product[i]))
        .toList();
      var sum1 = Product1.map((expense) => expense.output_kg).fold(0, (prev, output_kg) => prev + output_kg);
      print("sum1==${sum1}");

      c.add(sum1);
      
    }
  print("c:: ${c}");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff01579b),
        elevation: 0,
        title: Center(
            child: Row(
          children: [
            /*Icon(
              Icons.electrical_services_rounded,
              color: Colors.white,
            ),*/
            SizedBox(
              width: 90,
            ),
            Text(
              "ELECTRIC",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        )),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        /*actions: <Widget>[
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                Navigator.pop(context);
            },
            ),
          ],*/
      ),
      backgroundColor: const Color(0xff01579b),
      body: Stack(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          // selectHousePic(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: RawScrollbar(
                thumbColor: Colors.white12,
                radius: Radius.circular(20),
                thickness: 5,
                child: GridView.builder(
                    itemCount: c.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 1.0,
                      crossAxisSpacing: 10.0,
                      childAspectRatio: 1.2,
                    ),
                    itemBuilder: (BuildContext ctxt, int index) {
                      return GestureDetector(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            production_plan_menu(
                              title: "Product Plant " + Product[index].toString() ,
                              shopName: data[index].timestamp.substring(0,19),
                              stan: "Standard: "+ "                ",
                              value: "Actual: " + c[index].toString() + " "+data[index].base_unit,
                              svgSrc: "assets/icons/supply.svg",
                              press: () {
                                var homeRoute = new MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        production_line_main(
                                          production_plant: Product[index].toString()
                                        ));

                                Navigator.of(ctxt).push(homeRoute);
                              },
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
