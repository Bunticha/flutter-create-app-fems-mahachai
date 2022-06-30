import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fems_mahachai/model/detailData.dart';
import 'package:fems_mahachai/tab_page/categorycardTab1.dart';
import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
import "package:collection/collection.dart";

class Tab1 extends StatelessWidget {
  Tab1({Key key, this.production_plant, this.factory}) : super(key: key);
  final String production_plant;
  final String factory;
  @override
  Widget build(BuildContext context) {
    return TabMain(production_plant: production_plant, factory: factory);
  }
}

/// This is the stateless widget that the main application instantiates.
class TabMain extends StatelessWidget {
  TabMain({Key key, this.production_plant, this.factory}) : super(key: key);
  final String production_plant;
  final String factory;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;


  DateTime userSelectedStartDate = DateTime.now().subtract(Duration(hours: 1));

  @override
  Widget build(BuildContext context) {
    print("production_plant2===${production_plant}");
    print("factory2===${factory}");

    print('Start:' + userSelectedStartDate.toString());


    var startUnix = userSelectedStartDate.millisecondsSinceEpoch;

    print('startUnix :' + startUnix.toString());

    var startUnixStr =
        startUnix.toString().substring(0, startUnix.toString().length - 3);

    print('startUnixStr :' + startUnixStr.toString());

    var dateConvert = new DateTime.fromMillisecondsSinceEpoch(startUnix);

    print('dateConvert:' + dateConvert.toString());

    
    var finalUnixStart = int.parse(startUnixStr) + 25200;


    print('finalUnixStart==' + finalUnixStart.toString());

    return StreamBuilder(
      stream: _firestore
          .collection("FEMS_Mahachai")
          .where('MASTER_TAG', isEqualTo: 'M')
          .where('PRODUCTION_PLANT', isEqualTo: production_plant)
          .where('FACTORY', isEqualTo: factory)
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

      var material = item.data()['MATERIAL'];
      b.material = material.toString();

      var master_tag = item.data()['MASTER_TAG'];
      b.master_tag = master_tag.toString();


      a.add(b);
    }

    return a;
  }

  Widget buildListData(List<detailData> data, context) {
    print('data::: ${data.length}');  
    // ignore: non_constant_identifier_names
    return Scaffold(
        /*appBar: AppBar(
          backgroundColor: const Color(0xffc5c6ad),
          elevation: 0,
          actions: <Widget>[],
        ),*/
        backgroundColor: const Color(0xfff2f2d8),
        body: Stack(children: <Widget>[
          SafeArea(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    alignment: Alignment.center,
                    //height: 2,
                    width: 52,
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F6F9),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Scrollbar(
                      child: GridView.builder(
                        itemCount: data.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 1.0,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.55,
                        ),
                        itemBuilder: (BuildContext ctxt, int index) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: <Widget>[
                                categorycardTab1(
                                  svgSrc: "assets/icons/supply.svg",
                                  title: "Machine",
                                  shopName: data[index].timestamp.substring(0,19),
                                  stan: "Standard:     "+ "                ",
                                  value: "Actual:     " + data[index].output_kg.toString() + " "+data[index].base_unit,
                                ),
                              ],
                            ),
                          );
                        }),
                    ),
                  ),
                )
              ],
            ),
          ))
        ]));
  }
}
