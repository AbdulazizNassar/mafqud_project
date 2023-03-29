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
        // ignore: use_build_context_synchronously
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
                flex: 9,
                child: ListTile(
                  title: Text("${posts['title']}"),
                  subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text("${posts['category']}")),
                        Container(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            "${posts['status']}",
                            style: const TextStyle(
                              backgroundColor: Colors.amber,
                              fontSize: 15,
                            ),
                          ),
                        )
                      ]),
                )),
            const Icon(
              Icons.timer_outlined,
              size: 30,
            ),
            Text(
              readTimestamp(posts["Date"]),
              style: const TextStyle(fontWeight: FontWeight.w100, fontSize: 15),
            ),
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
