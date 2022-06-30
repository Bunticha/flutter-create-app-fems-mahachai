import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fems_mahachai/model/userProfile.dart';
import 'package:fems_mahachai/monitoring/main_monitoring.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Model/Dictionary.dart';
import 'Model/UserDefault.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
 

 
// ignore: must_be_immutable
class LoginScreenStateless extends StatelessWidget {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder(
      stream: _firestore.collection("domain_name").snapshots(),
      builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot> snapshot,
      ) {
        if (snapshot.hasData) {
          var data = snapshot.data;
          List<Dictionary> returnList = <Dictionary>[];
          for (int index = 0; index <= data.docs.length - 1; index++) {
            var data1 = data.docs[index];
            Dictionary a = Dictionary();
            a.key = data1.data()['Domain_Name'];
            a.value = data1.data()['AD_Path'];
            returnList.add(a);
          }

          return LoginScreenStateful(
            listDomain: returnList,
            buildContext: context,
          );
          // return buildListData(snapshot.data);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

// ignore: must_be_immutable
class LoginScreenStateful extends StatefulWidget {
  LoginScreenStateful({Key key, this.listDomain, this.buildContext})
      : super(key: key);
  final List<Dictionary> listDomain;
  BuildContext buildContext;
  var testin = '';
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginState(listDomain: listDomain, buildContext: buildContext);
  }
}

Widget buildListData(QuerySnapshot data) {
  return ListView.builder(
    itemCount: data.docs.length,
    itemBuilder: (BuildContext context, int index) {
      return ListTile(
        title: Text(data.docs[index].data()["title"]),
      );
    },
  );
}

class LoginState extends State<LoginScreenStateful> {
  LoginState({this.listDomain, this.buildContext});

  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  Future<void> _handleSubmit(BuildContext context) async {
    try {
      // ignore: unawaited_futures
      Dialogs.showLoadingDialog(context, _keyLoader); //invoking login
      var letmes = await fetchUserID(
          emailController.text, passwordController.text, _currentAdPath);

      if (letmes.userid != null) {
        if (letmes.email != null && passwordController.text != null) {
          var data = {
            'DisplayName': letmes.name,
            'Email': letmes.email,
            'Token': 'yyyy',
            'UserId': letmes.userid,
            'Domain': _currenDomain,
            'LastIogIn': DateTime.now(),
            'LastChangePW': letmes.lastLogIn,
          };

          //    _incrementCounter(letmes.email, passwordController.text, _currenDomain);
          await _firestore
              .collection('user_profile')
              .doc(letmes.email)
              .get()
              .then((onData) async {
            if (!onData.exists) {
              await _firestore
                  .collection('user_profile')
                  .doc(letmes.email)
                  .set(data)
                  .then((onValue) async {
                FirebaseAuth auth = FirebaseAuth.instance;

                final User user1 = (await auth.createUserWithEmailAndPassword(
                        email: letmes.email, password: passwordController.text))
                    .user;
                await user1.sendEmailVerification().then((value) {
                  // pr.hide();
                  Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                      .pop(); //close the dialoge

                  //  Navigator.pop(context);
                  //
                  //
                  var snackBar = SnackBar(
                      content: Text(
                          "Please verify your Email, and try again to login"));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                });
              });
            } else {
              // Timestamp tmpDB =   onData.data()['LastIogIn'];
              DateTime dateFB = DateTime.fromMillisecondsSinceEpoch(
                  onData.data()['LastChangePW'].millisecondsSinceEpoch);
              DateTime dateFB1 = DateTime(dateFB.year, dateFB.month, dateFB.day,
                  dateFB.hour, dateFB.minute, dateFB.second);
              DateTime dateDB = DateTime(
                  letmes.lastLogIn.year,
                  letmes.lastLogIn.month,
                  letmes.lastLogIn.day,
                  letmes.lastLogIn.hour,
                  letmes.lastLogIn.minute,
                  letmes.lastLogIn.second);
              if (dateDB.difference(dateFB1).inSeconds > 0) {
// update last login
// reset password on firebase authen

                FirebaseAuth auth = FirebaseAuth.instance;
                await auth
                    .sendPasswordResetEmail(email: onData.data()['Email'])
                    .then((user) {
                  _firestore
                      .collection('user_profile')
                      .doc(onData.data()['Email'])
                      .update({
                    'LastIogIn': DateTime.now(),
                    'LastChangePW': dateDB
                  }).then((onValue) {
                    setState(() {
                      var snackBar = SnackBar(
                          content: Text(
                              "Password with AD has been changed, Please go to email verify again"));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);

                      showAlertDialog(
                          context,
                          "Password with AD has been changed, Please go to email verify again",
                          "Alert Confirm Email",
                          Icon(
                            Icons.email,
                            size: 30,
                            color: Colors.red,
                          ));
                    });
                  });
                }).catchError((error) {
                  print(error.toString());

                  var snackBar = SnackBar(content: Text(error.toString()));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                });
              } else {
                FirebaseAuth auth = FirebaseAuth.instance;
                try {
                  final User user1 = (await auth.signInWithEmailAndPassword(
                          email: letmes.email,
                          password: passwordController.text))
                      .user;

 
                  if (user1.emailVerified) {
                    //      await pr.hide();
                    Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                        .pop(); //close the dialoge
                    await Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext contex) {
                        return main_monitiring();
                      },
                    ));
                  } else {
                    // await pr.hide();
                    Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                        .pop(); //close the dialoge
                    return AlertDialog(
                      title: Text("Alert Dialog title"),
                      content: Text("Alert Dialog body"),
                      actions: <Widget>[
                        // usually buttons at the bottom of the dialog
                        FlatButton(
                          child: Text("Close"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  }
                } on PlatformException catch (e) {
                  setState(() {
                    Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                        .pop(); //close the dialoge
                    showAlertDialog(
                        context,
                        e.message.toString(),
                        "Alert Password Worng",
                        Icon(
                          Icons.error_outline,
                          size: 30,
                          color: Colors.red,
                        ));
                  });
                } catch (ex) {
                  setState(() {
                    Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                        .pop(); //close the dialoge
                    showAlertDialog(
                        context,
                        ex.message.toString(),
                        "Alert Password Worng",
                        Icon(
                          Icons.error_outline,
                          size: 30,
                          color: Colors.red,
                        ));
                  });
                }
              }
            }
          });
        }
      } else {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true)
            .pop(); //close the dialoge

        var snackBar = SnackBar(
            content: Text("Does't have this user , please verify again"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (error) {
      print(error);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true)
          .pop(); //close the dialoge

      var snackBar = SnackBar(
          content: Text("Does't have this user , please verify again"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      showAlertDialog(
          context,
          "Does't have this user , please verify again",
          "Alert Confirm Email",
          Icon(
            Icons.email,
            size: 30,
            color: Colors.red,
          ));
    }
  }

  final List<Dictionary> listDomain;
  BuildContext buildContext;
  List<String> listDomainStr = <String>[];
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final domainController = TextEditingController();

  String _currenDomain;
  String _currentAdPath;

  List<DropdownMenuItem<String>> _dropDownMenuItems;

 
  @override
  void initState() {
    super.initState();
 
    _dropDownMenuItems = getDropDownMenuItems();
    _currenDomain = _dropDownMenuItems[0].value;
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = [];
    for (Dictionary domain in listDomain) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      listDomainStr.add(domain.key);
      items.add(DropdownMenuItem(
        value: domain.key,
        child: Text(domain.key),
      ));
    }
    return items;
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  bool _obscureText = true;
  //insert generic of State : type is LoginScreen
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var maxWidthChild = SizedBox(
        width: width,
        height: 25.0,
        child: Center(
            child: Column(
          children: <Widget>[
            Text(
              'Log in',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            )
          ],
        )));

    // TODO: implement build
    return Scaffold(
      backgroundColor: const Color(0xff01579b),
      appBar: AppBar(
        backgroundColor: const Color(0xff01579b),
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(
            0.0), //EdgeInsets(all) ทุกมุม left/rigth/top/down
        child: Form(
          key: _formkey, //ต้องเอาเข้ามาเรียกใช้ใน formด้วย
          child: Container(
            child: ListView(
              padding: EdgeInsets.all(20),
              children: <Widget>[
                Image.asset(
                  "assets/images/factory.png",
                  width: 180,
                  height: 180,
                ),
                SizedBox(height: 25),
                GestureDetector(
                  onTap: null, // _authenticateMe,
                  onLongPress: null, // _authenticateMe,
                  child: TextFormField(
                    decoration: InputDecoration(
                        icon: const Icon(Icons.account_box),
                        labelText: 'User ID:',
                        hintText: 'xxxx.xxx'),

                    keyboardType: TextInputType
                        .emailAddress, // will be change if number (show only  number)
                    validator: (value) {
                      if (value.isEmpty) return 'Please insert User ID';
                    }, // value คือค่านึงที่รับมาจาก TextKey เอาไปตรวจสอบ เช่น ตรวจสอบว่าคีย์มาไหม

                    controller: emailController, // use onsave or controller
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    icon: const Icon(Icons.security),
                    labelText: 'Password:',
                    hintText: 'Enter password',
                  ),
                  obscureText: _obscureText,
                  controller: passwordController,
                ),
                /*    FlatButton(
                  onPressed: _toggle,
                  child:  Text(_obscureText ? "Show" : "Hide")), */

                GestureDetector(
                  onTap: _toggle,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[Icon(Icons.screen_lock_landscape)],
                  ),
                ),
                FormField<String>(
                  builder: (FormFieldState<String> state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        icon: const Icon(Icons.account_balance),
                        labelText: 'Domain',
                        errorText: state.hasError ? state.errorText : null,
                      ),
                      isEmpty: _currenDomain == '',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _currenDomain,
                          isDense: true,
                          onChanged: (String Value) {
                            setState(() {
                              _currenDomain = Value;
                              _currentAdPath = findAdPath(_currenDomain);
                              state.didChange(Value);
                            });
                          },
                          items: _dropDownMenuItems,
                        ),
                      ),
                    );
                  },
                  validator: (val) {
                    return val != '' ? null : 'Please select a color';
                  },
                ),
                Text(""),
                RaisedButton(
                  padding: EdgeInsets.all(5),
                  color: const Color(0xfff2f2d8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: const Color(0xfff2f2d8))),
                  onPressed: () async {
                    setState(() {
                      _handleSubmit(context);
                    });
                  },
                  
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    child: const Text('Log in', style: TextStyle(fontSize: 20)),
                  ),
                ),
                Text(""),
                GestureDetector(
                  onTap: null, // _authenticateMe,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,

                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showAlertDialog(
      BuildContext context, String valuealert, String title, Icon icon) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(_keyLoader.currentContext, rootNavigator: true)
            .pop(); //close the dialoge
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Row(children: <Widget>[icon, Text("  " + title)]),
      content: Text(valuealert),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void changedDropDownItem(String selectedDomain) {
    setState(() {
      _currenDomain = selectedDomain;
      _currentAdPath = findAdPath(_currenDomain);
    });
  }

  String findAdPath(String domainName) {
    for (int i = 0; i <= listDomain.length - 1; i++) {
      if (listDomain[i].key == _currenDomain) {
        return listDomain[i].value;
      }
    }
  }

  Widget buildListView(UserDefault data) {
    Navigator.pushReplacementNamed(context, "/");
    /*
    return ListView.builder(// for protect error when over length
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(data.UserId),
          subtitle: Text(data.Id),
          //can insert on tap
          onTap: (){
            //send data to others page
          //  Navigator.push(context, MaterialPageRoute(){}),
                     Navigator.pushReplacementNamed(context, "/");
  /* Navigator.push(context, MaterialPageRoute(builder: (BuildContext contex){
                  return DetailScreen(title: data[index].title,);
            }
             ,));   */       //
          },
        );
      },
    );*/
  }

  Future<UserDefault> fetchUserID(
      String userId, String pass, String domain) async {
    try {
      var data = {"userId": userId, "password": pass, "domain": domain};

      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final response = await http.post(
          Uri.parse('https://wsite-uat.cpf.co.th/SmartSCRM/EkoRestfulService.svc/GetUserIDinDomain4'),
          body: jsonEncode(data),
          headers: requestHeaders);
      //await http.get(
      //'http://wsite-uat.cpf.co.th/SmartSCRM/EkoRestfulService.svc/GetUserIDinDomain/$userId/$pass/$domain');

      UserDefault listRet = UserDefault();

      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON

        listRet = UserDefault.fromJson(json.decode(response.body));

        return listRet;
      } else {
        // If that call was not successful, throw an error.
        throw Exception('Failed to load post');
      }
    } on Exception catch (error) {
      print(error.toString());
    }
  }

  Future<userProfile> getGroupInfo(userData) async {
    userProfile profileList = userProfile();
    var document = FirebaseFirestore.instance
        .collection('user_profile')
        .doc(userData['Email'])
        .get();
    return await document.then((doc) {
      return profileList;
    });
  }

  /*Future<UserProfile> addData(userData) async {
    try {
      UserProfile profileList =  UserProfile();
      if (userData != null) {
        Firestore db = Firestore.instance;
        /* DocumentReference jsaDocumentRef =  db
          .collection('user_profile')
          .document(userData['Email']);
*/
        await Firestore.instance
            .collection('user_profile')
            .document(userData['Email'])
            .get()
            .then((onValue) {
          if (!onValue.exists) {
            // not exist ==> insert

            db
                .collection('user_profile')
                .document(userData['Email'])
                .setData(userData)
                .then((onValue) {
              profileList.displayName = userData['DisplayName'];
              profileList.email = userData['Email'];
              profileList.userid = userData['UserId'];
              return profileList;
            }).catchError((e) {});
          } else {
            profileList.displayName = onValue.data()['DisplayName'];
            profileList.email = onValue.data()['Email'];
            profileList.domain = onValue.data()['Domain'];
            profileList.userid = onValue.data()['UserId'];

            print('Update Too');
            return profileList;
            /*Stream<DocumentSnapshot> snapshots  =  jsaDocumentRef.snapshots();
{
 
}*/

          }
        });

        /*  Firestore.instance.collection("user_profile").add(userData).catchError((e) {
         print(e);
       });*/
      } else {
        print('You need to be logged in');
      }
    } on Exception catch (error) {
      print(error.toString());
    }
  }*/
}

//for display dialog
class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.black54,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Please Wait....",
                          style: TextStyle(color: Colors.white),
                        )
                      ]),
                    )
                  ]));
        });
  }
}
