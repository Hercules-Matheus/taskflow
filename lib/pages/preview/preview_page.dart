import 'package:flutter/material.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:taskflow/assets/colors/app_colors.dart';

class PreviewPage extends StatelessWidget {
  final File file;

  const PreviewPage({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.file(
                    file,
                    fit: BoxFit.cover,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: CircleAvatar(
                          radius: 32,
                          backgroundColor: AppColors.primaryGreenColor,
                          child: IconButton(
                            onPressed: () => Get.back(result: file),
                            icon: const Icon(
                              Icons.check,
                              color: AppColors.primaryWhiteColor,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: CircleAvatar(
                          radius: 32,
                          backgroundColor: AppColors.primaryRedColor,
                          child: IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(
                              Icons.close,
                              color: AppColors.primaryWhiteColor,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
