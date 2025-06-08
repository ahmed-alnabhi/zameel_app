import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerEffect extends StatefulWidget {
  const ShimmerEffect({super.key});

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect> {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor:Theme.of(context).brightness == Brightness.light
          ? Colors.grey[300]!
          : Colors.grey[800]!,
      highlightColor: Theme.of(context).brightness == Brightness.light
          ? Colors.grey[100]!
          : Colors.grey[800]!.withValues(alpha: 0.9),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5, // Number of shimmer placeholders
        itemBuilder: (context, index) {
          if (index == 1) {
            return ShimmerItem(hasImage: true);
          }
          return ShimmerItem();
        },
      ),
    );
  }
}

class ShimmerItem extends StatefulWidget {
  final bool hasImage;
  const ShimmerItem({super.key, this.hasImage = false});

  @override
  State<ShimmerItem> createState() => _ShimmerItemState();
}

class _ShimmerItemState extends State<ShimmerItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info row
          Row(
            children: [
              const CircleAvatar(radius: 20, backgroundColor: Colors.white),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 120, height: 16, color: Colors.white),
                  const SizedBox(height: 4),
                  Container(width: 80, height: 12, color: Colors.white),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Post content
          Container(width: double.infinity, height: 16, color: Colors.white),
          const SizedBox(height: 8),
          Container(width: double.infinity, height: 16, color: Colors.white),
          const SizedBox(height: 8),
          Container(width: 200, height: 16, color: Colors.white),
          const SizedBox(height: 16),

          // Post image placeholder
          if (widget.hasImage)
            Container(width: double.infinity, height: 200, color: Colors.white),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
