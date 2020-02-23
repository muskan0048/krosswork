import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OffersActivity extends StatefulWidget {
  String collection, document;

  double height, width;

  OffersActivity(this.collection, this.document, this.height, this.width);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    OfferState offerState = new OfferState(collection, document, height, width);

    return offerState;
  }
}

class OfferState extends State<OffersActivity> {
  String collection, document;

  double height, width;

  OfferState(this.collection, this.document, this.height, this.width);

  List<String> images = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

//    getPictures();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
        future:
            Firestore.instance.collection(collection).document(document).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['pictures'] != null) {
              return new ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data['pictures'].length,
                  itemBuilder: (BuildContext ctxt, int Index) {
//                    print("i" + snapshot.data['pictures'][Index].toString());
                    return Padding(
                        padding: EdgeInsets.only(right: 2.0),
                        child: GestureDetector(
                          onTap: () {
                            showImage(snapshot.data['pictures'][Index]);
                          },
                          child: Card(
                              elevation: 3.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: new ClipRRect(
                                borderRadius: new BorderRadius.circular(4.0),
                                child: Image.network(
                                  snapshot.data['pictures'][Index],
                                  height: height * 0.28,
                                  width: width * 0.78,
                                  fit: BoxFit.cover,
                                ),
                              )),
                        ));
                  });
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  void getPictures() {
    Firestore.instance
        .collection(collection)
        .document(document)
        .get()
        .then((result) {
      print(result.toString());

      if (result.data['pictures'] != null) {
        List<String> pics = result.data['pictures'];

        pics.forEach((e) {
          images.add(e.toString());
        });

        setState(() {});
      } else {
        print("Error in getting pictures");
      }
    }).catchError((error) {});
  }

  void showImage(String data) {
    showDemoDialog(
        context: context,
        child: Card(
            elevation: 3.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: new ClipRRect(
                  borderRadius: new BorderRadius.circular(4.0),
                  child: Image.network(
                    data,
                    height: height * 0.60,
                    width: width,
                    fit: BoxFit.cover,
                  ),
                ))));
  }

  void showDemoDialog<T>({BuildContext context, Widget child}) {
    showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => child,
    );
  }
}
