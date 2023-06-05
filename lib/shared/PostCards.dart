import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mafqud_project/shared/DateTime.dart';
import 'package:provider/provider.dart';

import '../services/imagePicker.dart';
import '../services/showPostDetails.dart';

class PostCards extends StatelessWidget {
  PostCards({super.key, required this.posts, this.image, this.postID});
  final posts;
  final postID;
  dynamic image;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        await showPostDetailsPage(
            posts: posts,
            context: context,
            images: posts["image"],
            postID: postID);
      },
      child: Card(
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: checkUrl(posts['image'][0]),
            ),
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
                              size: 20,
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                readTimestamp(posts["Date"]),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.attach_money_outlined,
                              color: Colors.green,
                            ),
                            Text(
                              " ${posts["reward"]}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            )
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
