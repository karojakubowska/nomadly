import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:nomadly_app/models/Accomodation.dart';
import 'package:nomadly_app/screens/accommodation_card.dart';
import 'package:nomadly_app/screens/popular_view.dart';
import 'package:nomadly_app/utils/app_layout.dart';
import 'package:provider/provider.dart';

import '../utils/app_styles.dart';

class AllAccommodationsScreen extends StatefulWidget {
  const AllAccommodationsScreen({super.key});

  @override
  State<AllAccommodationsScreen> createState() =>
      _AllAccommodationsScreenState();
}

class _AllAccommodationsScreenState extends State<AllAccommodationsScreen> {
  @override
  Widget build(BuildContext context) {
    List<Acommodation> accommodationList =
        Provider.of<List<Acommodation>>(context);
    var size = AppLayout.getSize(context);
    return Scaffold(
        backgroundColor: Styles.backgroundColor,
        appBar: AppBar(
          leading: BackButton(color: Colors.black),
          backgroundColor: Styles.backgroundColor,
          title: Text('Hotels', style: Styles.headLineStyle4),
          elevation: 0,
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Column(
              children: [
                Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 50,
                      width: size.width * 0.7,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        onChanged: (val) => (val),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          errorBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.all(15),
                          prefixIcon: Icon(Icons.search_outlined),
                          hintText: 'Search places',
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 50.0,
                          width: 50.0,
                          decoration: BoxDecoration(
                              color: Styles.pinColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: SvgPicture.asset("assets/images/sliders.svg",color: Colors.white,width: 20,height: 20,),
                            //Icon(Icons.arrow_forward)
                            ),
                        ))
                  ],
                ),
                Gap(30),
                SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(children: <Widget>[
                      SizedBox(
                        height: size.height*0.78,
                        width: size.width * 0.9,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: accommodationList.length,
                          itemBuilder: (context, index) {
                            Acommodation model = accommodationList[index];
                            return AccommodationCard(
                              accomodation: model,
                              index: index,
                            );
                          },
                          //);
                        ),
                      ),
                    ])),
              ],
            ),
          ],
        ));
  }
}
