import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voco/enums/snack_type.dart';
import 'package:voco/models/users.dart';
import 'package:voco/providers/data_provider.dart';
import 'package:voco/screens/intro/login_screen.dart';
import 'package:voco/utils/main_util.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

UserData? data;

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
        backgroundColor: Color.fromARGB(255, 35, 37, 74),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color.fromARGB(255, 35, 37, 74),
        onPressed: () async {
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.clear();
          MainUtil.showSnack(context, 'Logout Success', SnackType.SUCCESS);
          MainUtil.navigateTo(context, LoginScreen(), true);
        },
        label: Text("Logout"),
      ),
      body: data == null
          ? Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 35, 37, 74),
              ),
            )
          : Column(
              children: [
                _list(context),
              ],
            ),
    );
  }

  _getData(BuildContext context) async {
    UserData? a = await DataProvider().getData(context, 1);
    setState(() {
      data = a;
    });
  }
}

_list(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: GridView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 1.1 / 1,
        ),
        itemCount: data?.data == null ? 0 : data!.data!.length,
        itemBuilder: (BuildContext ctx, index) {
          var singleData = data!.data![index];
          return Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(5, 5),
                  spreadRadius: 0.1,
                  blurStyle: BlurStyle.normal,
                ),
              ],
              color: Color.fromARGB(255, 35, 37, 74),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: NetworkImage(singleData.avatar!), fit: BoxFit.fitWidth),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10, left: 10),
                      child: Text(
                        singleData.firstName! + ' ' + singleData.lastName!,
                        style: TextStyle(fontWeight: FontWeight.w300, color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}
