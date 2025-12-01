import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PostShimmerLoader extends StatelessWidget {
  const PostShimmerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (_, i) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade200,
            highlightColor: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _shimmerCircle(40),
                    const SizedBox(width: 12),
                    _shimmerBox(width: 120, height: 14),
                  ],
                ),
                const SizedBox(height: 16),
                _shimmerBox(width: double.infinity, height: 14),
                const SizedBox(height: 8),
                _shimmerBox(width: double.infinity, height: 14),
                const SizedBox(height: 8),
                _shimmerBox(width: 200, height: 14),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _shimmerBox(width: 60, height: 14),
                    const SizedBox(width: 20),
                    _shimmerBox(width: 60, height: 14),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _shimmerBox({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _shimmerCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        shape: BoxShape.circle,
      ),
    );
  }
}
