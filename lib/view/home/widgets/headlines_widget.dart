import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app/bloc/news_bloc.dart';
import 'package:flutter_news_app/bloc/news_states.dart';
import 'package:flutter_news_app/view/home/news_detai_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HeadlinesWidget extends StatelessWidget {
  final String dateAndTime;
  final int index;

  const HeadlinesWidget({
    Key? key,
    required this.dateAndTime,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    return BlocBuilder<NewsBloc, NewsState>(
      builder: (BuildContext context, state) {
        final article = state.newsList!.articles![index];

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDetailScreen(
                    article.urlToImage ?? '',
                    article.title ?? '',
                    article.publishedAt ?? '',
                    article.author ?? 'Unknown',
                    article.description ?? '',
                    article.content ?? '',
                    article.source?.name ?? '',
                  ),
                ),
              );
            },
            behavior: HitTestBehavior.translucent,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Hero(
                  tag: article.urlToImage ?? index,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: article.urlToImage ?? '',
                      height: height * 0.55,
                      width: width * 0.9,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: SpinKitCircle(
                          size: 40,
                          color: Colors.indigo,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        height: height * 0.55,
                        width: width * 0.9,
                        child: const Icon(Icons.broken_image, color: Colors.red),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  child: Container(
                    width: width * 0.78,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.title ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                article.source?.name ?? 'Unknown Source',
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.indigo,
                                ),
                              ),
                            ),
                            Text(
                              dateAndTime,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


