import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:task/blocs/eventdetail_bloc.dart';
import 'package:intl/intl.dart';

class EventDetailScreen extends StatefulWidget {
  final id;
  EventDetailScreen({this.id});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> with TickerProviderStateMixin {
  List<Tab> tabList =[];
  late TabController _tabController;

@override
  void initState() {

    // TODO: implement initState
  tabList.add(new Tab(text:'Event Info',));
  tabList.add(new Tab(text:'Agenda',));
  tabList.add(new Tab(text:'Sponsors',));
  tabList.add(new Tab(text:'Speakers',));
  _tabController = new TabController(vsync: this, length:
  tabList.length);
  super.initState();
  }
  getEventDate(startdate,endDate){
    var startmonthdate=DateFormat('EEE, dd MMMM , yyyy').format(DateTime.parse(startdate));
    return "  ${startmonthdate  }";
  }
  getEventTime(startdate,endDate){
    var startmonthdate=DateFormat('KK:mm a').format(DateTime.parse(startdate));
    var endmonthdate=DateFormat('dd MMM KK:mm a').format(DateTime.parse(endDate));
    return "  ${startmonthdate + " - " + endmonthdate }";
  }

  @override
  Widget build(BuildContext context) {

    final EventDetailsBloc eventdetailsBloc = BlocProvider.of<EventDetailsBloc>(context);

    eventdetailsBloc.add(FetchEventDetailsListEvent(widget.id));

    return BlocBuilder<EventDetailsBloc, EventDetailsState>(
      builder: (context, state) {
        if (state is EventDetailsLoadingState) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is EventDetailsLoadedState){
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                title: Text(''),
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.grey,
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: FaIcon(
                      FontAwesomeIcons.heart,
                      color: Colors.grey,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: FaIcon(
                      FontAwesomeIcons.locationArrow,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              bottomSheet: Card(
                elevation: 0,
                child: Container(
                  height: 70,
                  padding: EdgeInsets.all(10),
                  width: double.maxFinite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${state.events['generalInfo']}",overflow: TextOverflow.clip,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                          SizedBox(height: 5,),
                          Text("(No taxes needed)",overflow: TextOverflow.clip,style: TextStyle(fontSize: 13,),),

                        ],
                      ),

                      Container(
                        padding: const EdgeInsets.only(top: 5),
                        width:MediaQuery.of(context).size.width/2,
                        child: ElevatedButton(
                          onPressed: () {
                          },
                          child: Text('Register Now'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      Builder(
                        builder: (context) {
                          final double height = MediaQuery.of(context).size.height*0.3;
                          return CarouselSlider(
                            options: CarouselOptions(
                              height: height,
                              viewportFraction: 1.0,
                              enlargeCenterPage: false,
                              // autoPlay: true,
                            ),
                            items: ["${state.events['eventBanner']}","${state.events['eventBanner']}"]
                                .map((item) => Container(
                              margin: EdgeInsets.only(left: 10,right: 10),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    item,
                                    fit: BoxFit.cover,
                                    height: height,
                                  )),
                            ))
                                .toList(),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              // decoration: new BoxDecoration(color: Theme.of(context).primaryColor),
                              child:  TabBar(
                                  isScrollable: true,
                                  controller: _tabController,
                                  indicatorColor: Colors.grey,
                                  labelColor: Colors.black,
                                  unselectedLabelColor: Colors.grey,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  tabs: tabList
                              ),
                            ),
                            new Container(
                              height: 20.0,
                              child:  TabBarView(
                                controller: _tabController,
                                children: tabList.map((Tab tab){
                                  return tab=="Event Info"?  Container(child:Text("Event Info")):Container();

                                }).toList(),
                              ),
                            ),


                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.all(8),
                              child: Text("${state.events['eventName']}",textAlign: TextAlign.start,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 22,color: Colors.black87),),),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                          backgroundColor: Color(0xFFe4f3f5),
                                          radius: 20,
                                          child: FaIcon(FontAwesomeIcons.locationDot,size: 20,)),
                                      SizedBox(width: 10,),
                                      Container(
                                        width:(MediaQuery.of(context).size.width*0.9)-200 ,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("${state.events['location']}",overflow: TextOverflow.clip,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                                            SizedBox(height: 5,),
                                            Text("${state.events['venue']}",overflow: TextOverflow.clip,style: TextStyle(fontSize: 13,),),
                                          ],
                                        ),


                                      ),
                                    ],
                                  ),
                                  Text("View On map",style: TextStyle(fontSize: 13,color: Colors.blueAccent,decoration: TextDecoration.underline),),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                      backgroundColor: Color(0xFFe4f3f5),
                                      radius: 20,
                                      child: FaIcon(FontAwesomeIcons.calendar,size: 20,)),
                                  SizedBox(width: 10,),
                                  Container(
                                    width:(MediaQuery.of(context).size.width*0.9)-100 ,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("${getEventDate(state.events['startDate'],state.events['endDate'])}",overflow: TextOverflow.clip,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                                        SizedBox(height: 5,),
                                        Text("${getEventTime(state.events['startDate'],state.events['endDate'])}",overflow: TextOverflow.clip,style: TextStyle(fontSize: 13,),),
                                      ],
                                    ),


                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                          backgroundColor: Color(0xFFe4f3f5),
                                          radius: 20,
                                          child: FaIcon(FontAwesomeIcons.peopleGroup,size: 20,)),
                                      Container(
                                          width:(MediaQuery.of(context).size.width*0.9)-200 ,
                                          child:Text("")
                                      ),
                                    ],
                                  ),
                                  Text("Attendees   ",style: TextStyle(fontSize: 13,color: Colors.blueAccent,decoration: TextDecoration.underline),),
                                ],
                              ),
                            ),

                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.all(8),
                              child: Text("About",textAlign: TextAlign.start,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 22,color: Colors.black87),),),

                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.all(8),
                              child: Text("${state.events['description']}",textAlign: TextAlign.start,style: TextStyle(fontSize: 13,color: Colors.black87.withOpacity(0.7)),),),

                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.all(8),
                              child: Text("Hosted By",textAlign: TextAlign.start,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 22,color: Colors.black87),),),


                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.grey,
                                ),
                                SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${state.events['organiserName']}",textAlign: TextAlign.start,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: Colors.black87.withOpacity(0.7)),),
                                    Text("Co-founder and CEO ",style: TextStyle(fontSize: 13,),),

                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 5,),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.all(8),
                              child: Text("Need Help?",textAlign: TextAlign.start,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 22,color: Colors.black87),),),

                            Row(
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                        backgroundColor: Color(0xFFe4f3f5),
                                        radius: 20,
                                        child: FaIcon(FontAwesomeIcons.phone,size: 20,)),
                                    SizedBox(width: 10,),
                                    Text("Call us",style: TextStyle(fontSize: 15,),),

                                  ],
                                ),
                                SizedBox(width: 20,),
                                Row(
                                  children: [
                                    CircleAvatar(
                                        backgroundColor: Color(0xFFe4f3f5),
                                        radius: 20,
                                        child: FaIcon(FontAwesomeIcons.message,size: 20,)),
                                    SizedBox(width: 10,),
                                    Text("Chat with us",style: TextStyle(fontSize: 15,),),

                                  ],
                                ),

                              ],
                            ),

                          ],
                        ),
                      ),

                      Container(height: 100,)


                    ],
                  ),
                ),
              )
          );
        } else if (state is EventDetailsErrorState) {
          return Center(
            child: Text('Error: ${state.error}'),
          );
        }
        return Scaffold(
          body: Container(),
        );
      },
    )
      ;

  }


}
