import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';
import 'package:wallpaper_world/components/title_widget.dart';
import 'package:wallpaper_world/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper_world/controller/api_controller.dart';
import 'package:wallpaper_world/screens/wallpaper_list_screen.dart';
// import 'package:wallpaper_world/models/pixelapimodel.dart';

import '../widgets/homescreen/bestofmonth_listview.dart';
import '../widgets/homescreen/category_gridview.dart';
import '../widgets/homescreen/color_listview.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchTxt = TextEditingController();
// for trending images

final ScrollController _scrollController = ScrollController();
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(addPagination);
    context.read<ApiController>().fetchBestImages(page: pageCount);
  }

  int pageCount = 1;

  void addPagination() {
    if (_scrollController.offset ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        pageCount++;
      });

      context.read<ApiController>().fetchBestImages(page: pageCount);
    }
  }





  @override
  Widget build(BuildContext context) {
    var providerList = context.watch<ApiController>().bestOfTheMonth;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 216, 235, 239),
                Color.fromARGB(255, 230, 238, 240),
                Color.fromARGB(255, 238, 241, 242),
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).width * .20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.sizeOf(context).width * .06),
                  child: TextField(
                    onTapOutside: (e) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    controller: searchTxt,
                    keyboardType: TextInputType.text,
                    style: GoogleFonts.aBeeZee(color: Colors.grey.shade400),
                    decoration: InputDecoration(
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 6,
                          ),
                          GestureDetector(
                            onTap: () {

                              var txt = searchTxt.text.trim().toString();
                              if (txt.isEmpty) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text("Blank Search Field"),
                                        actions: [
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Ok"))
                                        ],
                                      );
                                    });
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            WallpaperListScreen(
                                                title: txt)));
                                searchTxt.clear();
                              }

                            
                            },
                            child: const Icon(
                              UniconsLine.search,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                      suffixIconColor: Colors.grey.shade300,
                      hintText: "Find Wallpaper..",
                      hintStyle:
                          GoogleFonts.aBeeZee(color: Colors.grey.shade400),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 16),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).width * .10,
                ),
               
               
              
                    
                TitleAndWidget(
                        title: "Best of the month",
                        child: CustomPageView(
                      controller: _scrollController,
                            height: 225,
                            width: MediaQuery.sizeOf(context).width * .39,
                      bestofthemonthData: providerList),
                ),
                   
                SizedBox(
                  height: MediaQuery.sizeOf(context).width * .10,
                ),
                TitleAndWidget(
                  title: "The color tone",
                  child: ColorToneListView(
                      height: 50, widht: 50, colorData: colorTone),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).width * .10,
                ),
                const TitleAndWidget(
                    title: "Categories", child: CustomCategoryGridView())
              ],
            ),
          ),
        ),
      ),
    );
  }
}
