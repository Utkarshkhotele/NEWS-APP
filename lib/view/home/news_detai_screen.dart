import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NewsDetailScreen extends StatelessWidget {
  final String newsImage;
  final String newsTitle;
  final String newsDate;
  final String newsAuthor;
  final String newsDesc;
  final String newsContent;
  final String newsSource;

  const NewsDetailScreen(
      this.newsImage,
      this.newsTitle,
      this.newsDate,
      this.newsAuthor,
      this.newsDesc,
      this.newsContent,
      this.newsSource, {
        Key? key,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Kwidth = MediaQuery.of(context).size.width;
    final Kheight = MediaQuery.of(context).size.height;
    final DateTime dateTime =
        DateTime.tryParse(newsDate) ?? DateTime.now();
    final format = DateFormat('MMM dd, yyyy');

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            expandedHeight: Kheight * 0.35,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: newsImage,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: newsImage,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (_, __, ___) => Container(
                        color: Colors.grey[300],
                        child: Icon(Icons.broken_image, size: 50),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.bookmark_border, color: Colors.black),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.share, color: Colors.black),
                onPressed: () {},
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    newsTitle,
                    style: GoogleFonts.montserrat(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        format.format(dateTime),
                        style: GoogleFonts.montserrat(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.source, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          newsSource,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(
                            fontSize: 13,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 30),
                  if (newsDesc.isNotEmpty)
                    Text(
                      newsDesc,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.6,
                      ),
                    ),
                  const SizedBox(height: 24),
                  if (newsContent.isNotEmpty)
                    Text(
                      newsContent,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.grey[800],
                        height: 1.6,
                      ),
                    ),
                  const SizedBox(height: 30),
                  if (newsAuthor.isNotEmpty)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Written by $newsAuthor',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


