import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:nomadly_app/models/Accomodation.dart';
import 'package:nomadly_app/screens/accommodation_card.dart';
import 'package:nomadly_app/utils/app_layout.dart';
import 'package:provider/provider.dart';

import '../utils/app_styles.dart';

class HomeHostScreen extends StatefulWidget {
  const HomeHostScreen({super.key});

  @override
  State<HomeHostScreen> createState() => _HomeHostScreenState();
}

class _HomeHostScreenState extends State<HomeHostScreen> {

    // return Scaffold(
    //     backgroundColor: Styles.backgroundColor,
    //     body: ListView(children: [
    //       Column(
    //         children: [
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               const Gap(5),
    //               Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   const Gap(20),
    //                   Text('Hello!', style: Styles.headLineStyle),
    //                   const Gap(20),
    //                   Text('What are you looking for?',
    //                       style: Styles.headLineStyle2),
    //                 ],
    //               ),
    //               SizedBox(
    //                 height: 40,
    //               ),
    //               const Gap(10),
    //             ],
    //           ),
    //         ],
    //       ),
    //     ]));
    @override
    Widget build(BuildContext context) {
      List<Acommodation> accommodationList =
          Provider.of<List<Acommodation>>(context);
      var size = AppLayout.getSize(context);
      return Scaffold(
          backgroundColor: Styles.backgroundColor,
          appBar: AppBar(
            backgroundColor: Styles.backgroundColor,
            title: Text('My Places', style: Styles.headLineStyle4),
            elevation: 0,
            centerTitle: true,
          ),
          body: ListView(
            children: [
              Column(
                children: [
                  SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(children: <Widget>[
                        SizedBox(
                          height: size.height * 0.78,
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

