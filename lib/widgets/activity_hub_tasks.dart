import 'package:flutter/material.dart';

class ActivityButton extends StatelessWidget {
   const ActivityButton({super.key, required this.mytext, required this.buttontext, required this.press, required this.myiconn});

   final String mytext;
   final String buttontext;
   final Widget myiconn;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return  Container(
       color: const Color.fromRGBO(241, 240, 240, 1),
       child: Padding(
         padding: const EdgeInsets.all(15.0),
         child: Row(
         // mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            myiconn,
            const SizedBox(width: 20,),
            Text(mytext,
             style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff0E014C),
                  ),),
                  SizedBox(width: 90,),
              Center(
                child: Text(buttontext, style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(250, 145, 8, 1),
                      ),),
              )
          ],
         ),
       ));
  }
}
