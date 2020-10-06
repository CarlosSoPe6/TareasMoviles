import 'package:flutter/material.dart';

import '../models/user.dart';

class HomeListItem extends StatelessWidget {
  final User user;

  HomeListItem({@required this.user});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(children: [
        Container(
          padding: EdgeInsets.all(5),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                  'https://randomuser.me/api/portraits/men/67.jpg')),
        ),
        Container(
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              Text(this.user.name),
              Text(this.user.phone),
              Text(this.user.company.name),
              Text(this.user.address.street + " " + this.user.address.suite + " " + this.user.address.city),
              ],
          ),
        )
      ]),
    );
  }
}
