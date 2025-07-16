import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../bloc/news_bloc.dart';
import '../../../bloc/news_event.dart';
import '../../../bloc/news_states.dart';
import 'headlines_widget.dart';
import 'home_app_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DateFormat format = DateFormat('MMMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    context.read<NewsBloc>()
      ..add(FetchNewsChannelHeadlines('bbc-news'))
      ..add(NewsCategories('general'));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: HomeAppBarWidget(),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<NewsBloc>()
              ..add(FetchNewsChannelHeadlines('bbc-news'))
              ..add(NewsCategories('general'));
          },
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: height * 0.02),
                child: SizedBox(
                  height: height * 0.5,
                  child: BlocBuilder<NewsBloc, NewsState>(
                    builder: (context, state) {
                      if (state.status == Status.initial) {
                        return const Center(
                          child: SpinKitCircle(color: Colors.teal, size: 40),
                        );
                      }
                      if (state.status == Status.failure) {
                        return Center(
                          child: Text(
                            state.message,
                            style: GoogleFonts.lato(color: Colors.redAccent, fontSize: 16),
                          ),
                        );
                      }
                      final articles = state.newsList?.articles ?? [];
                      if (articles.isEmpty) {
                        return const Center(
                          child: Text("No top headlines", style: TextStyle(color: Colors.grey)),
                        );
                      }
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: articles.length,
                        itemBuilder: (_, idx) {
                          final dateStr = articles[idx].publishedAt;
                          final date = DateTime.tryParse(dateStr ?? '') ?? DateTime.now();
                          return HeadlinesWidget(
                            dateAndTime: format.format(date),
                            index: idx,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.06, vertical: height * 0.015),
                child: Text(
                  'Latest Updates',
                  style: GoogleFonts.merriweather(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.06, vertical: height * 0.015),
                child: BlocBuilder<NewsBloc, NewsState>(
                  builder: (context, state) {
                    if (state.categoriesStatus == Status.initial) {
                      return const Center(
                        child: SpinKitFadingCircle(color: Colors.teal, size: 30),
                      );
                    }
                    if (state.categoriesStatus == Status.failure) {
                      return Center(
                        child: Text(
                          state.categoriesMessage,
                          style: GoogleFonts.lato(color: Colors.redAccent),
                        ),
                      );
                    }
                    final articles = state.newsCategoriesList?.articles ?? [];
                    if (articles.isEmpty) {
                      return const Center(
                        child: Text("No news found", style: TextStyle(color: Colors.grey)),
                      );
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: articles.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (_, idx) {
                        final art = articles[idx];
                        final date = DateTime.tryParse(art.publishedAt ?? '') ?? DateTime.now();
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              )
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Hero(
                                tag: art.urlToImage ?? idx,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CachedNetworkImage(
                                    imageUrl: art.urlToImage ?? '',
                                    width: width * 0.32,
                                    height: height * 0.18,
                                    fit: BoxFit.cover,
                                    placeholder: (_, __) => Container(
                                      width: width * 0.32,
                                      height: height * 0.18,
                                      color: Colors.grey[200],
                                      child: const Center(
                                        child: SpinKitThreeBounce(color: Colors.teal, size: 20),
                                      ),
                                    ),
                                    errorWidget: (_, __, ___) => Container(
                                      width: width * 0.32,
                                      height: height * 0.18,
                                      alignment: Alignment.center,
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.broken_image, color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: SizedBox(
                                  height: height * 0.18,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        art.title ?? '',
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.lora(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const Spacer(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              art.source?.name ?? '',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.lato(
                                                fontSize: 13,
                                                color: Colors.teal[700],
                                              ),
                                            ),
                                          ),
                                          Text(
                                            format.format(date),
                                            style: GoogleFonts.lato(
                                              fontSize: 12,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}




