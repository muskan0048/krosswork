import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:splash/activities/ReserveWorkSpaceActivity.dart';
import 'package:splash/beans/WorkSpace.dart';
import 'package:splash/helpers/Dividers.dart';
import 'package:splash/res/AppColors.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkSpaceDetails extends StatefulWidget {
  WorkSpace workSpace;

  WorkSpaceDetails(this.workSpace);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new WorkSpaceDetailsState(workSpace);
  }
}

class WorkSpaceDetailsState extends State<WorkSpaceDetails> {
  WorkSpace workSpace;

  ScrollController _scrollController = new ScrollController();

  static const kExpandedHeight = 240.0;

  WorkSpaceDetailsState(this.workSpace);

  @override
  Widget build(BuildContext context) {
    _scrollController = ScrollController()..addListener(() => setState(() {}));

    // TODO: implement build
    return new Scaffold(
      body: SafeArea(
          child: NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    backgroundColor: Colors.white,
                    expandedHeight: kExpandedHeight,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: new CarouselSlider(
                        items: workSpace.picUrls.map((i) {
                          return new Builder(
                            builder: (BuildContext context) {
                              return new Card(
                                  elevation: 3.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: new ClipRRect(
                                    borderRadius:
                                        new BorderRadius.circular(4.0),
                                    child: Image.network(
                                      i,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.48,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.cover,
                                    ),
                                  ));
                            },
                          );
                        }).toList(),
                        autoPlay: true,
                        autoPlayCurve: Curves.easeIn,
                      ),
                    ),
                    title: _showTitle
                        ? Text(
                            workSpace.name,
                            style: TextStyle(
                                color: colorPrimary,
                                fontFamily: "GoogleSansRegular",
                                fontWeight: FontWeight.bold),
                          )
                        : null,
                    leading: MaterialButton(
                      elevation: 0.0,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: Colors.transparent,
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: colorPrimary,
                      ),
                    ),
                    actions: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Share.share(
                              "I found this amazing mentor on StudyBuddy. ");
                        },
                        child: Icon(
                          Icons.share,
                          color: colorPrimary,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 20.0),
                      )
                    ],
                    centerTitle: true,
                  ),
                ];
              },
              body: Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.all(1.0)),
                              WorkSpaceName(workSpace),
                              Padding(padding: EdgeInsets.all(10.0)),
                              WorkAmenities(workSpace),
                              Padding(padding: EdgeInsets.all(10.0)),
                              SpaceInfo(workSpace),
                              Padding(padding: EdgeInsets.all(10.0)),
                              AboutAndAddress(workSpace),
                              Padding(padding: EdgeInsets.all(30.0)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: MaterialButton(
                        color: colorPrimary,
                        minWidth: MediaQuery.of(context).size.width,
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ReserveWorkSpaceActivity(workSpace)));
                        },
                        child: Text(
                          "Schedule a Session",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "GoogleSansRegular",
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                      )),
                ],
              ))),
    );

//        SafeArea(
//
//
//      child: CustomScrollView(
//        slivers: <Widget>[
//          SliverAppBar(
//              title: new CarouselSlider(
//                  items: workSpace.picUrls.map((i) {
//                    return new Builder(
//                      builder: (BuildContext context) {
//                        return new Card(
//                            elevation: 3.0,
//                            shape: RoundedRectangleBorder(
//                              borderRadius: BorderRadius.circular(4.0),
//                            ),
//                            child: new ClipRRect(
//                              borderRadius: new BorderRadius.circular(4.0),
//                              child: Image.network(
//                                i,
//                                height:
//                                    MediaQuery.of(context).size.height * 0.28,
//                                width: MediaQuery.of(context).size.width,
//                                fit: BoxFit.cover,
//                              ),
//                            ));
//
//                        new Container(
//                            width: MediaQuery.of(context).size.width,
//                            margin: new EdgeInsets.symmetric(horizontal: 5.0),
//                            decoration: new BoxDecoration(color: Colors.amber),
//                            child: new Text(
//                              'text $i',
//                              style: new TextStyle(fontSize: 16.0),
//                            ));
//                      },
//                    );
//                  }).toList(),
//                  autoPlay: true)),
//        ],
//      ),
//    ));
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset > kExpandedHeight - kToolbarHeight;
  }
}

class WorkAmenities extends StatelessWidget {
  WorkSpace workSpace;

  WorkAmenities(this.workSpace);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
        elevation: 0.0,
        color: Colors.white,
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                      child: Container(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                        Text(
                          "Specializations",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "GoogleSansRegular",
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Padding(
                          padding: EdgeInsets.all(1.0),
                        ),
                        HorizontalDivider(colorPrimary, 2.0, 100.0),
                        Padding(
                          padding: EdgeInsets.all(5.0),
                        ),
                        workSpace.workAmenities != null &&
                                workSpace.workAmenities.length > 0
                            ? Container(
                                height: 120.0,
                                child: new ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: workSpace.workAmenities.length,
                                    itemBuilder:
                                        (BuildContext ctxt, int Index) {
                                      return Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: Container(
                                            width: 70.0,
                                            child: new Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Image.network(
                                                  workSpace.workAmenities.values
                                                      .elementAt(Index),
                                                  height: 40.0,
                                                  width: 40.0,
                                                  color: colorPrimary,
                                                  colorBlendMode:
                                                      BlendMode.lighten,
                                                  fit: BoxFit.cover,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    workSpace.workAmenities.keys
                                                        .elementAt(Index),
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "GoogleSansRegular",
                                                        fontSize: 12.0,
                                                        color: Colors.black),
                                                    softWrap: true,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                )
                                              ],
                                            )),
                                      );
                                    }),
                              )
                            : Padding(
                                padding: EdgeInsets.all(10.0),
                              ),
                      ])))
                ])));
  }
}

class SpaceInfo extends StatelessWidget {
  WorkSpace workSpace;

  SpaceInfo(this.workSpace);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
        elevation: 0.0,
        color: Colors.white,
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                      child: Container(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                        Text(
                          "Cetificates",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "GoogleSansRegular",
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Padding(
                          padding: EdgeInsets.all(1.0),
                        ),
                        HorizontalDivider(colorPrimary, 2.0, 50.0),
                        Padding(
                          padding: EdgeInsets.all(5.0),
                        ),
                        workSpace.spaceInfo != null &&
                                workSpace.spaceInfo.length > 0
                            ? Container(
                                height: 100.0,
                                child: new ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: workSpace.spaceInfo.length,
                                    itemBuilder:
                                        (BuildContext ctxt, int Index) {
                                      return Padding(
                                          padding: EdgeInsets.all(12.0),
                                          child: Container(
                                            child: new Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Image.network(
                                                  workSpace.spaceInfo.values
                                                      .elementAt(Index),
                                                  height: 40.0,
                                                  width: 40.0,
                                                  color: colorPrimary,
                                                  colorBlendMode:
                                                      BlendMode.lighten,
                                                  fit: BoxFit.cover,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    workSpace.spaceInfo.keys
                                                        .elementAt(Index),
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "GoogleSansRegular",
                                                        fontSize: 12.0,
                                                        color: Colors.black),
                                                    softWrap: true,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ));
                                    }),
                              )
                            : Padding(
                                padding: EdgeInsets.all(1.0),
                              ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                        ),
//                        Text(
//                          "Ambience and Seating",
//                          textAlign: TextAlign.start,
//                          style: TextStyle(
//                              fontFamily: "GoogleSansRegular",
//                              fontSize: 16.0,
//                              fontWeight: FontWeight.bold,
//                              color: Colors.black),
//                        ),
                        Padding(
                          padding: EdgeInsets.all(5.0),
                        ),
                        workSpace.ambienceSeating != null &&
                                workSpace.ambienceSeating.length > 0
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: workSpace.ambienceSeating.length,
                                itemBuilder: (BuildContext ctxt, int Index) {
//                    print("i" + snapshot.data['pictures'][Index].toString());
                                  return Padding(
                                    padding: EdgeInsets.only(right: 2.0),
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          workSpace.ambienceSeating.keys
                                              .elementAt(Index),
                                          style: TextStyle(
                                              fontFamily: "GoogleSansRegular",
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 20.0),
                                        ),
                                        Text(
                                          workSpace.ambienceSeating.values
                                              .elementAt(Index),
                                          style: TextStyle(
                                              fontFamily: "GoogleSansRegular",
                                              fontSize: 14.0,
                                              color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                  );
                                })
                            : Padding(
                                padding: EdgeInsets.all(1.0),
                              ),
                      ])))
                ])));
  }
}

class AboutAndAddress extends StatelessWidget {
  WorkSpace workSpace;

  AboutAndAddress(this.workSpace);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      elevation: 0.0,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "About:",
                      style: TextStyle(
                          fontFamily: "GoogleSansRegular",
                          fontSize: 16.0,
                          color: Colors.black54),
                    ),
                    Text(
                      workSpace.about,
                      style: TextStyle(
                          fontFamily: "GoogleSansRegular",
                          fontSize: 14.0,
                          color: Colors.black),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                    ),
                    Divider(height: 1.0, color: Colors.black54),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                    ),
                    Text(
                      "Address:",
                      style: TextStyle(
                          fontFamily: "GoogleSansRegular",
                          fontSize: 16.0,
                          color: Colors.black54),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            workSpace.address.streetAddress,
                            style: TextStyle(
                                fontFamily: "GoogleSansRegular",
                                fontSize: 14.0,
                                color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                        ),
                        Image.network(
                          "https://maps.googleapis.com/maps/api/staticmap?center=${workSpace.address.lat},${workSpace.address.lng}&zoom=18&size=640x400&key=AIzaSyAlVrEyOOalLJDd11N95KkvTxxRmpO6p0w",
//                        'https://maps.googleapis.com/maps/api/staticmap?center=Brooklyn+Bridge,New+York,NY&zoom=13&size=600x300&maptype=roadmap &markers=color:blue%7Clabel:S%7C40.702147,-74.015794&markers=color:green%7Clabel:G%7C40.711614,-74.012318 &markers=color:red%7Clabel:C%7C40.718217,-73.998284 &key=YOUR_API_KEY',
                          width: 100.0,
                          height: 100.0,
                        )
                      ],
                    )
                  ],
                )),
              )
            ]),
      ),
    );
  }
}

class WorkSpaceName extends StatelessWidget {
  WorkSpace workSpace;

  WorkSpaceName(this.workSpace);

  _launchURL(url) async {
//    const url = 'https://flutter.io';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      elevation: 0.0,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    workSpace.name,
                    style: TextStyle(
                        fontFamily: "GoogleSansRegular",
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Padding(
                    padding: EdgeInsets.all(3.0),
                  ),
                  Text(
                    workSpace.address.locality + " , " + workSpace.address.city,
                    style: TextStyle(
                        fontFamily: "GoogleSansRegular",
                        fontSize: 14.0,
                        color: Colors.black54),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.calendar_today,
                        color: Colors.black,
                        size: 15.0,
                      ),
                      Padding(
                        padding: EdgeInsets.all(3.0),
                      ),
                      Text(
                        "Monday to Friday",
                        style: TextStyle(
                            fontFamily: "GoogleSansRegular",
                            fontSize: 14.0,
                            color: Colors.black),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.access_time,
                        color: Colors.black,
                        size: 15.0,
                      ),
                      Padding(
                        padding: EdgeInsets.all(3.0),
                      ),
                      Text(
                        workSpace.getTimings(),
                        style: TextStyle(
                            fontFamily: "GoogleSansRegular",
                            fontSize: 14.0,
                            color: Colors.black),
                      )
                    ],
                  )
                ],
              ),
            ),
            Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    _launchURL("tel:+91 " + workSpace.contactNo);
//                    _launchURL("tel:+1 555 010 999");
                  },
                  child: Icon(
                    Icons.call,
                    color: Colors.green,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                      color: colorPrimary,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      workSpace.category,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: "GoogleSansRegular",
                          fontSize: 14.0,
                          color: Colors.white),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
