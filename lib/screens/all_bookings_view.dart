
import 'package:flutter/material.dart';

class AllBookingsScreen extends StatefulWidget {
  const AllBookingsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AllBookingsScreen> createState() => _AllBookingsScreenState();
}

class _AllBookingsScreenState extends State<AllBookingsScreen> {
  List<String> images = [
    "https://fastly.picsum.photos/id/0/5000/3333.jpg?hmac=_j6ghY5fCfSD6tvtcV74zXivkJSPIfR9B8w34XeQmvU",
    "https://fastly.picsum.photos/id/10/2500/1667.jpg?hmac=J04WWC_ebchx3WwzbM-Z4_KC_LeLBWr5LZMaAkWkF68",
    "https://fastly.picsum.photos/id/17/2500/1667.jpg?hmac=HD-JrnNUZjFiP2UZQvWcKrgLoC_pc_ouUSWv8kHsJJY"
  ];
  int _currentIndex = 0;
  PageController _pageController = PageController(initialPage: 0);

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 400,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const PageScrollPhysics(),
                      itemCount: 5,
                      itemBuilder: (BuildContext context, int index) {
                        return Image.network(
                          'https://picsum.photos/id/$index/200/300',
                        );
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        )
    );
  }
}


