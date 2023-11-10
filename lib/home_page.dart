import 'package:covid19/tabs/country_tab.dart';
import 'package:covid19/tabs/global_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Covid19 Tracker'),
        ),
        body: const Column(
          children: [
            TabBar(
              tabs: [
                Tab(
                    icon: Icon(
                  CupertinoIcons.globe,
                  color: Colors.deepPurple,
                )),
                Tab(
                  icon: Icon(
                    CupertinoIcons.map_pin_ellipse,
                    color: Colors.deepPurple,
                  ),
                )
              ],
            ),
            Expanded(child: TabBarView(children: [
              GlobalTab(),
              CountryTab(),
            ]),)


          ],
        ),
      ),
    );
  }
}
