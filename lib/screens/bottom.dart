import 'package:beepo/constants/constants.dart';
import 'package:flutter/material.dart';

class bottom extends StatelessWidget {
  const bottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
      bottomSheet: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Container(
          height: 100,
          child: Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.white,
                ),
                width: double.infinity,
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: "type message",
                    hintStyle: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
