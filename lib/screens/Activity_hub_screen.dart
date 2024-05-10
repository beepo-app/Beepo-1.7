import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Beepo/widgets/activity_hub_tasks.dart';

class ActivityHubScreen extends StatelessWidget {
  const ActivityHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: const Text('Activity Hub',
        style: TextStyle(
          fontWeight: FontWeight.w700,
        ),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
          size: 30,),
          onPressed: () {},
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff0e014C),
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 15,),
              Container(
                  color: const Color.fromRGBO(241, 240, 240, 1),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                       mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                    children:[
                                       
                    const Text('Beeper Rank',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff0e014C),
                    ),),
                    const SizedBox(
                      height: 5,
                    ),
                      Row(
                      children: [
                        Image.asset(
                                            'assets/images/Group 1459.png',
                                            height: 35,
                                            width: 35,
                                         
                                        ),
                        const SizedBox(width: 10,),
                        const Text('Professional',
                         style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff0e014C),
                          ),),
                        const SizedBox(
                          width: 97,
                        ),
                      Image.asset(
                                          'assets/images/Info.png',
                                          
                                      // color: const Color(0xff0E014C),
                                      height: 28,
                                      width: 28,),
                      ],
)],
                                   ),
                  ),
          
              ),
              const SizedBox(height: 15,),

              Container(
                 color: const Color.fromRGBO(241, 240, 240, 1),
                 child: Padding(
                   padding: const EdgeInsets.all(15.0),
                   child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                               width: 40.0, 
                               height: 40.0, 
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(50),
                                 color: const Color.fromRGBO(231, 231, 231, 1)
                               ),
                               child: Image.asset(
                                              'assets/images/Group.png',
                                           
                                          ), 
                                
                                 
                              
                             ),
                             const SizedBox(width: 15,),
                             const Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Total Referrals',
                                 style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff0e014C),
                    ),),
                    SizedBox(height: 1,),
                    Text('105',
                     style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(250, 145, 8, 1),
                    ),)
                              ],
                             ),
                              const SizedBox(
                          width: 100,
                        ),
                            Image.asset(
                                              'assets/images/copy.png',
                                              height: 30,
                                              width: 30,
                                           
                                          ),
                      
                      const SizedBox(width: 20,),
                      const Icon(
                        CupertinoIcons.globe,
                        size: 30,
                      color: Color.fromRGBO(202, 200, 200, 1),
                      ),
                    ],
                   ),
                 ),
  
              ),
              const SizedBox(height: 15,),
             Container(
                 color: const Color.fromRGBO(241, 240, 240, 1),
                 child: Padding(
                   padding: const EdgeInsets.all(10.0),
                   child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                               width: 40.0, 
                               height: 40.0, 
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(50),
                                 color: const Color.fromRGBO(231, 231, 231, 1)
                               ),
                                child: Image.asset(
                                              'assets/images/Vector.png',
                                           height: 25,
                                           width: 25,
                                          ),
                             ),
                             const SizedBox(width: 15,),
                             const Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Beep Points Earned',
                                 style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff0e014C),
                    ),),
                    SizedBox(height: 1,),
                    Text('10,465',
                     style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(250, 145, 8, 1),
                    ),)
                              ],
                             ),
                              const SizedBox(
                          width: 70,
                        ),
                         ElevatedButton(
                          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), 
              ),
               backgroundColor: const Color(0xffD9D9D9),
                foregroundColor: const Color(0xff263238),
                fixedSize: Size(120, 1),
     

              // maximumSize: 
            ),
            onPressed: () { },
            child: const Text('Withdraw'), 
          ),
                    ],
                   ),
                 ),),
                 const SizedBox(height: 15,),
             Container(
                 color: const Color.fromRGBO(241, 240, 240, 1),
                 child: Padding(
                   padding: const EdgeInsets.all(10.0),
                   child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                               width: 40.0, 
                               height: 40.0, 
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(50),
                                 color: const Color.fromRGBO(231, 231, 231, 1)
                               ),
                                child: Image.asset(
                                              'assets/images/Time.png',
                                           
                                          ),
                             ),
                             const SizedBox(width: 15,),
                             const Text('Daily Login Point',
                              style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff0e014C),
                    ),),
                              const SizedBox(
                          width: 80,
                        ),
                         ElevatedButton(
                          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), 
              ),
               backgroundColor: const Color(0xffD9D9D9),
                foregroundColor: const Color(0xff263238),
                 fixedSize: Size(120, 1),

              // maximumSize: 
            ),
            onPressed: () { },
            
            child: const Text('Claim'), 
          ),
                    ],
                   ),
                 ),),
                  const SizedBox(height: 35,),
                          const Align(
                            
            alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text('Featured Tasks',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            ),
          ),),

          const SizedBox(height: 10,),

           ActivityButton(mytext: 'Send 100 messages', 
               buttontext: '100p'
               ,
                press: () {  }, 
                myiconn: Image.asset(
                    'assets/images/Chat.png',
                    
                //color: const Color(0xff0e014C),
                height: 25,
                width: 25,),
            
                ),

                const SizedBox(height: 10,),
                 ActivityButton(mytext: 'Stay active for 3hrs', 
               buttontext: '500p' ,
                press: () {  }, 
                myiconn: Image.asset(
                    'assets/images/Check.png',
                    
               // color: const Color(0xff0e014C),
                height: 25,
                width: 25,),
                )
                ,
              const SizedBox(height: 10,),
                 ActivityButton(mytext: 'Daily Moment Point', 
              buttontext: '50p',
                press: () {  }, 
                myiconn: Image.asset(
                    'assets/images/add whatsapp status.png',
                    
                //color: const Color(0xff0e014C),
                height: 25,
                width: 25,),
          ),
            ],
          ),

        ),
      ),
    );
  }
}
