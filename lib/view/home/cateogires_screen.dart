import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../bloc/news_bloc.dart';
import '../../bloc/news_event.dart';
import '../../bloc/news_states.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final format = DateFormat('MMM dd, yyyy');
  String categoryName = 'General';

  List<String> categoriesList = [
    'Entertainment',
    'Technology',
    'Business',
    'Health',
    'Sports',
    'General',
  ];

  @override
  void initState() {
    super.initState();
    context.read<NewsBloc>().add(NewsCategories(categoryName));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Top Headlines by Category"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: Column(
          children: [
            const SizedBox(height: 16),

            /// Category Selector
            SizedBox(
              height: 56,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoriesList.length,
                itemBuilder: (context, index) {
                  final isSelected = categoryName == categoriesList[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        categoryName = categoriesList[index];
                      });
                      context.read<NewsBloc>().add(NewsCategories(categoryName));
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? const LinearGradient(
                          colors: [Color(0xff4facfe), Color(0xff00f2fe)],
                        )
                            : const LinearGradient(
                          colors: [Color(0xffe0e0e0), Color(0xffeeeeee)],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          categoriesList[index],
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            /// Articles
            Expanded(
              child: BlocBuilder<NewsBloc, NewsState>(
                builder: (context, state) {
                  switch (state.categoriesStatus) {
                    case Status.initial:
                      return const Center(
                        child: SpinKitCircle(size: 50, color: Colors.teal),
                      );
                    case Status.failure:
                      return Center(
                        child: Text(
                          state.categoriesMessage ?? "Something went wrong",
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    case Status.success:
                      final articles = state.newsCategoriesList?.articles;
                      if (articles == null || articles.isEmpty) {
                        return const Center(
                          child: Text("No articles found"),
                        );
                      }
                      return ListView.builder(
                        itemCount: articles.length,
                        itemBuilder: (context, index) {
                          final article = articles[index];
                          final dateTime = DateTime.tryParse(article.publishedAt ?? '');

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Row(
                              children: [
                                Hero(
                                  tag: article.urlToImage ?? index,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      imageUrl: article.urlToImage ?? '',
                                      fit: BoxFit.cover,
                                      height: height * 0.18,
                                      width: width * 0.3,
                                      placeholder: (context, url) => const Center(
                                        child: SpinKitCircle(
                                          size: 30,
                                          color: Colors.teal,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                      const Icon(Icons.error_outline, color: Colors.red),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: SizedBox(
                                    height: height * 0.18,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          article.title ?? '',
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const Spacer(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                article.source?.name ?? '',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  color: Colors.grey[700],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              dateTime != null ? format.format(dateTime) : '',
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

