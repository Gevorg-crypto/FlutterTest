import 'package:flutter/material.dart';

class AnimatedFavoriteStar extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onTap;

  const AnimatedFavoriteStar({
    Key? key,
    required this.isFavorite,
    required this.onTap,
  }) : super(key: key);

  @override
  _AnimatedFavoriteStarState createState() => _AnimatedFavoriteStarState();
}

class _AnimatedFavoriteStarState extends State<AnimatedFavoriteStar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _starFillAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _starFillAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.isFavorite) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedFavoriteStar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFavorite != oldWidget.isFavorite) {
      if (widget.isFavorite) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildStar() {
    return AnimatedBuilder(
      animation: _starFillAnimation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.star_border,
              size: 40,
              color: Colors.grey[400],
            ),
            ClipRect(
              clipper: _StarClipper(_starFillAnimation.value),
              child: const Icon(
                Icons.star,
                size: 40,
                color: Colors.amber,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: _buildStar(),
    );
  }
}

class _StarClipper extends CustomClipper<Rect> {
  final double fillPercent;

  _StarClipper(this.fillPercent);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width * fillPercent, size.height);
  }

  @override
  bool shouldReclip(covariant _StarClipper oldClipper) {
    return oldClipper.fillPercent != fillPercent;
  }
}
