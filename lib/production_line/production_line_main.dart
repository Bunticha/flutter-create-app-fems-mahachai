
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fems_mahachai/circular_bottom.dart';
import 'package:fems_mahachai/model/detailData.dart';
import 'package:fems_mahachai/production_line/production_line_menu.dart';
import 'package:fems_mahachai/tab_page/tab_main.dart';
import 'package:flutter/material.dart';
import "package:collection/collection.dart";

class production_line_main extends StatelessWidget {
  production_line_main({Key key, this.production_plant}) : super(key: key);
  final String production_plant;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DateTime userSelectedStartDate = DateTime.now().subtract(Duration(hours: 1));

  @override
  Widget build(BuildContext context) {
    print("production_plant::::${production_plant}");
    print('Start:' + userSelectedStartDate.toString());

    var startUnix = userSelectedStartDate.millisecondsSinceEpoch;

    print('startUnix :' + startUnix.toString());

    var startUnixStr =
        startUnix.toString().substring(0, startUnix.toString().length - 3);

    print('startUnixStr :' + startUnixStr.toString());

    var dateConvert = new DateTime.fromMillisecondsSinceEpoch(startUnix);

    print('dateConvert:' + dateConvert.toString());

    var finalUnixStart = int.parse(startUnixStr) + 25200;

        return StreamBuilder(
      stream: _firestore
          .collection("FEMS_Mahachai")
          .where('MASTER_TAG', isEqualTo: 'M')
          .where('PRODUCTION_PLANT', isEqualTo: production_plant)
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
    print('dataFactory===${data.length}');

    var Factory = groupBy(data, (pang) => pang.factory).keys.toList();
    Factory.sort();

  var c = new List<num> ();
    for (var i = 0; i < Factory.length; i++) {
      var Fac = data
        .where((value) => value.factory.toString().contains(Factory[i]))
        .toList();
      var sum = Fac.map((expense) => expense.output_kg).fold(0, (prev, output_kg) => prev + output_kg);
      print("sum==${sum}");

      c.add(sum);
      
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
              width: 40,
            ),
            Text(
              "PRODUCTION PLAN " + production_plant,
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
            height: 10,
          ),
          // selectHousePic(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: RawScrollbar(
                thumbColor: Colors.white12,
                radius: Radius.circular(30),
                thickness: 3,
                child: GridView.builder(
                    itemCount: c.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 1,
                      crossAxisSpacing: 10.0,
                      childAspectRatio: 1.1,
                    ),
                    itemBuilder: (BuildContext ctxt, int index) {
                      return GestureDetector(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            production_line_menu(
                              title: "Factory " + Factory[index].toString(),
                              shopName: data[index].timestamp.substring(0,19),
                              stan: "Standard:     "+ "                ",
                              value: "Actual: " + c[index].toString() + " "+data[index].base_unit,
                              svgSrc: "assets/images/conveyor.png",
                              press: () {
                                var homeRoute = new MaterialPageRoute(
                                builder: (BuildContext context) => Tab_Main(
                                  production_plant: production_plant,
                                  factory: Factory[index].toString(),
                                )
                              );

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
