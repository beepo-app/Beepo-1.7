import 'dart:io';
import 'dart:typed_data';

import 'package:Beepo/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatusView extends StatefulWidget {
  final Uint8List img;
  const StatusView({super.key, required this.img});

  @override
  State<StatusView> createState() => _StatusViewState();
}

class _StatusViewState extends State<StatusView> {
  final input = TextEditingController();
  final List<String> items = ['Public', 'Private'];
  String selectedItem = 'Public';

  void uploadStatus() async {
    print(input.text);
    print(input.text);
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: const BorderSide(color: AppColors.white),
    );

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        textDirection: TextDirection.rtl,
        clipBehavior: Clip.hardEdge,
        children: <Widget>[
          Positioned(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: MemoryImage(widget.img),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 26,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                      ),
                      child: TextField(
                        onSubmitted: (value) {
                          // uploadStatus;
                        },
                        controller: input,
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: AppColors.secondaryColor,
                        ),
                        decoration: InputDecoration(
                          fillColor: AppColors.white,
                          filled: true,
                          border: border,
                          focusedBorder: border,
                          enabledBorder: border,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          hintText: "Type message...",
                          hintStyle: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: AppColors.secondaryColor,
                          ),
                        ),
                        // expands: true,

                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 5,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  GestureDetector(
                    onTap: () {
                      uploadStatus();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      height: 25.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors.secondaryColor,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.send,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            // height: 50,
            top: 30,
            right: 10,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(14)),
              ),
              alignment: Alignment.topLeft,
              child: PopupMenuButton<String>(
                position: PopupMenuPosition.under,
                initialValue: selectedItem,
                onSelected: (String item) {
                  setState(() {
                    selectedItem = item;
                  });
                },
                itemBuilder: (BuildContext context) {
                  return items.map((String item) {
                    return PopupMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          color: AppColors.black, // Change text color
                        ),
                      ),
                    );
                  }).toList();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          selectedItem,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.white,
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          size: 25,
                          color: AppColors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
