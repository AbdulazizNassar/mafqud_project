import 'package:flutter/material.dart';
import 'package:mafqud_project/shared/DateTime.dart';

import '../services/showPostDetails.dart';

class PostCards extends StatelessWidget {
  const PostCards({
    super.key,
    required this.posts,
  });
  final posts;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        await showPostDetailsPage(posts: posts, context: context);
      },
      child: Card(
        child: Row(
          children: [
            Expanded(
                flex: 3,
                child: Image.network(
                  posts['image'],
                  fit: BoxFit.cover,
                )),
            Expanded(
                flex: 10,
                child: ListTile(
                  title: Text(
                    "${posts['title']}",
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text("${posts['category']}")),
                        Row(
                          children: [
                            const Icon(
                              Icons.timer_outlined,
                              size: 30,
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                readTimestamp(posts["Date"]),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ],
                        )
                      ]),
                )),

            // Text(
            //   readTimestamp(posts["Date"]),
            //   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            // ),
            const Icon(
              Icons.keyboard_double_arrow_right_outlined,
              size: 30,
            ),
            const SizedBox(
              height: 90,
            )
          ],
        ),
      ),
    );
  }
}
