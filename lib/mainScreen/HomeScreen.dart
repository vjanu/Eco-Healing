import 'package:flutter/material.dart';
import 'package:eco_healing/add_items/add_food_items.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../add_cnt/add_cloth.dart';
import '../add_cnt/add_tech.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(

      onWillPop: () async{
        if(isDialOpen.value){
          isDialOpen.value = false;
          return false;
        }else{
          return true;
        }
      },

      child: Scaffold(
        appBar: AppBar(
          title: const Text("Welcome"),
          backgroundColor: Colors.lightGreen,
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.add_event,
          backgroundColor: Colors.deepOrangeAccent,
          overlayColor: Colors.lightGreen,
          openCloseDial: isDialOpen,
          overlayOpacity: 0,
          spacing: 10,
          spaceBetweenChildren: 10,
          children: [
            SpeedDialChild(
                child: Icon(Icons.fastfood_rounded),
                label: 'Upload Food Items',
                backgroundColor: Colors.lightGreen,
                onTap: (){
                  print('Food Button Selected');
                  Navigator.push(context, MaterialPageRoute(builder: (c)=>const AddFood_itmes()));
                }
            ),
            SpeedDialChild(
                child: Icon(Icons.local_shipping_rounded),
                label: 'Upload Cloth Items',
                backgroundColor: Colors.lightGreen,
                onTap: (){
                  print('Cloth Button Selected');
                  Navigator.push(context, MaterialPageRoute(builder: (c)=>const Add_cloth()));

                }
            ),
            SpeedDialChild(
                child: Icon(Icons.electrical_services_rounded),
                label: 'Upload Eletronic Items',
                backgroundColor: Colors.lightGreen,
                onTap: (){
                  print('Electoric  Selected');
                  Navigator.push(context, MaterialPageRoute(builder: (c)=>const Add_tech()));
                }
            )
          ],

        ),
      ),
    );
  }
}
