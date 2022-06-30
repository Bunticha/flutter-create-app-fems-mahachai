import 'package:fems_mahachai/tab_page/tab1.dart';
import 'package:fems_mahachai/tab_page/tab2.dart';
import 'package:fems_mahachai/tab_page/tab3.dart';
import 'package:flutter/material.dart';

class Tab_Main extends StatelessWidget {
  Tab_Main({Key key, this.production_plant, this.factory}) : super(key: key);
  final String production_plant;
  final String factory;

  @override
  Widget build(BuildContext context) {
    print("production_plant1::${production_plant}");
    print("factory1::${factory}");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Center(
                child: Row(
              children: [
                /*Icon(
              Icons.electrical_services_rounded,
              color: Colors.white,
                ),*/
                SizedBox(
                  width: 80,
                ),
                Text(
                  "FACTORY "+ factory,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            )),
            backgroundColor: const Color(0xff01579b),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.monitor),
                  text: 'Monitor',
                ),
                Tab(
                  icon: Icon(Icons.power),
                  text: 'Efficiency',
                ),
                Tab(
                  icon: Icon(Icons.layers),
                  text: 'Record',
                ),
              ],
            ),
            // title: Text('Tabs Demo'),
          ),
          body: TabBarView(
            children: [Tab1(production_plant: production_plant, factory: factory,), Tab2(), Tab3()],
          ),
        ),
      ),
    );
  }
}
