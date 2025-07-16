import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../bloc/news_bloc.dart';
import '../../../bloc/news_event.dart';
import '../../home/cateogires_screen.dart';

enum FilterList { bbcNews, aryNews, independent, reuters, cnn, alJazeera }

FilterList? selectedMenu;

class HomeAppBarWidget extends StatelessWidget {
  HomeAppBarWidget({Key? key}) : super(key: key);

  String name = 'bbc-news';

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.5,
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CategoriesScreen()),
          );
        },
        icon: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.indigo.shade50,
          ),
          child: Image.asset(
            'images/category_icon.png',
            height: 24,
            width: 24,
          ),
        ),
      ),
      title: Text(
        'Top Headlines',
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.indigo[900],
        ),
      ),
      actions: [
        PopupMenuButton<FilterList>(
          initialValue: selectedMenu,
          icon: const Icon(Icons.more_vert, color: Colors.black87),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onSelected: (FilterList item) {
            switch (item) {
              case FilterList.bbcNews:
                name = 'bbc-news';
                break;
              case FilterList.aryNews:
                name = 'ary-news';
                break;
              case FilterList.alJazeera:
                name = 'al-jazeera-english';
                break;
              default:
                name = 'bbc-news';
            }

            context.read<NewsBloc>().add(FetchNewsChannelHeadlines(name));
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<FilterList>>[
            _buildPopupItem(FilterList.bbcNews, 'BBC News'),
            _buildPopupItem(FilterList.aryNews, 'Ary News'),
            _buildPopupItem(FilterList.alJazeera, 'Al-Jazeera'),
          ],
        ),
      ],
    );
  }

  PopupMenuItem<FilterList> _buildPopupItem(FilterList value, String text) {
    return PopupMenuItem<FilterList>(
      value: value,
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
    );
  }
}

