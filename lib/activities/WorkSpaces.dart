import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:splash/activities/HomePage.dart';
import 'package:splash/activities/ReserveWorkSpaceActivity.dart';
import 'package:splash/activities/WorkSpaceDetails.dart';
import 'package:splash/beans/WorkSpace.dart';
import 'package:splash/res/AppColors.dart';

class WorkSpaces extends StatefulWidget {
  String collection;

  Map<String, double> _startLocation;

  Function mainCallBack;

  WorkSpaces(this.collection, this._startLocation, this.mainCallBack);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    OfferState offerState =
        new OfferState(collection, _startLocation, mainCallBack);

    return offerState;
  }
}

class OfferState extends State<WorkSpaces> with TickerProviderStateMixin {
  String collection;

  Map<String, double> startLocation;

  Function mainCallBack;

  OfferState(this.collection, this.startLocation, this.mainCallBack);

  List<String> images = [];

  AnimationController _controller;
  Animation<double> _animation;

  final Distance distance = new Distance();

  // km = 423

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = new AnimationController(
      vsync: this,
      animationBehavior: AnimationBehavior.normal,
      duration: const Duration(milliseconds: 1000),
    );

    _animation = new CurvedAnimation(
        parent: _controller,
        curve: new Interval(0.0, 1.0, curve: Curves.bounceInOut));
  }

//    getPictures();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection(collection).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        else if (snapshot.hasData) {
          return new ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext ctxt, int Index) {
                double km = 0;
                print("Location 1 " + startLocation.toString());
                if (startLocation != null) {
                  km = distance.as(
                      LengthUnit.Kilometer,
                      new LatLng(startLocation['latitude'],
                          startLocation['longitude']),
                      new LatLng(
                          snapshot.data.documents[Index].data['address']['lat'],
                          snapshot.data.documents[Index].data['address']
                              ['lng']));
                }

                return MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    elevation: 0.0,
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => WorkSpaceDetails(
                                  WorkSpace.toObject(
                                      snapshot.data.documents[Index].data))));
                    },
                    child: Hero(
                        tag: snapshot.data.documents[Index].data['name'],
                        child: SingleWorkSpace(
                            WorkSpace.toObject(
                              snapshot.data.documents[Index].data,
                            ),
                            km)));
              });
        } else {
          return Center(child: CircularProgressIndicator());
        }
//        switch (snapshot.connectionState) {
//          case ConnectionState.waiting:
////            return Center(child: CircularProgressIndicator());
//            return Center(child: Text(""));
//          default:
////            mainCallBack();
//
//        }
      },
    );
  }

  Future<List> getWorkSpaces() async {
    List list = [];

    print("in get workspaces");

    await Firestore.instance.collection(collection).snapshots().listen((data) {
      HomePageState.heightList = data.documents.length * 100.0;

      print("Called" + HomePageState.heightList.toString());

      data.documents.forEach((r) {
        list.add(WorkSpace.toObject(r.data));
      });
    });

    return list;
  }
}

class SingleWorkSpace extends StatelessWidget {
  WorkSpace workSpace;

  double km;

  SingleWorkSpace(this.workSpace, this.km);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(
        child: Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new ClipRRect(
              borderRadius: new BorderRadius.circular(4.0),
              child: Image.network(
                workSpace.picUrls != null && workSpace.picUrls.length > 0
                    ? workSpace.picUrls.elementAt(0)
                    : "https://res.cloudinary.com/myhq/image/upload/fl_lossy,f_auto,q_auto/space-images/58334a65e55b93643163ee1b/58334a65e55b93643163ee1b-5.jpg",
                height: 100.0,
                width: 130.0,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          workSpace.name,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "GoogleSansBold",
                              fontSize: 16.0),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.location_on,
                          color: Colors.black,
                          size: 12.0,
                        ),
                        Padding(
                          padding: EdgeInsets.all(3.0),
                        ),
                        Expanded(
                          child: Text(
                            workSpace.address.locality +
                                " , " +
                                workSpace.address.city,
                            softWrap: true,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "GoogleSansRegular",
                                fontSize: 12.0),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                    ),
                    Divider(
                      height: 1.0,
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        "Experience: "+ (workSpace.opening).toString()+" yrs",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "GoogleSansRegular",
                            fontSize: 12.0),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        DecoratedBox(
                          child: Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Text(
                                km.toString() + " km",
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontFamily: "GoogleSansBold",
                                    fontSize: 14.0),
                              )),
                          decoration: BoxDecoration(
                              color: lightGrey,
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                        new RaisedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ReserveWorkSpaceActivity(workSpace)));
                          },
                          textColor: Colors.white,
                          color: colorPrimary,
                          child: new Text("Subscribe"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.all(5.0),
        ),
        Divider(
          height: 2.0,
          color: Colors.grey,
        )
      ],
    ));
  }
}
