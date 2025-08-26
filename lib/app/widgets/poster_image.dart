import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../data/models/dto/configuration.dart';
import '../data/models/dto/episode.dart';
import '../data/models/dto/movie.dart';

class PosterImage extends StatelessWidget {
  const PosterImage({
    super.key,
    this.movie,
    this.episode,
    this.config,
    this.original = false,
    this.width,
    this.height,
    this.backdrop = false,
    this.borderRadius,
  });

  final Movie? movie;
  final Configuration? config;
  final Episode? episode;
  final bool original;
  final bool backdrop;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final images = config?.images;
    final imageAvailable =
        movie?.posterPath != null ||
        episode?.stillPath != null ||
        movie?.backdropPath != null && backdrop;
    final url = (imageAvailable
        ? backdrop
              ? '${images?.baseUrl}/${original ? 'original' : images?.backdropSizes[1]}${movie?.backdropPath}'
              : movie?.posterPath != null
              ? '${images?.baseUrl}/${original ? 'original' : images?.posterSizes[1]}${movie?.posterPath}'
              : '${images?.baseUrl}/${original ? 'original' : images?.stillSizes[3]}${episode?.stillPath}'
        : null);
    return imageAvailable
        ? url != null
              ? CachedNetworkImage(
                  imageUrl: url,
                  imageBuilder: (context, imageProvider) => ClipRRect(
                    borderRadius: borderRadius ?? BorderRadius.circular(8.0),
                    child: Image(
                      image: imageProvider,
                      fit: BoxFit.cover,
                      width: width,
                      height: height,
                    ),
                  ),
                  placeholder: (context, url) => Shimmer(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        Colors.grey[900]!,
                        Colors.grey[900]!,
                        Colors.grey[800]!,
                        Colors.grey[900]!,
                        Colors.grey[900]!,
                      ],
                      stops: const <double>[0.0, 0.35, 0.5, 0.65, 1.0],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            borderRadius ?? BorderRadius.circular(8.0),
                        color: Colors.black,
                      ),
                      width:
                          width ??
                          (original || backdrop ? double.infinity : 150.0),
                      height: height ?? (original || backdrop ? 180.0 : 68.0),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 110.0,
                    height: 220.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.grey,
                    ),
                    child: Image.asset('assets/netflix_symbol.png'),
                  ),
                )
              : Image.asset('assets/netflix_symbol.png')
        : Container(
            width: 110.0,
            height: 220.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.grey,
            ),
            child: Image.asset('assets/netflix_symbol.png'),
          );
  }
}
