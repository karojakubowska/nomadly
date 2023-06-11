import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../utils/app_layout.dart';

typedef void QueryCallback(Query query);

class SearchBarScreen extends StatefulWidget {
  final QueryCallback onQueryChanged;
  const SearchBarScreen({
    super.key,
    required this.onQueryChanged,
  });

  @override
  State<SearchBarScreen> createState() => _SearchBarScreenState();
}

class _SearchBarScreenState extends State<SearchBarScreen> {
  TextEditingController searchCity = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var size = AppLayout.getSize(context);
    return Container(
       height: size.height * 0.8,
      width: size.width * 0.8,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: Column(
    
        children: [
          TextField(
                          controller: searchCity,
                          onChanged: (val) => setState(() {
                            // query = query.where(
                            //   'city',
                            //   isEqualTo: searchText.text,
                           // );
                          }),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            errorBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.all(15),
                            prefixIcon: Icon(Icons.search_outlined),
                            hintText: tr('Search places'),
                          ),
                        ),
                      
          ElevatedButton(
            child: Text(tr('Search')),
            onPressed: () => {
              widget.onQueryChanged(buildFilterQuery()),
              Navigator.pop(context)
            },
          )
        ],
      ),
    );
  }

  Query buildFilterQuery() {
    Query query = FirebaseFirestore.instance
        .collection('Accommodations')
        .where("city", isEqualTo: searchCity.text);

    return query;
  }
}
