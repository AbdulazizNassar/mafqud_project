

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';

class postModal {
   var title;
   var category;
   var description;
   var uid;
   var Date;
   var lat;
   var long;
   var image;
  var status;

  postModal({
     this.title,
     this.category,
     this.description,
     this.uid,
     this.status,
     this.lat,
     this.long,
     this.image,
     this.Date
  });


  List posts = [];



  //TODO: finish func
  Future<List<postModal>> getPosts() async {
    postModal pst = new postModal();
    List<postModal> psts = <postModal>[];
    // Get docs from collection reference
    CollectionReference postsRef = await FirebaseFirestore.instance.collection(
        'Posts');
    QuerySnapshot querySnapshot = await postsRef.get();
    // Get data from docs and convert map to List
    final allData =  querySnapshot.docs.map((doc) => doc.data()).toList();
    if (allData.isNotEmpty) {
      if(posts.isNotEmpty)
        posts.clear();
      for (var post in allData) {
        posts.add(post);
      }
      for (var post in posts) {
        pst.title = post['title'];
        pst.description = post['description'];
        pst.category = post['category'];
        pst.image = post['image'];
        pst.long = post['Lng'];
        pst.lat = post['Lat'];
        pst.Date = post['Date'];
        pst.status = post['status'];
        pst.uid = post['userID'];
        psts.add(pst);

      }
    }
    return psts;
  }
  
   PostBuilder() {
     Set<postModal> objs = Set();
     FirebaseFirestore.instance
         .collection("Posts")
         .get().then((value) => value.docs.forEach((element) {
          postModal pst = new postModal(title: element['title'], category: element['category'],
                                        description: element['description'], uid: element['userID'],
                                        status: element['status'], lat: element['Lat'], long: element['Lng'],
                                        image: element['image'], Date: element['Date']);
           objs.add(pst);
       }
     ));
     print(objs);
   }

  Future<List> getPos() async {
    List posts = [];
    // Get docs from collection reference
    CollectionReference postsRef = await FirebaseFirestore.instance.collection(
        'Posts');
    QuerySnapshot querySnapshot = await postsRef.get();
    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    if (allData.isNotEmpty) {
      for (var post in allData) {
        posts.add(post);
      }
    }
    return posts;
  }

}
