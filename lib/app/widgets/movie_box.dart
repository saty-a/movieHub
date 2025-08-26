import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/dto/configuration.dart';
import '../data/models/dto/movie.dart';
import '../routes/app_pages.dart';
import 'poster_image.dart';

class MovieBox extends StatelessWidget {
  const MovieBox(
      {super.key,
        required this.movie,
        required this.config,
        this.laughs,
        this.fill = false,
        this.padding});

  final Movie movie;
  final int? laughs;
  final bool fill;
  final Configuration config;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      padding ?? const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      child: InkWell(
        onTap: () {
          Get.toNamed(Routes.MOVIE_DETAIL,arguments: [movie,config]);
        },
        child: Stack(
          children: [
            fill
                ? Positioned.fill(
                child:
                PosterImage(movie: movie, width: 110.0, height: 220.0,config: config,))
                : PosterImage(movie: movie, width: 110.0, height: 220.0,config: config,),
            Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  'assets/netflix_symbol.png',
                  width: 24.0,
                )),
            if (laughs != null)
              Positioned(
                bottom: 2.0,
                left: 4.0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('\u{1F602}'),
                    Text(
                      '${laughs}K',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
