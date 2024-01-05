import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:wallpaper_world/controller/api_controller.dart';
import 'package:wallpaper_world/widgets/wallpaperlist_screen/staggerdgridview.dart';
import 'package:lottie/lottie.dart';

class WallpaperListScreen extends StatefulWidget {
  const WallpaperListScreen({super.key, required this.title});

  final String title;

  @override
  State<WallpaperListScreen> createState() => _WallpaperListScreenState();
}

class _WallpaperListScreenState extends State<WallpaperListScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    context
        .read<ApiController>()
        .fetchImages(keyWord: widget.title, page: pageCount);
    _scrollController.addListener(addPagination);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.removeListener(addPagination);

    super.dispose();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    removeItems();
    super.deactivate();
  }

  void removeItems() {
    context.read<ApiController>().resetList();
  }

  final ScrollController _scrollController = ScrollController();

  int pageCount = 1;

  void addPagination() {
    if (_scrollController.offset ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        pageCount++;
      });
      context
          .read<ApiController>()
          .fetchImages(keyWord: widget.title, page: pageCount);
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<ApiController>();

    return Scaffold(
      body: SafeArea(
          child: provider.totalResults == 0
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        "assets/animation/no-wallpaper.json",
                        reverse: true,
                        frameRate: FrameRate(10),
                      ),
                      Text("No Wallpaper Found!",
                          style: GoogleFonts.aBeeZee(
                              fontWeight: FontWeight.bold, fontSize: 22))
                    ],
                  ),
                )
              : provider.listPhotos.isEmpty
              ? const Center(
                  child: RefreshProgressIndicator(),
                )
                  : 
                  Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 216, 235, 239),
                              Color.fromARGB(255, 230, 238, 240),
                              Color.fromARGB(255, 238, 241, 242),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            MediaQuery.sizeOf(context).width * .06,
                            MediaQuery.sizeOf(context).width * .20,
                            MediaQuery.sizeOf(context).width * .06,
                            0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: GoogleFonts.aBeeZee(
                                  fontSize: 48, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: MediaQuery.sizeOf(context).width * .03,
                            ),
                            Text(
                              "${provider.totalResults} wallpaper available",
                              style: GoogleFonts.aBeeZee(
                                  color: Colors.grey.shade700, fontSize: 18),
                            ),
                            SizedBox(
                              height: MediaQuery.sizeOf(context).width * .03,
                            ),
                            Expanded(
                                child: CustomStaggeredGridView(
                              scrollController: _scrollController,
                              totalResults: provider.totalResults,
                              img: provider.listPhotos,
                              title: widget.title,
                            ))
                          ],
                        ),
                      ),
                    )),
    );
  }
}
