import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/screens/eventDetailScreen.dart';

import '../blocs/home_bloc.dart';
import 'package:intl/intl.dart';


class Homescreen extends StatefulWidget {
  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {

  var selectedEvents="All Events";
  List events=["All Events","Startups","Technology","Other"];

  getEventDate(startdate,endDate){
    var startmonthdate=DateFormat('dd MMM').format(DateTime.parse(startdate));
    var endmonthdate=DateFormat('dd MMM').format(DateTime.parse(endDate));
    return "  ${startmonthdate + " " + endmonthdate }";
  }
  getEventTime(startdate,endDate){
    var startmonthdate=DateFormat('KK:mm a').format(DateTime.parse(startdate));
    var endmonthdate=DateFormat('KK:mm a').format(DateTime.parse(endDate));
    return "  ${startmonthdate + " " + endmonthdate }";
  }


  @override
  Widget build(BuildContext context) {
    final EventBloc eventBloc = BlocProvider.of<EventBloc>(context);

    eventBloc.add(FetchEventListEvent());

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        elevation: 0,
        backgroundColor: Colors.white,
        leading:Icon(Icons.location_on,color: Colors.black87,),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text("${ DateFormat('dd/MM/yyyy').format(selected)}")
            Text("Saturday,07 April",style: TextStyle(color: Colors.black87,fontSize: 15),),
            SizedBox(height: 3,),
            Text("Kalayani Nagar Pune,Maharastra",style: TextStyle(color: Colors.black87.withOpacity(0.7),fontSize: 13,overflow: TextOverflow.ellipsis),),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.search,color: Colors.black87,),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.notifications_none,color: Colors.black87,),
          )
        ],

      ),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Divider(height:1,thickness: 1.5,color: Colors.grey,),
                Container(
                  padding: EdgeInsets.only(top: 20,),
                  alignment: Alignment.centerLeft,
                  child: Text("Browse by categories",style: TextStyle(color: Colors.black87,fontSize: 15,fontWeight: FontWeight.w700),),
                ),
                Container(
                  height: 40,
                  child: ListView.builder(
                      itemCount: events.length,
                      itemBuilder:(context,i){
                        return  GestureDetector(
                          onTap: (){
                            setState(() {
                              selectedEvents=events[i];
                            });
                            if(events[i]=="All Events") {
                              eventBloc.add(FetchEventListEvent());
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 15,top: 10),
                            decoration: BoxDecoration(
                              color: selectedEvents==events[i]?Colors.blueAccent:Colors.white,
                              border: Border.all(
                                color: Colors.black87,
                              ),
                              borderRadius: BorderRadius.circular(5)
                            ),
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(left: 10,right: 10),
                            child:Text(events[i],style: TextStyle(fontSize: 13,color: selectedEvents==events[i]?Colors.white:Colors.black87),) ,
                          ),
                        );
                      },
                    scrollDirection: Axis.horizontal,

                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 20,),
                      alignment: Alignment.centerLeft,
                      child: Text("Explore Local Events In Your Area",style: TextStyle(color: Colors.black87,fontSize: 15,fontWeight: FontWeight.w700),),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20,),
                      alignment: Alignment.centerLeft,
                      child: Text("show more",style: TextStyle(color: Colors.blue,fontSize: 15,fontWeight: FontWeight.w700),),
                    ),

                  ],
                ),


                Expanded(
                    child:selectedEvents=="All Events"? BlocBuilder<EventBloc, EventState>(
                  builder: (context, state) {
                    if (state is EventLoadingState) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is EventLoadedState) {
                      return ListView.builder(
                        itemCount: state.events.length,
                        itemBuilder: (context, index) {
                          final event = state.events[index];
                          return GestureDetector(
                            onTap: (){
                              print("********************");
                              print(event['id']);
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>EventDetailScreen(id:event['_id'])));
                            },
                            child: Card(
                              // margin: EdgeInsets.only(left: 2,right: 2,top: 0,bottom: 0),
                              child: Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image(
                                          image: NetworkImage(event['eventBanner']),
                                          height: 90,
                                          width: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),

                                    Expanded(
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: (MediaQuery.of(context).size.width*0.9),
                                            padding: EdgeInsets.only(left: 10,right:10, top: 10),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [

                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(children: [
                                                      Icon(Icons.calendar_today,color: Colors.black87.withOpacity(0.7),size: 12,),
                                                      Text(getEventDate(event['startDate'],event['endDate']),style: TextStyle(fontSize: 10),)
                                                    ],),
                                                    Row(children: [
                                                      Icon(Icons.access_time,color: Colors.black87.withOpacity(0.7),size: 12,),
                                                      Text(getEventTime(event['startDate'],event['endDate']),style: TextStyle(fontSize: 10),)
                                                    ],),
                                                  ],
                                                ),
                                                SizedBox(height: 8,),
                                                Text(event['eventName'],overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 15,color: Colors.black87,fontWeight: FontWeight.w700),),
                                                SizedBox(height: 8,),
                                                Row(
                                                  children: [
                                                  Icon(Icons.location_on,color: Colors.black87.withOpacity(0.7),size: 12,),
                                                  Container(
                                                      width: (MediaQuery.of(context).size.width*0.9)-150,
                                                      child: Text("  ${event['venue']}",overflow: TextOverflow.ellipsis,)
                                                  ),
                                                ],
                                                ),
                                                SizedBox(height: 8,),
                                                Row(children: [
                                                  Icon(Icons.people,color: Colors.black87.withOpacity(0.7),size: 15,),
                                                  Text("  Booking Limit-${event['bookingMaxLimit']}",style: TextStyle(fontSize: 13),)
                                                ],),
                                                SizedBox(height: 40,),

                                              ],
                                            ),
                                          ),
                                          Positioned(
                                              bottom: -6,
                                              right: 0,
                                            child: MaterialButton(
                                              onPressed: (){},
                                              elevation: 0,
                                              color:event['generalInfo']=="Free"?Colors.amberAccent.withOpacity(0.8): Colors.amber,
                                              textColor: Colors.black87,
                                              child: Text("${event['generalInfo']}"),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is EventErrorState) {
                      return Center(
                        child: Text('Error: ${state.error}'),
                      );
                    }
                    return Container();
                  },
                ):
                    Container(
                      margin: EdgeInsets.only(top: 50),
                      child: Text("No ${selectedEvents} Events Available"),
                    ))


              ],
            ),
          )
      ),
    );
  }
}

